// Web Worker for image processing operations
self.addEventListener('message', async (event) => {
  const { requestId, type, data } = event.data;
  
  try {
    let result;
    switch (type) {
      case 'perspectiveTransform':
        result = await processPerspectiveTransform(data);
        break;
        
      case 'applyFilter':
        result = await applyImageFilter(data);
        break;
        
      default:
        throw new Error('Unknown operation type: ' + type);
    }
    
    self.postMessage({ 
      requestId: requestId,
      type: 'success', 
      result: result 
    });
  } catch (error) {
    self.postMessage({ 
      requestId: requestId,
      type: 'error', 
      error: error.message 
    });
  }
});

// Perspective transform implementation
async function processPerspectiveTransform({ imageData, corners, imageSize }) {
  try {
    // Create canvas and decode image
    const blob = new Blob([imageData], { type: 'image/jpeg' });
    const bitmap = await createImageBitmap(blob);
    
    const srcWidth = bitmap.width;
    const srcHeight = bitmap.height;
    
    // Convert normalized corners to pixel coordinates
    const pixelCorners = corners.map(corner => ({
      x: corner.dx * srcWidth,
      y: corner.dy * srcHeight
    }));
    
    // Find bounding box
    let minX = pixelCorners[0].x;
    let maxX = pixelCorners[0].x;
    let minY = pixelCorners[0].y;
    let maxY = pixelCorners[0].y;
    
    for (const corner of pixelCorners) {
      minX = Math.min(minX, corner.x);
      maxX = Math.max(maxX, corner.x);
      minY = Math.min(minY, corner.y);
      maxY = Math.max(maxY, corner.y);
    }
    
    const outputWidth = Math.round(maxX - minX);
    const outputHeight = Math.round(maxY - minY);
    
    // Create source canvas
    const srcCanvas = new OffscreenCanvas(srcWidth, srcHeight);
    const srcCtx = srcCanvas.getContext('2d');
    srcCtx.drawImage(bitmap, 0, 0);
    const srcImageData = srcCtx.getImageData(0, 0, srcWidth, srcHeight);
    const srcPixels = new Uint32Array(srcImageData.data.buffer);
    
    // Create output canvas
    const outputCanvas = new OffscreenCanvas(outputWidth, outputHeight);
    const outputCtx = outputCanvas.getContext('2d');
    const outputImageData = outputCtx.createImageData(outputWidth, outputHeight);
    const outputPixels = new Uint32Array(outputImageData.data.buffer);
    
    // Get corners
    const [topLeft, topRight, bottomRight, bottomLeft] = pixelCorners;
    
    // Pre-calculate values
    const invWidth = 1.0 / outputWidth;
    const invHeight = 1.0 / outputHeight;
    
    // Process in chunks for better performance
    const chunkSize = 128;
    
    for (let yChunk = 0; yChunk < outputHeight; yChunk += chunkSize) {
      const yEnd = Math.min(yChunk + chunkSize, outputHeight);
      
      for (let xChunk = 0; xChunk < outputWidth; xChunk += chunkSize) {
        const xEnd = Math.min(xChunk + chunkSize, outputWidth);
        
        for (let y = yChunk; y < yEnd; y++) {
          const v = y * invHeight;
          
          // Interpolate left and right edges
          const leftX = topLeft.x + (bottomLeft.x - topLeft.x) * v;
          const leftY = topLeft.y + (bottomLeft.y - topLeft.y) * v;
          const rightX = topRight.x + (bottomRight.x - topRight.x) * v;
          const rightY = topRight.y + (bottomRight.y - topRight.y) * v;
          
          const rowDeltaX = rightX - leftX;
          const rowDeltaY = rightY - leftY;
          
          // Check if row is entirely within bounds
          const minRowX = Math.min(leftX, rightX);
          const maxRowX = Math.max(leftX, rightX);
          const minRowY = Math.min(leftY, rightY);
          const maxRowY = Math.max(leftY, rightY);
          
          const rowInBounds = minRowX >= 0 && maxRowX < srcWidth && 
                            minRowY >= 0 && maxRowY < srcHeight;
          
          for (let x = xChunk; x < xEnd; x++) {
            const u = x * invWidth;
            
            const srcX = Math.round(leftX + rowDeltaX * u);
            const srcY = Math.round(leftY + rowDeltaY * u);
            
            if (rowInBounds || (srcX >= 0 && srcX < srcWidth && srcY >= 0 && srcY < srcHeight)) {
              const srcIndex = srcY * srcWidth + srcX;
              const dstIndex = y * outputWidth + x;
              outputPixels[dstIndex] = srcPixels[srcIndex];
            }
          }
        }
      }
    }
    
    // Put image data back
    outputCtx.putImageData(outputImageData, 0, 0);
    
    // Convert to JPEG
    const processedBlob = await outputCanvas.convertToBlob({ 
      type: 'image/jpeg', 
      quality: 0.85 
    });
    
    const arrayBuffer = await processedBlob.arrayBuffer();
    return new Uint8Array(arrayBuffer);
    
  } catch (error) {
    console.error('Perspective transform error:', error);
    throw error;
  }
}

// Filter implementation
async function applyImageFilter({ imageData, filter }) {
  // Create an ImageData object from the Uint8Array
  const canvas = new OffscreenCanvas(1, 1);
  const ctx = canvas.getContext('2d');
  
  // Decode the image
  const blob = new Blob([imageData], { type: 'image/jpeg' });
  const bitmap = await createImageBitmap(blob);
  
  canvas.width = bitmap.width;
  canvas.height = bitmap.height;
  ctx.drawImage(bitmap, 0, 0);
  
  const imageDataObj = ctx.getImageData(0, 0, canvas.width, canvas.height);
  const pixels = imageDataObj.data;
  
  switch (filter) {
    case 'grayscale':
      for (let i = 0; i < pixels.length; i += 4) {
        const gray = pixels[i] * 0.299 + pixels[i + 1] * 0.587 + pixels[i + 2] * 0.114;
        pixels[i] = gray;
        pixels[i + 1] = gray;
        pixels[i + 2] = gray;
      }
      break;
      
    case 'blackAndWhite':
      for (let i = 0; i < pixels.length; i += 4) {
        const gray = pixels[i] * 0.299 + pixels[i + 1] * 0.587 + pixels[i + 2] * 0.114;
        const bw = gray > 128 ? 255 : 0;
        pixels[i] = bw;
        pixels[i + 1] = bw;
        pixels[i + 2] = bw;
      }
      break;
      
    case 'enhanced':
      // Enhanced contrast using lookup table for speed
      const factor = 1.2;
      const lut = new Uint8Array(256);
      for (let i = 0; i < 256; i++) {
        lut[i] = Math.min(255, Math.max(0, factor * (i - 128) + 128));
      }
      
      for (let i = 0; i < pixels.length; i += 4) {
        pixels[i] = lut[pixels[i]];
        pixels[i + 1] = lut[pixels[i + 1]];
        pixels[i + 2] = lut[pixels[i + 2]];
      }
      break;
      
    case 'document':
      // Document optimization using lookup table
      const docFactor = 1.4;
      const docLut = new Uint8Array(256);
      for (let i = 0; i < 256; i++) {
        docLut[i] = Math.min(255, Math.max(0, docFactor * (i - 128) + 128));
      }
      
      for (let i = 0; i < pixels.length; i += 4) {
        pixels[i] = docLut[pixels[i]];
        pixels[i + 1] = docLut[pixels[i + 1]];
        pixels[i + 2] = docLut[pixels[i + 2]];
      }
      break;
  }
  
  // Put the processed image data back
  ctx.putImageData(imageDataObj, 0, 0);
  
  // Convert back to JPEG
  const processedBlob = await canvas.convertToBlob({ type: 'image/jpeg', quality: 0.85 });
  const arrayBuffer = await processedBlob.arrayBuffer();
  
  return new Uint8Array(arrayBuffer);
}
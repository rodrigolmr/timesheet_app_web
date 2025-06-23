import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:timesheet_app_web/src/features/expense/domain/services/expense_pdf_service.dart';
import 'package:timesheet_app_web/src/features/expense/data/models/expense_model.dart';
import 'package:timesheet_app_web/src/features/company_card/data/models/company_card_model.dart';

class ExpensePdfServiceImpl implements ExpensePdfService {
  final _dateFormat = DateFormat('MMM dd, yyyy');
  final _currencyFormat = NumberFormat.currency(symbol: '\$');

  @override
  Future<Uint8List> generateBulkPdf({
    required List<ExpenseModel> expenses,
    required Map<String, CompanyCardModel> cards,
  }) async {
    final pdf = pw.Document();

    // Process each expense
    for (final expense in expenses) {
      final card = cards[expense.cardId];
      if (card == null) continue;

      // Add expense page
      await _addExpensePage(pdf, expense, card);
    }

    return pdf.save();
  }

  Future<void> _addExpensePage(
    pw.Document pdf,
    ExpenseModel expense,
    CompanyCardModel card,
  ) async {
    // Download document if exists
    pw.ImageProvider? documentImage;
    if (expense.imageUrl != null && expense.imageUrl!.isNotEmpty) {
      try {
        final documentBytes = await _downloadDocument(expense.imageUrl!);
        if (documentBytes != null) {
          // Check if it's an image (not PDF)
          if (_isImageUrl(expense.imageUrl!)) {
            documentImage = pw.MemoryImage(documentBytes);
          }
          // For PDFs, we'll need to handle differently
          else if (_isPdfUrl(expense.imageUrl!)) {
            // For now, we'll add a placeholder for PDF documents
            // In a full implementation, we'd extract pages from the PDF
          }
        }
      } catch (e) {
        print('Error downloading document: $e');
      }
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Compact header with expense information in 2 columns
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Left column
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildCompactInfo('Card:', '${card.holderName} (**** ${card.lastFourDigits})'),
                        pw.SizedBox(height: 8),
                        _buildCompactInfo('Date:', _dateFormat.format(expense.date)),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 20),
                  // Right column
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildCompactInfo('Amount:', _currencyFormat.format(expense.amount)),
                        pw.SizedBox(height: 8),
                        _buildCompactInfo('Description:', expense.description),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 15),
              
              // Document section
              if (documentImage != null) ...[
                pw.Expanded(
                  child: pw.Center(
                    child: pw.Image(
                      documentImage,
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                ),
              ] else if (expense.imageUrl != null && _isPdfUrl(expense.imageUrl!)) ...[
                // PDF placeholder
                pw.Container(
                  height: 100,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Center(
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Icon(
                          pw.IconData(0xe415), // PDF icon placeholder
                          size: 40,
                          color: PdfColors.grey600,
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text(
                          'PDF Document Attached',
                          style: pw.TextStyle(
                            color: PdfColors.grey600,
                            fontSize: 14,
                          ),
                        ),
                        pw.Text(
                          '(Original PDF available separately)',
                          style: pw.TextStyle(
                            color: PdfColors.grey500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // No document
                pw.Container(
                  height: 100,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.grey300,
                      style: pw.BorderStyle.dashed,
                    ),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Center(
                    child: pw.Text(
                      'No receipt document attached',
                      style: pw.TextStyle(
                        color: PdfColors.grey500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  pw.Widget _buildCompactInfo(String label, String value) {
    return pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: '$label ',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey700,
              fontSize: 10,
            ),
          ),
          pw.TextSpan(
            text: value,
            style: const pw.TextStyle(
              color: PdfColors.grey800,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List?> _downloadDocument(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      print('Error downloading document: $e');
    }
    return null;
  }

  bool _isImageUrl(String url) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.heic'];
    final lowercaseUrl = url.toLowerCase();
    return imageExtensions.any((ext) => lowercaseUrl.contains(ext));
  }

  bool _isPdfUrl(String url) {
    return url.toLowerCase().contains('.pdf');
  }
}
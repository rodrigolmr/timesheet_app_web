import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/features/database/presentation/providers/database_providers.dart';

// Import Collection Dialog
class ImportCollectionDialog extends ConsumerStatefulWidget {
  final String collectionName;

  const ImportCollectionDialog({
    super.key, 
    required this.collectionName,
  });

  @override
  ConsumerState<ImportCollectionDialog> createState() => _ImportCollectionDialogState();
}

class _ImportCollectionDialogState extends ConsumerState<ImportCollectionDialog> {
  String? _jsonData;
  String _fileName = 'No file selected';
  bool _isUploading = false;
  bool _overwrite = false;
  bool _isJsonFormat = true; // Por padrão, vamos usar JSON

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: context.responsive<double>(
          xs: double.infinity,
          sm: 500,
          md: 600,
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(context.dimensions.spacingM),
              decoration: BoxDecoration(
                color: context.colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.dimensions.borderRadiusM),
                  topRight: Radius.circular(context.dimensions.borderRadiusM),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.upload_file,
                    color: context.colors.primary,
                    size: context.dimensions.iconSizeL,
                  ),
                  SizedBox(width: context.dimensions.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Import Data to Collection',
                          style: context.textStyles.headline,
                        ),
                        Text(
                          widget.collectionName,
                          style: context.textStyles.caption.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _isUploading 
                        ? null 
                        : () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(context.dimensions.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload File to Import',
                      style: context.textStyles.title,
                    ),
                    SizedBox(height: context.dimensions.spacingM),
                    Text(
                      'Select a file to import into the ${widget.collectionName} collection. The file should match the structure of the Firestore collection.',
                      style: context.textStyles.body,
                    ),
                    SizedBox(height: context.dimensions.spacingS),
                    
                    // Formato selector
                    Row(
                      children: [
                        Text(
                          'Format: ',
                          style: context.textStyles.body,
                        ),
                        SizedBox(width: context.dimensions.spacingS),
                        ChoiceChip(
                          label: Text('JSON'),
                          selected: _isJsonFormat,
                          onSelected: (_) => setState(() => _isJsonFormat = true),
                        ),
                        SizedBox(width: context.dimensions.spacingS),
                        ChoiceChip(
                          label: Text('CSV'),
                          selected: !_isJsonFormat,
                          onSelected: (_) => setState(() => _isJsonFormat = false),
                        ),
                      ],
                    ),
                    
                    TextButton.icon(
                      onPressed: () => _showFormatHelp(context),
                      icon: const Icon(Icons.help_outline, size: 16),
                      label: Text('View ${_isJsonFormat ? 'JSON' : 'CSV'} format example'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        foregroundColor: context.colors.primary,
                      ),
                    ),
                    SizedBox(height: context.dimensions.spacingL),
                    
                    // File picker button
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isUploading ? null : _pickFile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.primary,
                            foregroundColor: context.colors.onPrimary,
                          ),
                          icon: const Icon(Icons.upload_file),
                          label: Text('Select ${_isJsonFormat ? 'JSON' : 'CSV'} File'),
                        ),
                        SizedBox(width: context.dimensions.spacingM),
                        Expanded(
                          child: Text(
                            _fileName,
                            style: context.textStyles.caption.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.dimensions.spacingM),
                    
                    // Preview do conteúdo
                    if (_jsonData != null) ...[                    
                      Text(
                        'File Preview',
                        style: context.textStyles.subtitle,
                      ),
                      SizedBox(height: context.dimensions.spacingS),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: context.colors.surface),
                            borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                          ),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(context.dimensions.spacingS),
                            child: Text(
                              _jsonData!.length > 1000 
                                  ? '${_jsonData!.substring(0, 1000)}...'
                                  : _jsonData!,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: context.dimensions.spacingM),                    
                    ],
                    
                    // Overwrite option
                    CheckboxListTile(
                      title: Text(
                        'Overwrite existing documents',
                        style: context.textStyles.body,
                      ),
                      subtitle: Text(
                        'If enabled, documents with the same ID will be replaced',
                        style: context.textStyles.caption,
                      ),
                      value: _overwrite,
                      onChanged: _isUploading 
                          ? null 
                          : (value) => setState(() => _overwrite = value ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    
                    SizedBox(height: context.dimensions.spacingL),
                    
                    // Import button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _isUploading 
                              ? null 
                              : () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        SizedBox(width: context.dimensions.spacingM),
                        ElevatedButton(
                          onPressed: (_jsonData == null || _isUploading) 
                              ? null 
                              : _handleImport,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.primary,
                            foregroundColor: context.colors.onPrimary,
                          ),
                          child: _isUploading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: context.colors.onPrimary,
                                  ),
                                )
                              : const Text('Import Data'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickFile() async {
    // Criar um elemento de input de arquivo invisível
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = _isJsonFormat ? '.json' : '.csv';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();
        
        // Ler o conteúdo do arquivo como texto
        reader.readAsText(file);
        
        reader.onLoad.listen((event) {
          setState(() {
            _jsonData = reader.result as String;
            _fileName = file.name;
          });
        });

        reader.onError.listen((event) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao ler o arquivo: ${reader.error}'),
              backgroundColor: context.colors.error,
            ),
          );
        });
      }
    });
  }

  bool _validateFormat() {
    if (_jsonData == null || _jsonData!.trim().isEmpty) {
      return false;
    }
    
    try {
      if (_isJsonFormat) {
        // Validação para JSON
        final jsonData = json.decode(_jsonData!);
        
        // Verificar se é um array para importação em lote
        if (jsonData is! List) {
          print('JSON validation error: expected an array of documents');
          return false;
        }
        
        // Verificar se há documentos no array
        if ((jsonData as List).isEmpty) {
          print('JSON validation error: document array is empty');
          return false;
        }
        
        // Verificar todos os documentos
        for (int i = 0; i < jsonData.length; i++) {
          final doc = jsonData[i];
          if (doc is! Map<String, dynamic>) {
            print('JSON validation error: document at index $i is not an object');
            return false;
          }
          
          // Verificar campos importantes para coleções específicas
          if (widget.collectionName == 'job_records') {
            if (!doc.containsKey('employees')) {
              print('JSON validation warning: missing "employees" field in job_records document at index $i');
            }
            
            if (!doc.containsKey('created_at') || !doc.containsKey('updated_at')) {
              print('JSON validation warning: missing timestamp fields (created_at/updated_at) in document at index $i');
            }
          }
        }
        
        return true;
      } else {
        // Validação para CSV
        final lines = _jsonData!.split('\n').where((line) => line.trim().isNotEmpty).toList();
        if (lines.isEmpty) {
          return false;
        }
        
        // Verifica se há pelo menos um cabeçalho e uma linha de dados
        if (lines.length < 2) {
          return false;
        }
        
        // Verifica o número de colunas no cabeçalho
        final headers = _parseCSVLine(lines[0]);
        if (headers.isEmpty) {
          return false;
        }
        
        // Verifica se o cabeçalho contém campos importantes para coleções específicas
        if (widget.collectionName == 'job_records') {
          if (!headers.contains('employees')) {
            print('CSV validation warning: missing "employees" field in job_records CSV');
          }
          if (!headers.contains('created_at') || !headers.contains('updated_at')) {
            print('CSV validation warning: missing timestamp fields (created_at/updated_at) in CSV');
          }
        }
        
        // Verifica se as linhas de dados têm o mesmo número de colunas que o cabeçalho
        final headerColumnCount = headers.length;
        for (int i = 1; i < lines.length; i++) {
          final dataColumns = _parseCSVLine(lines[i]);
          if (dataColumns.length != headerColumnCount) {
            print('CSV validation error: Line $i has ${dataColumns.length} columns, expected $headerColumnCount');
            return false;
          }
        }
        
        return true;
      }
    } catch (e) {
      print('Format validation error: $e');
      return false;
    }
  }
  
  List<String> _parseCSVLine(String line) {
    List<String> result = [];
    bool inQuotes = false;
    String currentValue = '';
    
    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      
      if (char == '"') {
        // Se encontrarmos aspas, alternamos o estado
        inQuotes = !inQuotes;
        currentValue += char;
      } else if (char == ',' && !inQuotes) {
        // Se for uma vírgula fora de aspas, finalizou um campo
        result.add(currentValue);
        currentValue = '';
      } else {
        // Qualquer outro caractere
        currentValue += char;
      }
    }
    
    // Adiciona o último campo
    if (currentValue.isNotEmpty) {
      result.add(currentValue);
    }
    
    return result;
  }
  
  void _handleImport() async {
    if (_jsonData == null) return;
    
    // Validação básica do formato
    if (!_validateFormat()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isJsonFormat 
              ? 'JSON inválido. Verifique se o arquivo contém um array de documentos no formato correto.'
              : 'CSV inválido. Verifique se o arquivo está no formato correto com cabeçalhos e valores separados por vírgula.'),
          backgroundColor: context.colors.error,
          duration: const Duration(seconds: 5),
        ),
      );
      return;
    }
    
    setState(() {
      _isUploading = true;
    });
    
    try {
      final importedCount = await ref.read(databaseOperationsProvider.notifier).importData(
        widget.collectionName,
        _jsonData!,
        isJson: _isJsonFormat,
        overwrite: _overwrite,
      );
      
      if (mounted) {
        Navigator.of(context).pop();
        
        // Se não importou nenhum documento, mostrar uma mensagem de erro mais clara
        if (importedCount <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Nenhum documento foi importado. Verifique se o formato do arquivo corresponde à estrutura da coleção ${widget.collectionName}.'),
              backgroundColor: context.colors.warning,
              duration: const Duration(seconds: 5),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully imported $importedCount documents to ${widget.collectionName}'),
              backgroundColor: context.colors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error importing data: $e'),
            backgroundColor: context.colors.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
  
  // Mostra um exemplo do formato para a coleção atual
  void _showFormatHelp(BuildContext context) {
    final exampleData = _isJsonFormat 
        ? _formatJsonString(_getExampleJson(widget.collectionName))
        : _getExampleCsv(widget.collectionName);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${_isJsonFormat ? 'JSON' : 'CSV'} Format Example for ${widget.collectionName}'),
        content: Container(
          width: double.maxFinite,
          constraints: BoxConstraints(
            maxHeight: 400,
            maxWidth: 600,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your file should have the following structure:',
                style: context.textStyles.body,
              ),
              SizedBox(height: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    border: Border.all(color: context.colors.surface),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: SelectableText(
                    exampleData,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Important notes:',
                style: context.textStyles.title.copyWith(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                _isJsonFormat
                    ? '• The file must contain a JSON array of objects\n'
                      '• Each object represents a document in the collection\n'
                      '• The ID field is optional - if not provided, a new ID will be generated\n'
                      '• created_at and updated_at are automatically handled by Firestore, but can be provided\n'
                      '• Dates should be in ISO format: YYYY-MM-DDTHH:MM:SS\n'
                      '• Array fields must be properly formatted as JSON arrays'
                    : '• The first line must contain the field names\n'
                      '• All subsequent lines must have the same number of columns\n'
                      '• Fields are separated by commas\n'
                      '• For dates, use the format YYYY-MM-DD\n'
                      '• For datetime fields like created_at and updated_at, use ISO format: YYYY-MM-DDTHH:MM:SS\n'
                      '• Boolean values should be "true" or "false"\n'
                      '• The ID field is optional - if not provided, a new ID will be generated\n'
                      '• created_at and updated_at are automatically handled by Firestore, but can be provided\n'
                      '• Array values should be formatted as JSON and enclosed in double quotes\n'
                      '• Use escaped quotes within JSON strings (e.g. "["{\\"id\\":\\"value\\"}"]")',
                style: context.textStyles.body.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton.icon(
            onPressed: () {
              _copyToClipboard(exampleData);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Copy Example'),
          ),
        ],
      ),
    );
  }
  
  // Copia o texto para a área de transferência
  void _copyToClipboard(String text) {
    html.window.navigator.clipboard?.writeText(text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Example copied to clipboard'),
        backgroundColor: context.colors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  // Formata um objeto JSON em string legível
  String _formatJsonString(String jsonString) {
    try {
      final object = json.decode(jsonString);
      return const JsonEncoder.withIndent('  ').convert(object);
    } catch (e) {
      return jsonString;
    }
  }
  
  // Retorna um exemplo de JSON para a coleção fornecida
  String _getExampleJson(String collectionName) {
    switch (collectionName) {
      case 'users':
        return '''[
  {
    "auth_uid": "auth123",
    "email": "user1@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "role": "user",
    "is_active": true,
    "created_at": "2023-05-15T10:30:00",
    "updated_at": "2023-05-15T10:30:00"
  },
  {
    "auth_uid": "auth456",
    "email": "user2@example.com",
    "first_name": "Jane",
    "last_name": "Smith",
    "role": "admin",
    "is_active": true,
    "created_at": "2023-05-16T09:15:00",
    "updated_at": "2023-05-16T15:45:00"
  }
]''';
      
      case 'employees':
        return '''[
  {
    "first_name": "John",
    "last_name": "Doe",
    "is_active": true,
    "created_at": "2023-05-15T10:30:00",
    "updated_at": "2023-05-15T10:30:00"
  },
  {
    "first_name": "Jane",
    "last_name": "Smith",
    "is_active": true,
    "created_at": "2023-05-16T09:15:00",
    "updated_at": "2023-05-16T15:45:00"
  },
  {
    "first_name": "Michael",
    "last_name": "Johnson",
    "is_active": false,
    "created_at": "2023-05-17T11:20:00",
    "updated_at": "2023-05-17T11:20:00"
  }
]''';
      
      case 'company_cards':
        return '''[
  {
    "holder_name": "John Doe",
    "last_four_digits": "1234",
    "is_active": true,
    "created_at": "2023-05-15T10:30:00",
    "updated_at": "2023-05-15T10:30:00"
  },
  {
    "holder_name": "Jane Smith",
    "last_four_digits": "5678",
    "is_active": true,
    "created_at": "2023-05-16T09:15:00",
    "updated_at": "2023-05-16T15:45:00"
  }
]''';
      
      case 'expenses':
        return '''[
  {
    "user_id": "user123",
    "card_id": "card456",
    "amount": 125.50,
    "date": "2023-05-15",
    "description": "Office supplies",
    "image_url": "",
    "created_at": "2023-05-15T10:30:00",
    "updated_at": "2023-05-15T10:30:00"
  },
  {
    "user_id": "user789",
    "card_id": "card456",
    "amount": 45.99,
    "date": "2023-05-16",
    "description": "Lunch meeting",
    "image_url": "",
    "created_at": "2023-05-16T09:15:00",
    "updated_at": "2023-05-16T15:45:00"
  }
]''';
      
      case 'job_records':
        return '''[
  {
    "job_name": "Building Project A",
    "date": "2023-05-15",
    "user_id": "user123",
    "territorial_manager": "Manager X",
    "job_size": "Large",
    "material": "Wood",
    "job_description": "Construction of residential building",
    "foreman": "Foreman Y",
    "vehicle": "Vehicle Z",
    "employees": [
      {
        "employee_id": "emp1",
        "employee_name": "John Doe",
        "start_time": "08:00",
        "finish_time": "16:00",
        "hours": 8,
        "travel_hours": 1,
        "meal": 1
      },
      {
        "employee_id": "emp2",
        "employee_name": "Jane Smith",
        "start_time": "09:00",
        "finish_time": "15:00",
        "hours": 6,
        "travel_hours": 0.5,
        "meal": 1
      }
    ],
    "created_at": "2023-05-15T10:30:00",
    "updated_at": "2023-05-15T10:30:00"
  },
  {
    "job_name": "Renovation Project B",
    "date": "2023-05-16",
    "user_id": "user456",
    "territorial_manager": "Manager Y",
    "job_size": "Medium",
    "material": "Steel",
    "job_description": "Renovation of office space",
    "foreman": "Foreman Z",
    "vehicle": "Vehicle X",
    "employees": [
      {
        "employee_id": "emp3",
        "employee_name": "Michael Johnson",
        "start_time": "08:30",
        "finish_time": "15:30",
        "hours": 7,
        "travel_hours": 1.5,
        "meal": 1
      }
    ],
    "created_at": "2023-05-16T09:15:00",
    "updated_at": "2023-05-16T15:45:00"
  }
]''';
      
      default:
        return '''[
  {
    "id": "1",
    "field1": "value1",
    "field2": "value2",
    "field3": "value3",
    "created_at": "2023-05-15T10:30:00",
    "updated_at": "2023-05-15T10:30:00"
  },
  {
    "id": "2",
    "field1": "value4",
    "field2": "value5",
    "field3": "value6",
    "created_at": "2023-05-16T09:15:00",
    "updated_at": "2023-05-16T15:45:00"
  }
]''';
    }
  }
  
  // Retorna um exemplo de CSV para a coleção fornecida
  String _getExampleCsv(String collectionName) {
    switch (collectionName) {
      case 'users':
        return 'auth_uid,email,first_name,last_name,role,is_active,created_at,updated_at\n'
               'auth123,user1@example.com,John,Doe,user,true,2023-05-15T10:30:00,2023-05-15T10:30:00\n'
               'auth456,user2@example.com,Jane,Smith,admin,true,2023-05-16T09:15:00,2023-05-16T15:45:00';
      
      case 'employees':
        return 'first_name,last_name,is_active,created_at,updated_at\n'
               'John,Doe,true,2023-05-15T10:30:00,2023-05-15T10:30:00\n'
               'Jane,Smith,true,2023-05-16T09:15:00,2023-05-16T15:45:00\n'
               'Michael,Johnson,false,2023-05-17T11:20:00,2023-05-17T11:20:00';
      
      case 'company_cards':
        return 'holder_name,last_four_digits,is_active,created_at,updated_at\n'
               'John Doe,1234,true,2023-05-15T10:30:00,2023-05-15T10:30:00\n'
               'Jane Smith,5678,true,2023-05-16T09:15:00,2023-05-16T15:45:00';
      
      case 'expenses':
        return 'user_id,card_id,amount,date,description,image_url,created_at,updated_at\n'
               'user123,card456,125.50,2023-05-15,Office supplies,,2023-05-15T10:30:00,2023-05-15T10:30:00\n'
               'user789,card456,45.99,2023-05-16,Lunch meeting,,2023-05-16T09:15:00,2023-05-16T15:45:00';
      
      case 'job_records':
        return 'job_name,date,user_id,territorial_manager,job_size,material,job_description,foreman,vehicle,employees,created_at,updated_at\n'
               'Building Project A,2023-05-15,user123,Manager X,Large,Wood,Construction of residential building,Foreman Y,Vehicle Z,"[{""employee_id"":""emp1"",""employee_name"":""John Doe"",""start_time"":""08:00"",""finish_time"":""16:00"",""hours"":8,""travel_hours"":1,""meal"":1},{""employee_id"":""emp2"",""employee_name"":""Jane Smith"",""start_time"":""09:00"",""finish_time"":""15:00"",""hours"":6,""travel_hours"":0.5,""meal"":1}]",2023-05-15T10:30:00,2023-05-15T10:30:00\n'
               'Renovation Project B,2023-05-16,user456,Manager Y,Medium,Steel,Renovation of office space,Foreman Z,Vehicle X,"[{""employee_id"":""emp3"",""employee_name"":""Michael Johnson"",""start_time"":""08:30"",""finish_time"":""15:30"",""hours"":7,""travel_hours"":1.5,""meal"":1}]",2023-05-16T09:15:00,2023-05-16T15:45:00';
      
      default:
        return 'id,field1,field2,field3,created_at,updated_at\n'
               '1,value1,value2,value3,2023-05-15T10:30:00,2023-05-15T10:30:00\n'
               '2,value4,value5,value6,2023-05-16T09:15:00,2023-05-16T15:45:00';
    }
  }
}
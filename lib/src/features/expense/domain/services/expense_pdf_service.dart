import 'dart:typed_data';

import 'package:timesheet_app_web/src/features/expense/data/models/expense_model.dart';
import 'package:timesheet_app_web/src/features/company_card/data/models/company_card_model.dart';

abstract class ExpensePdfService {
  Future<Uint8List> generateBulkPdf({
    required List<ExpenseModel> expenses,
    required Map<String, CompanyCardModel> cards,
  });
}
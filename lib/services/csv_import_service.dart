import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/utils.dart';
import '../data/models/transaction.dart';

class CsvImportService {
  static final CsvImportService _instance = CsvImportService._internal();
  factory CsvImportService() => _instance;
  CsvImportService._internal();

  static CsvImportService get instance => _instance;

  /// Pick and read CSV file
  Future<List<List<dynamic>>?> pickAndReadCsvFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);

        // Check file size
        final fileSize = await file.length();
        if (fileSize > AppConstants.maxCsvFileSize) {
          throw Exception(
            'File size ${Utils.formatFileSize(fileSize)} exceeds maximum allowed size ${Utils.formatFileSize(AppConstants.maxCsvFileSize)}',
          );
        }

        final input = await file.readAsString();
        final csvData = const CsvToListConverter().convert(input);

        return csvData;
      }

      return null;
    } catch (e) {
      throw Exception('Failed to read CSV file: ${e.toString()}');
    }
  }

  /// Parse CSV data to transactions
  /// Expected CSV format: Name, Amount, Currency, Type, Date, Label, Note
  List<TransactionModel> parseCsvToTransactions(
    List<List<dynamic>> csvData,
    String accountBookId,
  ) {
    final transactions = <TransactionModel>[];

    if (csvData.isEmpty) return transactions;

    // Skip header row if it exists
    final dataRows = csvData.length > 1 && _isHeaderRow(csvData[0])
        ? csvData.skip(1).toList()
        : csvData;

    for (int i = 0; i < dataRows.length; i++) {
      try {
        final row = dataRows[i];

        if (row.length < 5) {
          throw Exception(
            'Row ${i + 1}: Insufficient columns (minimum 5 required)',
          );
        }

        final name = row[0]?.toString().trim() ?? '';
        if (name.isEmpty) {
          throw Exception('Row ${i + 1}: Name is required');
        }

        final amountStr = row[1]?.toString().trim() ?? '';
        final amount = double.tryParse(amountStr);
        if (amount == null || amount <= 0) {
          throw Exception('Row ${i + 1}: Invalid amount "$amountStr"');
        }

        final currency =
            row[2]?.toString().trim() ?? AppConstants.defaultCurrency;

        final typeStr = row[3]?.toString().trim().toLowerCase() ?? '';
        if (typeStr != 'income' && typeStr != 'expense') {
          throw Exception('Row ${i + 1}: Type must be "income" or "expense"');
        }

        final dateStr = row[4]?.toString().trim() ?? '';
        final date = _parseDate(dateStr);
        if (date == null) {
          throw Exception('Row ${i + 1}: Invalid date format "$dateStr"');
        }

        // final label = row.length > 5 ? row[5]?.toString().trim() : null;
        final note = row.length > 6 ? row[6]?.toString().trim() : null;

        final now = DateTime.now();
        final transaction = TransactionModel(
          id: Utils.generateId(),
          accountBookId: accountBookId,
          name: name,
          amount: amount,
          currency: currency,
          type: typeStr,
          date: date,
          labelId: null, // Labels need to be resolved separately
          note: note?.isNotEmpty == true ? note : null,
          createdAt: now,
          updatedAt: now,
        );

        transactions.add(transaction);
      } catch (e) {
        throw Exception('Row ${i + 1}: ${e.toString()}');
      }
    }

    return transactions;
  }

  /// Check if the first row is a header row
  bool _isHeaderRow(List<dynamic> row) {
    if (row.isEmpty) return false;

    final firstCell = row[0]?.toString().toLowerCase() ?? '';
    return [
      'name',
      'description',
      'title',
      'transaction',
    ].any((header) => firstCell.contains(header));
  }

  /// Parse date string to DateTime
  DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) return null;

    // Try common date formats
    final formats = [
      'yyyy-MM-dd',
      'dd/MM/yyyy',
      'MM/dd/yyyy',
      'dd-MM-yyyy',
      'MM-dd-yyyy',
      'yyyy/MM/dd',
    ];

    for (final format in formats) {
      try {
        // Simple date parsing - in a real app, you might want to use intl package
        if (format == 'yyyy-MM-dd' &&
            RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateStr)) {
          final parts = dateStr.split('-');
          return DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        }
        // Add more format parsing as needed
      } catch (e) {
        continue;
      }
    }

    // Try DateTime.parse as fallback
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return null;
    }
  }
}

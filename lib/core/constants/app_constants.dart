class AppConstants {
  // App Info
  static const String appName = 'My Accounting';
  static const String appVersion = '1.0.0';

  // Database
  static const String accountBooksBox = 'account_books';
  static const String transactionsBox = 'transactions';
  static const String labelsBox = 'labels';

  // Currency
  static const String defaultCurrency = 'USD';
  static const List<String> supportedCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CNY',
    'CAD',
    'AUD',
    'CHF',
  ];

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String displayDateFormat = 'MMM dd, yyyy';

  // Transaction Types
  static const String incomeType = 'income';
  static const String expenseType = 'expense';

  // CSV Import
  static const int maxCsvFileSize = 10 * 1024 * 1024; // 10MB

  // UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
}

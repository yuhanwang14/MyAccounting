import 'package:intl/intl.dart';

extension StringExtensions on String {
  /// Capitalizes the first letter of the string
  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Checks if string is a valid email
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Checks if string is a valid number
  bool get isNumeric {
    return double.tryParse(this) != null;
  }
}

extension DoubleExtensions on double {
  /// Formats double as currency with symbol
  String toCurrency([String currency = 'USD']) {
    final formatter = NumberFormat.currency(
      symbol: _getCurrencySymbol(currency),
      decimalDigits: 2,
    );
    return formatter.format(this);
  }

  /// Formats double with commas for thousands
  String toFormattedString([int decimalPlaces = 2]) {
    final formatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: decimalPlaces,
    );
    return formatter.format(this).trim();
  }
}

extension DateTimeExtensions on DateTime {
  /// Formats DateTime to readable string
  String toFormattedString([String pattern = 'MMM dd, yyyy']) {
    return DateFormat(pattern).format(this);
  }

  /// Checks if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Checks if date is in current month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Gets start of month
  DateTime get startOfMonth {
    return DateTime(year, month, 1);
  }

  /// Gets end of month
  DateTime get endOfMonth {
    return DateTime(year, month + 1, 1).subtract(const Duration(days: 1));
  }
}

extension ListExtensions<T> on List<T> {
  /// Safely gets element at index
  T? elementAtOrNull(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }
}

// Helper function to get currency symbol
String _getCurrencySymbol(String currencyCode) {
  switch (currencyCode.toUpperCase()) {
    case 'USD':
      return '\$';
    case 'EUR':
      return '€';
    case 'GBP':
      return '£';
    case 'JPY':
      return '¥';
    case 'CNY':
      return '¥';
    case 'CAD':
      return 'CA\$';
    case 'AUD':
      return 'AU\$';
    case 'CHF':
      return 'CHF';
    default:
      return currencyCode;
  }
}

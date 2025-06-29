import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/transaction.dart';
import '../../data/models/label.dart';
import '../../services/database_service.dart';
import 'account_book_provider.dart';

class MonthlyTransactionData {
  final int year;
  final int month;
  final List<TransactionModel> transactions;
  final double totalIncome;
  final double totalExpense;

  MonthlyTransactionData({
    required this.year,
    required this.month,
    required this.transactions,
    required this.totalIncome,
    required this.totalExpense,
  });

  double get balance => totalIncome - totalExpense;

  String get monthName {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}

class TransactionState {
  final List<MonthlyTransactionData> monthlyData;
  final bool isLoading;
  final String? error;

  TransactionState({
    this.monthlyData = const [],
    this.isLoading = false,
    this.error,
  });

  TransactionState copyWith({
    List<MonthlyTransactionData>? monthlyData,
    bool? isLoading,
    String? error,
  }) {
    return TransactionState(
      monthlyData: monthlyData ?? this.monthlyData,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
  return TransactionNotifier(ref);
});

final labelsProvider =
    StateNotifierProvider<LabelsNotifier, List<LabelModel>>((ref) {
  return LabelsNotifier();
});

class TransactionNotifier extends StateNotifier<TransactionState> {
  TransactionNotifier(this._ref) : super(TransactionState()) {
    _loadInitialData();
  }

  final Ref _ref;
  final _databaseService = DatabaseService.instance;

  Future<void> _loadInitialData() async {
    state = state.copyWith(isLoading: true);

    try {
      final now = DateTime.now();
      await _loadMonthData(now.year, now.month);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> _loadMonthData(int year, int month) async {
    try {
      final currentAccountBookId = _ref.read(currentAccountBookProvider);

      // If no current account book is selected, return empty data
      if (currentAccountBookId == null) {
        state = state.copyWith(
          monthlyData: [],
          isLoading: false,
          error: null,
        );
        return;
      }

      final allTransactions = _databaseService.transactionsBox.values.toList();

      // Filter transactions for the specific month and current account book
      final monthTransactions = allTransactions.where((transaction) {
        return transaction.date.year == year &&
            transaction.date.month == month &&
            transaction.accountBookId == currentAccountBookId;
      }).toList();

      // Sort by date (newest first)
      monthTransactions.sort((a, b) => b.date.compareTo(a.date));

      // Calculate totals
      double totalIncome = 0;
      double totalExpense = 0;

      for (final transaction in monthTransactions) {
        if (transaction.isIncome) {
          totalIncome += transaction.amount;
        } else {
          totalExpense += transaction.amount;
        }
      }

      final monthlyData = MonthlyTransactionData(
        year: year,
        month: month,
        transactions: monthTransactions,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
      );

      // Update state - replace or add the month data
      final updatedMonthlyData = [...state.monthlyData];
      final existingIndex = updatedMonthlyData.indexWhere(
        (data) => data.year == year && data.month == month,
      );

      if (existingIndex >= 0) {
        updatedMonthlyData[existingIndex] = monthlyData;
      } else {
        updatedMonthlyData.add(monthlyData);
        // Sort by year and month (newest first)
        updatedMonthlyData.sort((a, b) {
          if (a.year != b.year) return b.year.compareTo(a.year);
          return b.month.compareTo(a.month);
        });
      }

      state = state.copyWith(
        monthlyData: updatedMonthlyData,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> refreshData() async {
    final currentAccountBookId = _ref.read(currentAccountBookProvider);
    if (currentAccountBookId == null) return;

    state = state.copyWith(isLoading: true, monthlyData: []);
    await _loadInitialData();
  }

  Future<void> loadPreviousMonth() async {
    if (state.monthlyData.isEmpty) return;

    final lastMonth = state.monthlyData.last;
    final previousMonth = DateTime(lastMonth.year, lastMonth.month - 1);
    await _loadMonthData(previousMonth.year, previousMonth.month);
  }

  Future<void> loadNextMonth() async {
    if (state.monthlyData.isEmpty) return;

    final firstMonth = state.monthlyData.first;
    final nextMonth = DateTime(firstMonth.year, firstMonth.month + 1);

    // Don't load future months beyond current month
    final now = DateTime.now();
    if (nextMonth.year > now.year ||
        (nextMonth.year == now.year && nextMonth.month > now.month)) {
      return;
    }

    await _loadMonthData(nextMonth.year, nextMonth.month);
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _databaseService.transactionsBox.put(transaction.id, transaction);
    await _loadMonthData(transaction.date.year, transaction.date.month);
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _databaseService.transactionsBox.put(transaction.id, transaction);
    await _loadMonthData(transaction.date.year, transaction.date.month);
  }

  Future<void> deleteTransaction(String id) async {
    final transaction = _databaseService.transactionsBox.get(id);
    if (transaction != null) {
      await _databaseService.transactionsBox.delete(id);
      await _loadMonthData(transaction.date.year, transaction.date.month);
    }
  }
}

class LabelsNotifier extends StateNotifier<List<LabelModel>> {
  LabelsNotifier() : super([]) {
    _loadLabels();
  }

  final _databaseService = DatabaseService.instance;

  Future<void> _loadLabels() async {
    final labels = _databaseService.labelsBox.values.toList();
    state = labels;
  }

  Future<void> addLabel(LabelModel label) async {
    await _databaseService.labelsBox.put(label.id, label);
    state = [...state, label];
  }

  LabelModel? getLabel(String? id) {
    if (id == null) return null;
    try {
      return state.firstWhere((label) => label.id == id);
    } catch (e) {
      return null;
    }
  }
}

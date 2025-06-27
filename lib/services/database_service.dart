import 'package:hive_flutter/hive_flutter.dart';

import '../core/constants/app_constants.dart';
import '../data/models/account_book.dart';
import '../data/models/label.dart';
import '../data/models/transaction.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static DatabaseService get instance => _instance;

  late Box<AccountBookModel> _accountBooksBox;
  late Box<TransactionModel> _transactionsBox;
  late Box<LabelModel> _labelsBox;

  Box<AccountBookModel> get accountBooksBox => _accountBooksBox;
  Box<TransactionModel> get transactionsBox => _transactionsBox;
  Box<LabelModel> get labelsBox => _labelsBox;

  Future<void> initialize() async {
    // Register adapters
    Hive.registerAdapter(AccountBookModelAdapter());
    Hive.registerAdapter(TransactionModelAdapter());
    Hive.registerAdapter(LabelModelAdapter());

    // Open boxes
    _accountBooksBox = await Hive.openBox<AccountBookModel>(
      AppConstants.accountBooksBox,
    );
    _transactionsBox = await Hive.openBox<TransactionModel>(
      AppConstants.transactionsBox,
    );
    _labelsBox = await Hive.openBox<LabelModel>(AppConstants.labelsBox);
  }

  Future<void> clearAllData() async {
    await _accountBooksBox.clear();
    await _transactionsBox.clear();
    await _labelsBox.clear();
  }

  Future<void> close() async {
    await _accountBooksBox.close();
    await _transactionsBox.close();
    await _labelsBox.close();
  }
}

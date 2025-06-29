import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/account_book.dart';
import '../../services/database_service.dart';

final accountBooksProvider =
    StateNotifierProvider<AccountBooksNotifier, List<AccountBookModel>>((ref) {
  return AccountBooksNotifier();
});

final currentAccountBookProvider =
    StateNotifierProvider<CurrentAccountBookNotifier, String?>((ref) {
  return CurrentAccountBookNotifier(ref);
});

class AccountBooksNotifier extends StateNotifier<List<AccountBookModel>> {
  AccountBooksNotifier() : super([]) {
    _loadAccountBooks();
  }

  final _databaseService = DatabaseService.instance;

  Future<void> _loadAccountBooks() async {
    final accountBooks = _databaseService.accountBooksBox.values.toList();
    state = accountBooks;

    // Create default account book if none exists
    if (accountBooks.isEmpty) {
      await _createDefaultAccountBook();
    }
  }

  Future<void> _createDefaultAccountBook() async {
    final defaultAccountBook = AccountBookModel(
      id: const Uuid().v4(),
      name: 'Main Account Book',
      description: 'Your primary account book for tracking finances',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await addAccountBook(defaultAccountBook);
  }

  Future<void> addAccountBook(AccountBookModel accountBook) async {
    await _databaseService.accountBooksBox.put(accountBook.id, accountBook);
    state = [...state, accountBook];
  }

  Future<void> updateAccountBook(AccountBookModel accountBook) async {
    await _databaseService.accountBooksBox.put(accountBook.id, accountBook);
    state = [
      for (final book in state)
        if (book.id == accountBook.id) accountBook else book,
    ];
  }

  Future<void> deleteAccountBook(String id) async {
    await _databaseService.accountBooksBox.delete(id);
    state = state.where((book) => book.id != id).toList();
  }

  AccountBookModel? getAccountBook(String id) {
    try {
      return state.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }
}

class CurrentAccountBookNotifier extends StateNotifier<String?> {
  CurrentAccountBookNotifier(this._ref) : super(null) {
    _initializeCurrentAccountBook();
  }

  final Ref _ref;

  Future<void> _initializeCurrentAccountBook() async {
    // Try to get saved current account book ID from preferences
    // For now, we'll just use the first available account book
    final accountBooks = _ref.read(accountBooksProvider);

    if (accountBooks.isNotEmpty) {
      state = accountBooks.first.id;
    }
  }

  void setCurrentAccountBook(String accountBookId) {
    state = accountBookId;
    // Here you could also save to SharedPreferences for persistence
  }

  AccountBookModel? getCurrentAccountBook() {
    if (state == null) return null;
    return _ref.read(accountBooksProvider.notifier).getAccountBook(state!);
  }
}

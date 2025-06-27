import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/account_book.dart';
import '../../services/database_service.dart';

final accountBooksProvider =
    StateNotifierProvider<AccountBooksNotifier, List<AccountBookModel>>((ref) {
      return AccountBooksNotifier();
    });

class AccountBooksNotifier extends StateNotifier<List<AccountBookModel>> {
  AccountBooksNotifier() : super([]) {
    _loadAccountBooks();
  }

  final _databaseService = DatabaseService.instance;

  Future<void> _loadAccountBooks() async {
    final accountBooks = _databaseService.accountBooksBox.values.toList();
    state = accountBooks;
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

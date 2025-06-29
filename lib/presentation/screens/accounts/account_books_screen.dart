import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/account_book.dart';
import '../../providers/account_book_provider.dart';

class AccountBooksScreen extends ConsumerWidget {
  const AccountBooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountBooks = ref.watch(accountBooksProvider);
    final currentAccountBookId = ref.watch(currentAccountBookProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Books'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: accountBooks.isEmpty
          ? _buildEmptyState(context)
          : _buildAccountBooksList(
              context, ref, accountBooks, currentAccountBookId),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAccountBookDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No account books yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Create your first account book to organize your finances',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountBooksList(BuildContext context, WidgetRef ref,
      List<AccountBookModel> accountBooks, String? currentAccountBookId) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: accountBooks.length,
      itemBuilder: (context, index) {
        final accountBook = accountBooks[index];
        final isCurrentBook = accountBook.id == currentAccountBookId;

        return Card(
          margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
          elevation: isCurrentBook ? 4 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            side: isCurrentBook
                ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
                : BorderSide.none,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppConstants.defaultPadding),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isCurrentBook
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: Icon(
                Icons.book,
                color: isCurrentBook ? Colors.white : Colors.grey[600],
              ),
            ),
            title: Text(
              accountBook.name,
              style: TextStyle(
                fontWeight: isCurrentBook ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (accountBook.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    accountBook.description,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  'Created: ${DateFormat(AppConstants.displayDateFormat).format(accountBook.createdAt)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                if (isCurrentBook) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'CURRENT',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'select':
                    ref
                        .read(currentAccountBookProvider.notifier)
                        .setCurrentAccountBook(accountBook.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Selected "${accountBook.name}" as current account book')),
                    );
                    break;
                  case 'edit':
                    _showEditAccountBookDialog(context, ref, accountBook);
                    break;
                  case 'delete':
                    _showDeleteConfirmationDialog(context, ref, accountBook);
                    break;
                }
              },
              itemBuilder: (context) => [
                if (!isCurrentBook)
                  const PopupMenuItem(
                    value: 'select',
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline),
                        SizedBox(width: 8),
                        Text('Set as Current'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                if (!isCurrentBook)
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
              ],
            ),
            onTap: () {
              if (!isCurrentBook) {
                ref
                    .read(currentAccountBookProvider.notifier)
                    .setCurrentAccountBook(accountBook.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Selected "${accountBook.name}" as current account book')),
                );
              }
            },
          ),
        );
      },
    );
  }

  void _showAddAccountBookDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _AccountBookDialog(
        title: 'Create Account Book',
        onSave: (name, description) async {
          final accountBook = AccountBookModel(
            id: const Uuid().v4(),
            name: name,
            description: description,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await ref
              .read(accountBooksProvider.notifier)
              .addAccountBook(accountBook);

          // If this is the first account book, set it as current
          final accountBooks = ref.read(accountBooksProvider);
          if (accountBooks.length == 1) {
            ref
                .read(currentAccountBookProvider.notifier)
                .setCurrentAccountBook(accountBook.id);
          }

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Account book "${accountBook.name}" created successfully')),
            );
          }
        },
      ),
    );
  }

  void _showEditAccountBookDialog(
      BuildContext context, WidgetRef ref, AccountBookModel accountBook) {
    showDialog(
      context: context,
      builder: (context) => _AccountBookDialog(
        title: 'Edit Account Book',
        initialName: accountBook.name,
        initialDescription: accountBook.description,
        onSave: (name, description) async {
          final updatedAccountBook = accountBook.copyWith(
            name: name,
            description: description,
            updatedAt: DateTime.now(),
          );

          await ref
              .read(accountBooksProvider.notifier)
              .updateAccountBook(updatedAccountBook);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Account book "${updatedAccountBook.name}" updated successfully')),
            );
          }
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, WidgetRef ref, AccountBookModel accountBook) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account Book'),
        content: Text(
            'Are you sure you want to delete "${accountBook.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(accountBooksProvider.notifier)
                  .deleteAccountBook(accountBook.id);

              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Account book "${accountBook.name}" deleted successfully')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _AccountBookDialog extends StatefulWidget {
  final String title;
  final String? initialName;
  final String? initialDescription;
  final Function(String name, String description) onSave;

  const _AccountBookDialog({
    required this.title,
    this.initialName,
    this.initialDescription,
    required this.onSave,
  });

  @override
  State<_AccountBookDialog> createState() => _AccountBookDialogState();
}

class _AccountBookDialogState extends State<_AccountBookDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialDescription ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name *',
                hintText: 'e.g., Personal Savings, Daily Expenses',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Brief description of this account book',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave(
                _nameController.text.trim(),
                _descriptionController.text.trim(),
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Implement save
              context.pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Add Transaction Form',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'This is a placeholder for the add transaction form.',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 32),
            Text(
              'Form fields will include:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            _FormField(label: 'Transaction Name'),
            _FormField(label: 'Amount'),
            _FormField(label: 'Currency'),
            _FormField(label: 'Type (Income/Expense)'),
            _FormField(label: 'Date'),
            _FormField(label: 'Label'),
            _FormField(label: 'Note'),
          ],
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.grey),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

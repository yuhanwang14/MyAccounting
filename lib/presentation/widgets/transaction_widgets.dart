import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/models/transaction.dart';
import '../../data/models/label.dart';
import '../providers/transaction_provider.dart';

class MonthlyHeaderCard extends StatelessWidget {
  final MonthlyTransactionData monthData;

  const MonthlyHeaderCard({
    super.key,
    required this.monthData,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '£');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Month title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${monthData.monthName} ${monthData.year}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Income and Expense cards
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  color: Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          currencyFormat.format(monthData.totalExpense),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Expense',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  elevation: 2,
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          currencyFormat.format(monthData.totalIncome),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Income',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DailyTransactionGroup extends ConsumerWidget {
  final DateTime date;
  final List<TransactionModel> transactions;

  const DailyTransactionGroup({
    super.key,
    required this.date,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = ref.watch(labelsProvider);
    final dayFormat = DateFormat('EEEE'); // Day of week
    final dateFormat = DateFormat('d'); // Day number

    // Calculate daily totals
    double dailyIncome = 0;
    double dailyExpense = 0;

    for (final transaction in transactions) {
      if (transaction.isIncome) {
        dailyIncome += transaction.amount;
      } else {
        dailyExpense += transaction.amount;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daily header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Text(
                  '${dayFormat.format(date)} ${dateFormat.format(date)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                if (dailyExpense > 0)
                  Row(
                    children: [
                      Icon(Icons.arrow_upward,
                          color: Colors.red[600], size: 16),
                      Text(
                        NumberFormat.currency(symbol: '').format(dailyExpense),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.red[600],
                        ),
                      ),
                    ],
                  ),
                if (dailyIncome > 0) ...[
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      Icon(Icons.arrow_downward,
                          color: Colors.blue[600], size: 16),
                      Text(
                        NumberFormat.currency(symbol: '').format(dailyIncome),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Transactions for this day
          ...transactions.map((transaction) => TransactionItem(
                transaction: transaction,
                label: labels.firstWhere(
                  (label) => label.id == transaction.labelId,
                  orElse: () => LabelModel(
                    id: 'default',
                    name: 'Other',
                    color: '#9E9E9E',
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final LabelModel label;

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final currencyFormat = NumberFormat.currency(symbol: '');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          // Category icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color(int.parse('0xFF${label.color.substring(1)}'))
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              _getCategoryIcon(label.name),
              color: Color(int.parse('0xFF${label.color.substring(1)}')),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      timeFormat.format(transaction.date),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (transaction.note != null &&
                        transaction.note!.isNotEmpty) ...[
                      Text(
                        ' • ${transaction.note}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ] else ...[
                      Text(
                        ' • ${transaction.name}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Amount
          Text(
            '${transaction.isExpense ? '-' : '+'}${currencyFormat.format(transaction.amount)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: transaction.isExpense ? Colors.black87 : Colors.blue[600],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'shopping':
      case 'purchase':
        return Icons.shopping_bag;
      case 'food':
      case 'dining':
      case 'restaurant':
        return Icons.restaurant;
      case 'transport':
      case 'transportation':
      case 'travel':
        return Icons.directions_car;
      case 'communication':
      case 'phone':
      case 'internet':
        return Icons.phone;
      case 'daily':
      case 'grocery':
      case 'supermarket':
        return Icons.local_grocery_store;
      case 'flight':
      case 'airplane':
        return Icons.flight;
      default:
        return Icons.category;
    }
  }
}

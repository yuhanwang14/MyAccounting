import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () {
              // TODO: Implement date range picker
            },
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Financial Analytics',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'This section will include:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16),
            _AnalyticsFeature(
              icon: Icons.pie_chart,
              title: 'Period Summary',
              description: 'Income, Expense, and Balance overview',
            ),
            _AnalyticsFeature(
              icon: Icons.trending_up,
              title: 'Expenditure Trend Chart',
              description: 'Visual trend analysis over time',
            ),
            _AnalyticsFeature(
              icon: Icons.donut_small,
              title: 'Category Ranking',
              description: 'Pie chart and ranked list of spending categories',
            ),
            _AnalyticsFeature(
              icon: Icons.list,
              title: 'Top 10 Expenses',
              description: 'Highest individual expense transactions',
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyticsFeature extends StatelessWidget {
  const _AnalyticsFeature({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

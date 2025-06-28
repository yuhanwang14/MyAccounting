import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/models/transaction.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/transaction_widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadPreviousMonth();
    }

    if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent + 200) {
      _loadNextMonth();
    }
  }

  Future<void> _loadPreviousMonth() async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);

    await ref.read(transactionProvider.notifier).loadPreviousMonth();

    setState(() => _isLoadingMore = false);
  }

  Future<void> _loadNextMonth() async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);

    await ref.read(transactionProvider.notifier).loadNextMonth();

    setState(() => _isLoadingMore = false);
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: _buildBody(transactionState),
      bottomNavigationBar: const _BottomNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add-transaction'),
        backgroundColor: Colors.red[400],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[50],
      elevation: 0,
      title: Row(
        children: [
          IconButton(
            onPressed: () => context.go('/accounts'),
            icon: const Icon(Icons.menu, color: Colors.black87),
          ),
          const Spacer(),
          _buildBalanceHeader(),
          const Spacer(),
          IconButton(
            onPressed: () => context.go('/analytics'),
            icon: const Icon(Icons.search, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceHeader() {
    final transactionState = ref.watch(transactionProvider);

    if (transactionState.monthlyData.isEmpty) {
      return const Column(
        children: [
          Text(
            'Balance: £0.00',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Text(
            'Budget: £0.00',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red,
            ),
          ),
        ],
      );
    }

    // Calculate total balance from current month
    final currentMonth = transactionState.monthlyData.first;
    final balance = currentMonth.balance;
    final budget = currentMonth.totalExpense; // Using expense as budget for now

    return Column(
      children: [
        Text(
          'Balance: ${balance >= 0 ? '' : '-'}£${balance.abs().toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        Text(
          'Budget: £${budget.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(TransactionState state) {
    if (state.isLoading && state.monthlyData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${state.error}'),
            ElevatedButton(
              onPressed: () {
                ref.read(transactionProvider.notifier);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.monthlyData.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to add your first transaction',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh current month data
        ref.invalidate(transactionProvider);
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          ...state.monthlyData
              .map((monthData) => _buildMonthSection(monthData)),
          if (_isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMonthSection(MonthlyTransactionData monthData) {
    // Group transactions by date
    final Map<String, List<TransactionModel>> groupedTransactions = {};

    for (final transaction in monthData.transactions) {
      final dateKey = DateFormat('yyyy-MM-dd').format(transaction.date);
      groupedTransactions.putIfAbsent(dateKey, () => []).add(transaction);
    }

    // Sort dates in descending order
    final sortedDates = groupedTransactions.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return SliverList(
      delegate: SliverChildListDelegate([
        MonthlyHeaderCard(monthData: monthData),
        ...sortedDates.map((dateKey) {
          final date = DateTime.parse(dateKey);
          final transactions = groupedTransactions[dateKey]!;

          return DailyTransactionGroup(
            date: date,
            transactions: transactions,
          );
        }),
        const SizedBox(height: 20), // Space between months
      ]),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedItemColor: Colors.red[400],
      unselectedItemColor: Colors.grey[600],
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/analytics');
            break;
          case 2:
            context.go('/accounts');
            break;
          case 3:
            // CSV Import - we can add this as a dialog or navigate to a new screen
            _showImportDialog(context);
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Accounts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.upload_file),
          label: 'Import',
        ),
      ],
    );
  }

  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import CSV'),
        content: const Text('CSV import feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

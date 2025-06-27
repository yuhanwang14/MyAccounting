class Transaction {
  final String id;
  final String accountBookId;
  final String name;
  final double amount;
  final String currency;
  final TransactionType type;
  final DateTime date;
  final String? labelId;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Transaction({
    required this.id,
    required this.accountBookId,
    required this.name,
    required this.amount,
    required this.currency,
    required this.type,
    required this.date,
    this.labelId,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  Transaction copyWith({
    String? id,
    String? accountBookId,
    String? name,
    double? amount,
    String? currency,
    TransactionType? type,
    DateTime? date,
    String? labelId,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      accountBookId: accountBookId ?? this.accountBookId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      type: type ?? this.type,
      date: date ?? this.date,
      labelId: labelId ?? this.labelId,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;

  @override
  String toString() {
    return 'Transaction(id: $id, accountBookId: $accountBookId, name: $name, amount: $amount, currency: $currency, type: $type, date: $date, labelId: $labelId, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Transaction && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum TransactionType { income, expense }

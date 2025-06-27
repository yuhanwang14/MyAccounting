import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String accountBookId;

  @HiveField(2)
  String name;

  @HiveField(3)
  double amount;

  @HiveField(4)
  String currency;

  @HiveField(5)
  String type; // 'income' or 'expense'

  @HiveField(6)
  DateTime date;

  @HiveField(7)
  String? labelId;

  @HiveField(8)
  String? note;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  DateTime updatedAt;

  TransactionModel({
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

  TransactionModel copyWith({
    String? id,
    String? accountBookId,
    String? name,
    double? amount,
    String? currency,
    String? type,
    DateTime? date,
    String? labelId,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
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

  bool get isIncome => type == 'income';
  bool get isExpense => type == 'expense';

  @override
  String toString() {
    return 'TransactionModel(id: $id, accountBookId: $accountBookId, name: $name, amount: $amount, currency: $currency, type: $type, date: $date, labelId: $labelId, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

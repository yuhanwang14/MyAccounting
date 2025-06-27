import 'package:hive/hive.dart';

part 'label.g.dart';

@HiveType(typeId: 2)
class LabelModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String color; // Hex color code

  @HiveField(3)
  String? description;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  LabelModel({
    required this.id,
    required this.name,
    required this.color,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  LabelModel copyWith({
    String? id,
    String? name,
    String? color,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LabelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'LabelModel(id: $id, name: $name, color: $color, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LabelModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

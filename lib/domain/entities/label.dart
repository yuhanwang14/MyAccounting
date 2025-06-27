import 'package:flutter/material.dart';

class Label {
  final String id;
  final String name;
  final Color color;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Label({
    required this.id,
    required this.name,
    required this.color,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  Label copyWith({
    String? id,
    String? name,
    Color? color,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Label(
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
    return 'Label(id: $id, name: $name, color: $color, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Label && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

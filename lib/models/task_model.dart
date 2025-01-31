// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/core/utils/hex_to_rgb.dart';
import 'package:frontend/core/utils/rgb_to_hex.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final Color color;
  final DateTime dueAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isSynced;
  final int isDeleted;
  final String userId;
  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueAt,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.color,
    required this.isSynced,
    this.isDeleted = 0,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? hexColor,
    Color? color,
    DateTime? dueAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
    String? userId,
    int? isDeleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueAt: dueAt ?? this.dueAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      color: color ?? this.color,
      isSynced: isSynced ?? this.isSynced,
      userId: userId ?? this.userId,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'dueAt': dueAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'hexColor': rgbToHex(color),
      'isSynced': isSynced,
      'userId': userId,
      'isDeleted': isDeleted,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueAt: DateTime.parse(map['dueAt']),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      // ! biasanya fromMap itu setelah dapet data dari server, karena properti color di server itu berupa hexColor, maka namain property disini itu color, karena TaskModel itu cuman punya color property
      color: hexToRgb(map['hexColor']),
      // ! kalo dapet data dari server, isSynced nya true, karena data yang di server itu synced
      isSynced: map['isSynced'] ?? 1,
      userId: map['userId'] ?? '',
      isDeleted: map['isDeleted'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, description: $description, dueAt: $dueAt, createdAt: $createdAt, updatedAt: $updatedAt), color: $color, isSynced: $isSynced, userId: $userId, isDeleted: $isDeleted';
  }

  @override
  bool operator ==(covariant TaskModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.dueAt == dueAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.color == color &&
        other.isSynced == isSynced &&
        other.userId == userId &&
        other.isDeleted == isDeleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        dueAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        color.hashCode ^
        isSynced.hashCode ^
        userId.hashCode ^
        isDeleted.hashCode;
  }
}

// lib/models/reminder.dart
import 'package:equatable/equatable.dart';

class Reminder extends Equatable {
  final String title;
  final String description;
  final DateTime time;
  final String priority;

  Reminder({required this.title, required this.description, required this.time, required this.priority});

  Reminder copyWith({String? title, String? description, DateTime? time, String? priority}) {
    return Reminder(
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      priority: priority ?? this.priority,
    );
  }

  @override
  List<Object> get props => [title, description, time, priority];
}

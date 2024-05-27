// lib/bloc/reminder_state.dart
import 'package:equatable/equatable.dart';
import '../models/reminder.dart';

class ReminderState extends Equatable {
  final List<Reminder> reminders;
  final String filter;
  final bool sortAscending;

  ReminderState({this.reminders = const [], this.filter = 'All', this.sortAscending = true});

  ReminderState copyWith({List<Reminder>? reminders, String? filter, bool? sortAscending}) {
    return ReminderState(
      reminders: reminders ?? this.reminders,
      filter: filter ?? this.filter,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  @override
  List<Object> get props => [reminders, filter, sortAscending];
}

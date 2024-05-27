// lib/bloc/reminder_event.dart
import 'package:equatable/equatable.dart';
import '../models/reminder.dart';

abstract class ReminderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddReminder extends ReminderEvent {
  final Reminder reminder;

  AddReminder(this.reminder);

  @override
  List<Object> get props => [reminder];
}

class UpdateReminder extends ReminderEvent {
  final Reminder reminder;

  UpdateReminder(this.reminder);

  @override
  List<Object> get props => [reminder];
}

class RemoveReminder extends ReminderEvent {
  final Reminder reminder;

  RemoveReminder(this.reminder);

  @override
  List<Object> get props => [reminder];
}

class SetFilter extends ReminderEvent {
  final String filter;

  SetFilter(this.filter);

  @override
  List<Object> get props => [filter];
}

class ToggleSortOrder extends ReminderEvent {}

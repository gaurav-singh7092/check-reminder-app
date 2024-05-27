// lib/bloc/reminder_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/reminder.dart';
import 'reminder_event.dart';
import 'reminder_state.dart';
import '../notification_service.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final NotificationService notificationService;

  ReminderBloc(this.notificationService) : super(ReminderState()) {
    on<AddReminder>(_onAddReminder);
    on<UpdateReminder>(_onUpdateReminder);
    on<RemoveReminder>(_onRemoveReminder);
    on<SetFilter>(_onSetFilter);
    on<ToggleSortOrder>(_onToggleSortOrder);
  }

  void _onAddReminder(AddReminder event, Emitter<ReminderState> emit) {
    final newReminders = List<Reminder>.from(state.reminders)..add(event.reminder);
    emit(state.copyWith(reminders: newReminders));
    notificationService.scheduleNotification(
        newReminders.length, event.reminder.title, event.reminder.time, event.reminder.description);
  }

  void _onUpdateReminder(UpdateReminder event, Emitter<ReminderState> emit) {
    final newReminders = state.reminders.map((reminder) {
      return reminder == event.reminder ? event.reminder : reminder;
    }).toList();
    emit(state.copyWith(reminders: newReminders));
  }

  void _onRemoveReminder(RemoveReminder event, Emitter<ReminderState> emit) {
    final newReminders = List<Reminder>.from(state.reminders)..remove(event.reminder);
    emit(state.copyWith(reminders: newReminders));
  }

  void _onSetFilter(SetFilter event, Emitter<ReminderState> emit) {
    emit(state.copyWith(filter: event.filter));
  }

  void _onToggleSortOrder(ToggleSortOrder event, Emitter<ReminderState> emit) {
    emit(state.copyWith(sortAscending: !state.sortAscending));
  }
}

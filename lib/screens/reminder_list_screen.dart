// lib/screens/reminder_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/reminder_bloc.dart';
import '../bloc/reminder_event.dart';
import '../bloc/reminder_state.dart';
import 'add_reminder_screen.dart';

class ReminderListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reminders'),
          actions: [
            IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {
                BlocProvider.of<ReminderBloc>(context).add(ToggleSortOrder());
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                BlocProvider.of<ReminderBloc>(context).add(SetFilter(value));
              },
              itemBuilder: (BuildContext context) {
                return {'All', 'Low', 'Medium', 'High'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: BlocBuilder<ReminderBloc, ReminderState>(
        builder: (context, state) {
      final filteredReminders = state.reminders
          .where((reminder) => state.filter == 'All' || reminder.priority == state.filter)
          .toList();
      if (state.sortAscending) {
        filteredReminders.sort((a, b) => a.priority.compareTo(b.priority));
      } else {
        filteredReminders.sort((a, b) => b.priority.compareTo(a.priority));
      }
      return ListView.builder(
          itemCount: filteredReminders.length,
          itemBuilder: (context, index) {
        final reminder = filteredReminders[index];
        return Card(
            margin: EdgeInsets.all(8.0),
    color: _getColorForPriority(reminder.priority),
    child: ListTile(
      title: Text(
        reminder.title,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reminder.description,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            '${reminder.time.year}/${reminder.time.month}/${reminder.time.day} ${reminder.time.hour}:${reminder.time.minute.toString().padLeft(2, '0')}',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            'Priority: ${reminder.priority}',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddReminderScreen(reminder: reminder),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              BlocProvider.of<ReminderBloc>(context).add(RemoveReminder(reminder));
            },
          ),
        ],
      ),
    ),
        );
          },
      );
        },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddReminderScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Color _getColorForPriority(String priority) {
    switch (priority) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}


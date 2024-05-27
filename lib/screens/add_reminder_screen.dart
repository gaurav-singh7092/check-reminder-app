// lib/screens/add_reminder_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/reminder_bloc.dart';
import '../bloc/reminder_event.dart';
import '../models/reminder.dart';

class AddReminderScreen extends StatefulWidget {
  final Reminder? reminder;

  AddReminderScreen({this.reminder});

  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _time;
  late String _priority;

  @override
  void initState() {
    super.initState();
    _title = widget.reminder?.title ?? '';
    _description = widget.reminder?.description ?? '';
    _time = widget.reminder?.time ?? DateTime.now();
    _priority = widget.reminder?.priority ?? 'Medium';
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_time),
    );
    if (picked != null && picked != TimeOfDay.fromDateTime(_time))
      setState(() {
        _time = DateTime(
          _time.year,
          _time.month,
          _time.day,
          picked.hour,
          picked.minute,
        );
      });
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _time,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _time)
      setState(() {
        _time = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _time.hour,
          _time.minute,
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reminder == null ? 'Add Reminder' : 'Edit Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _selectDate(context),
                      controller: TextEditingController(
                          text: '${_time.year}/${_time.month}/${_time.day}'),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Time',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      onTap: () => _selectTime(context),
                      controller: TextEditingController(
                          text: '${_time.hour}:${_time.minute.toString().padLeft(2, '0')}'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                items: ['High', 'Medium', 'Low']
                    .map((label) => DropdownMenuItem(
                  child: Text(label),
                  value: label,
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final reminder = Reminder(
                      title: _title,
                      description: _description,
                      time: _time,
                      priority: _priority,
                    );
                    if (widget.reminder == null) {
                      BlocProvider.of<ReminderBloc>(context)
                          .add(AddReminder(reminder));
                    } else {
                      BlocProvider.of<ReminderBloc>(context)
                          .add(UpdateReminder(reminder));
                    }
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
                child: Text(widget.reminder == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

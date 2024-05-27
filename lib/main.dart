import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder_app/screens/reminder_list_screen.dart';
// import 'package:your_app/bloc/reminder_bloc.dart';
// import 'package:your_app/notification_service.dart';
// import 'package:your_app/screens/reminder_list_screen.dart';

import 'bloc/reminder_bloc.dart';
import 'notification_service.dart';

void main() {
  final NotificationService notificationService = NotificationService();

  runApp(MyApp(notificationService: notificationService));
}

class MyApp extends StatelessWidget {
  final NotificationService notificationService;

  MyApp({required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReminderBloc(notificationService),
      child: MaterialApp(
        title: 'Flutter Reminder App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ReminderListScreen(),
      ),
    );
  }
}

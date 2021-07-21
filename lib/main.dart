import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

import 'test_app.dart';

// import 'app.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
String? selectedNotificationPayload;

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      // case simpleTaskKey:
      //   print("$simpleTaskKey was executed. inputData = $inputData");
      //   print("simple task");
      //   break;
      // case failedTaskKey:
      //   print('failed task');
      //   return Future.error('failed');
      // case simpleDelayedTask:
      //   print("$simpleDelayedTask was executed");
      //   break;
      // case simplePeriodicTask:
      //   print("$simplePeriodicTask was executed");
      //   break;
      // case simplePeriodic1HourTask:
      //   print("$simplePeriodic1HourTask was executed");
      //   break;
    }

    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  });

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  runApp(MyApp());
}

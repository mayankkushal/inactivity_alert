import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

import 'main.dart';

const simpleTaskKey = "simpleTask";
const rescheduledTaskKey = "rescheduledTask";
const failedTaskKey = "failedTask";
const simpleDelayedTask = "simpleDelayedTask";
const simplePeriodicTask = "simplePeriodicTask";
const simplePeriodic1HourTask = "simplePeriodic1HourTask";

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

enum _Platform { android, ios }

class PlatformEnabledButton extends ElevatedButton {
  final _Platform platform;

  PlatformEnabledButton({
    required this.platform,
    required Widget child,
    required VoidCallback onPressed,
  }) : super(
            child: child,
            onPressed: (Platform.isAndroid && platform == _Platform.android ||
                    Platform.isIOS && platform == _Platform.ios)
                ? onPressed
                : null);
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Inactivity Alert"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //This task runs once.
              //Most likely this will trigger immediately
              PlatformEnabledButton(
                platform: _Platform.android,
                child: Text("Register OneOff Task"),
                onPressed: () {
                  Workmanager().registerOneOffTask(
                    "1",
                    simpleTaskKey,
                    inputData: <String, dynamic>{
                      'int': 1,
                      'bool': true,
                      'double': 1.0,
                      'string': 'string',
                      'array': [1, 2, 3],
                    },
                  );
                },
              ),
              PlatformEnabledButton(
                platform: _Platform.android,
                child: Text("Test notification"),
                onPressed: sendNotification,
              ),

              //This task runs periodically
              //It will wait at least 10 seconds before its first launch
              //Since we have not provided a frequency it will be the default 15 minutes
              PlatformEnabledButton(
                  platform: _Platform.android,
                  child: Text("Start periodic alert"),
                  onPressed: () {
                    Workmanager().registerPeriodicTask(
                      "3",
                      simplePeriodicTask,
                    );
                  }),
              PlatformEnabledButton(
                platform: _Platform.android,
                child: Text("Cancel alerts"),
                onPressed: () async {
                  await Workmanager().cancelAll();
                  print('Cancel alerts completed');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendNotification() async {
    {
      final Int64List vibrationPattern = Int64List(4);
      vibrationPattern[0] = 0;
      vibrationPattern[1] = 1000;
      vibrationPattern[2] = 5000;
      vibrationPattern[3] = 2000;
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
              'your channel6', 'your channel name', 'your channel description',
              importance: Importance.max,
              priority: Priority.high,
              vibrationPattern: vibrationPattern,
              showWhen: false);
      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(0, 'Inactivity alert',
          'Time to stand up and take a walk!', platformChannelSpecifics,
          payload: 'item x');
    }
  }
}

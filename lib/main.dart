import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String _selectedParam;
  String taskName;
  int val;

  @override
  void initState() {
    tz.initializeTimeZones();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: notificationSelected,
    );
    super.initState();
  }

  Future _showNotification() async {
    var androidDetails = AndroidNotificationDetails(
      "Saikat",
      "Saikat Rahman",
      "It is flutter loacal notification",
      importance: Importance.max,
    );
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    //------press and show notification----------//
    // await flutterLocalNotificationsPlugin.show(
    //   0,
    //   "Task",
    //   "You created a task",
    //   generalNotificationDetails,
    //   payload: "Task",
    // );
    //----------scheduled time show notification--------------//
    final dhaka = tz.getLocation("Asia/Dhaka");
    tz.setLocalLocation(dhaka);
    // var scheduledTime =
    //     tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));

    var scheduledTime;
    if (_selectedParam == "Hour") {
      scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(hours: val));
    } else if (_selectedParam == "Minute") {
      scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(minutes: val));
    } else {
      scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(seconds: val));
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Times Upp',
      taskName,
      scheduledTime,
      generalNotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
                onChanged: (_val) {
                  taskName = _val;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton(
                  value: _selectedParam,
                  items: [
                    DropdownMenuItem(
                      child: Text("Seconds"),
                      value: "Seconds",
                    ),
                    DropdownMenuItem(
                      child: Text("Minutes"),
                      value: "Minutes",
                    ),
                    DropdownMenuItem(
                      child: Text("Hour"),
                      value: "Hour",
                    ),
                  ],
                  hint: Text(
                    "Select Your Field.",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onChanged: (_val) {
                    setState(() {
                      _selectedParam = _val;
                    });
                  },
                ),
                DropdownButton(
                  value: val,
                  items: [
                    DropdownMenuItem(
                      child: Text("1"),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text("2"),
                      value: 2,
                    ),
                    DropdownMenuItem(
                      child: Text("3"),
                      value: 3,
                    ),
                    DropdownMenuItem(
                      child: Text("4"),
                      value: 4,
                    ),
                  ],
                  hint: Text(
                    "Select Value",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onChanged: (_val) {
                    setState(() {
                      val = _val;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _showNotification,
              child: new Text('Set Task With Notification'),
            )
          ],
        ),
      ),
    );
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Notification Clicked $payload'),
      ),
    );
  }
}

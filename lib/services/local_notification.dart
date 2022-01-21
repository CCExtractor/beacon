import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/views/hike_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotification {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: (_, __, ___, ____) {});
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    tz.initializeTimeZones(); //  <----

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) => onSelectNotification(payload),
    );
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      Beacon beacon = await databaseFunctions.fetchBeaconInfo(payload);
      bool isLeader = beacon.leader.id == userConfig.currentUser.id;
      navigationService.pushScreen('/hikeScreen',
          arguments: HikeScreen(beacon, isLeader: isLeader));
    }
    return;
  }

  Future<void> deleteNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> scheduleNotification(Beacon beacon) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      beacon.id.hashCode,
      beacon.title + ' starting soon',
      'Join !!!',
      tz.TZDateTime.from(
          DateTime.fromMillisecondsSinceEpoch(beacon.startsAt), tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel ID',
          'channel name',
          playSound: true,
          priority: Priority.high,
          importance: Importance.high,
        ),
        iOS: IOSNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          badgeNumber: 1,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: beacon.id,
    );
  }
}

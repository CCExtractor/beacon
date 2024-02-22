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
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: (_, __, ___, ____) {}
            // as Future<dynamic> Function(int, String?, String?, String?)?
            );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    tz.initializeTimeZones(); //  <----

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (notificationResponse) =>
          onSelectNotification(notificationResponse),
    );
  }

  Future<void> onSelectNotification(notificationResponse) async {
    if (notificationResponse != null) {
      Beacon beacon = await (databaseFunctions!
          .fetchBeaconInfo(notificationResponse.payload) as Future<Beacon>);
      bool isLeader = beacon.leader!.id == userConfig!.currentUser!.id;
      navigationService!.pushScreen('/hikeScreen',
          arguments: HikeScreen(beacon, isLeader: isLeader));
    }
    return;
  }

  Future<void> deleteNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> scheduleNotification(Beacon beacon) async {
    var scheduledDate1 = await tz.TZDateTime.from(
        DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!), tz.local);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      beacon.id.hashCode,
      'Hike ' + beacon.title! + ' has started',
      'Click here to join!',
      scheduledDate1,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          // 'this is description',
          playSound: true,
          priority: Priority.high,
          importance: Importance.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          badgeNumber: 1,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: beacon.id,
    );
    // We have to check if the hike is after 1 hour or not

    var scheduledDate2 = await tz.TZDateTime.from(
      DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!),
      tz.local,
    ).subtract(Duration(hours: 1));

    if (!scheduledDate2.isAfter(tz.TZDateTime.from(
        DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!), tz.local))) {
      return;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      beacon.id.hashCode,
      'Reminder: ' + beacon.title! + ' will start in an hour',
      'Get Ready!',
      scheduledDate2,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          // 'this is description',
          playSound: true,
          priority: Priority.high,
          importance: Importance.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          badgeNumber: 1,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: beacon.id,
    );
  }
}

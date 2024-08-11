import 'dart:developer';

import 'package:beacon/config/router/router.dart';
import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/usecase/hike_usecase.dart';
import 'package:beacon/locator.dart';
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

  Future<void> onSelectNotification(
      NotificationResponse notificationResponse) async {
    String beaconId = notificationResponse.payload!;

    var hikeUseCase = locator<HikeUseCase>();

    // Fetch beacon details
    final dataState = await hikeUseCase.fetchBeaconDetails(beaconId);
    if (dataState is DataSuccess) {
      var beacon = dataState.data;
      bool isLeader = beacon!.leader!.id == localApi.userModel.id;
      appRouter.push(HikeScreenRoute(beacon: beacon, isLeader: isLeader));
    }
  }

  Future<void> deleteNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> scheduleNotification(BeaconEntity beacon) async {
    var scheduledDate1 =
        tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, beacon.startsAt!);

    // Check if scheduledDate1 is in the future
    if (scheduledDate1.isBefore(tz.TZDateTime.now(tz.local))) {
      log('Scheduled date is not in the future.');
      return;
    }

    // Schedule the notification for the beacon start time
    await flutterLocalNotificationsPlugin.zonedSchedule(
      beacon.id.hashCode,
      'Hike ' + beacon.title! + ' has started',
      'Click here to join!',
      scheduledDate1,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
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

    var scheduledDate2 = scheduledDate1.subtract(Duration(hours: 1));

    if (scheduledDate2.isBefore(tz.TZDateTime.now(tz.local))) {
      log('Reminder date is not in the future.');
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

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications;
  }

  Future<void> showInstantNotification(String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
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
    );
  }
}

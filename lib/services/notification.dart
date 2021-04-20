import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService extends ChangeNotifier{
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  //initilize
  doSomething(){

  }
  Future initilize() async{
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings("ic_launcher");
    IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings();

    final InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: doSomething());
  }
  //Stylist Notification
  Future stylistNotification() async {
    var android = AndroidNotificationDetails(
        "id", "channel", "desciption",
        color: Colors.deepOrange,
        enableLights: true,
        enableVibration: true,
        largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
        styleInformation: MediaStyleInformation(
            htmlFormatContent: true, htmlFormatTitle: true
        )
    );
    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.show(
      0,"Demo stylist notification" , "Tap do something", platform,
    );
  }
//  Cancel Notification
  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
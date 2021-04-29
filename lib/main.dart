import 'package:do_an_tn_app/datas/chat_data.dart';
import 'package:do_an_tn_app/datas/data.dart';
import 'package:do_an_tn_app/pages/add_beverages.dart';
import 'package:do_an_tn_app/pages/chat_page.dart';
import 'package:do_an_tn_app/pages/chechout_page.dart';
import 'package:do_an_tn_app/pages/edit_beverages_page.dart';
import 'package:do_an_tn_app/pages/employes_page.dart';
import 'package:do_an_tn_app/pages/menu_page.dart';
import 'package:do_an_tn_app/pages/notification_page.dart';
import 'package:do_an_tn_app/pages/order_page.dart';
import 'package:do_an_tn_app/pages/order_page_no_item.dart';
import 'package:do_an_tn_app/pages/table_page.dart';
import 'package:do_an_tn_app/services/notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

Future<void>_firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
const AndroidNotificationChannel  channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FireStoreDatabaseTables>(create: (context) => FireStoreDatabaseTables()),
        Provider<FireStoreDataNotification>(create: (context) => FireStoreDataNotification()),
        Provider<FireStoreDatabaseMessage>(create: (context) => FireStoreDatabaseMessage()),
        Provider<FireStoreDatabaseCatagory>(create: (context) => FireStoreDatabaseCatagory()),
        Provider<FireStoreDatabaseBeverage>(create: (context) => FireStoreDatabaseBeverage()),
        ChangeNotifierProvider(create: (_) => NotificationService()),

      ],
      child: MaterialApp(
        title: 'CafeOrderApp TN',
        initialRoute: '/',
        routes: {
          TablePage.routeName: (context) => TablePage(),
          OrderPage.routeName: (context) => OrderPage(),
          OrderPageNoItem.routeName: (context) => OrderPageNoItem(),
          CheckOutPage.routeName: (context) => CheckOutPage(),
          NotificationPage.routeName: (context) => NotificationPage(),
          ChatPage.routeName: (context) => ChatPage(),
          AddBeverages.routeName: (context) => AddBeverages(),
          MenuPage.routeName: (context) => MenuPage(),
          EditBeveragesPage.routeName: (context) => EditBeveragesPage(),
          EmployesPage.routeName: (context) => EmployesPage(),
        },
        home: TablePage(),
      ),
    );
  }
}



import 'package:do_an_tn_app/datas/data.dart';
import 'package:do_an_tn_app/pages/add_beverages.dart';
import 'package:do_an_tn_app/pages/chat_page.dart';
import 'package:do_an_tn_app/pages/chechout_page.dart';
import 'package:do_an_tn_app/pages/employes_page.dart';
import 'package:do_an_tn_app/pages/home_page.dart';
import 'package:do_an_tn_app/pages/menu_page.dart';
import 'package:do_an_tn_app/pages/notification_page.dart';
import 'package:do_an_tn_app/pages/order_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
class TablePage extends StatefulWidget {
  static const String routeName = 'TablePage';
  @override
  _TablePageState createState() => _TablePageState();
}
class _TablePageState extends State<TablePage> {
  int _selectedIndex = 0;
  Widget _homePage = HomePage();
  Widget _notificationPage = NotificationPage();
  List<String> titles = [
    'Danh sách bàn',
    'Thông báo'
  ];
  bool _initialized = false;
  bool _error = false;
  bool _hadMessage = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  _getToken(){
    _firebaseMessaging.getToken().then((deviceToken) {
      print('deveice token: $deviceToken');
    });
  }
  _configureFirebaseMessaging(){
    _firebaseMessaging.getInitialMessage().then((RemoteMessage message) {
      if(message != null){
        if(message.data['type'] == 'order'){
          Navigator.pushNamed(context, OrderPage.routeName,
              arguments: {'tableNumber': message.data['tableNum'],
                            'orderID': message.data['orderID'],
                            'orderTime': intl.DateFormat('yyyy-MM-dd hh:mm:sss').parse(message.data['date'])
                          }
          );
        }
        else if(message.data['type'] == 'checkout'){
          Navigator.pushNamed(context, CheckOutPage.routeName, arguments: {'tableNumber': message.data['tableNum'],
            'orderID': message.data['orderID']});
        }
        else {
          Navigator.pushNamed(context, ChatPage.routeName);
        }
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message data: ${message.data}');

      if(message.data['type'] == 'messages'){
        setState(() {
          _hadMessage = true;
        });
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // print('A new onMessageOpenedApp event was published: ${message}');
      if(message.data['type'] == 'order'){
        Navigator.pushNamed(context, OrderPage.routeName,
            arguments: {'tableNumber': message.data['tableNum'],
                        'orderID': message.data['orderID'],
                        'orderTime': intl.DateFormat('yyyy-MM-dd hh:mm:sss').parse(message.data['date'])
        }
        );
      }
      else{
        if(message.data['type'] == 'checkout'){
          Navigator.pushNamed(context, CheckOutPage.routeName, arguments: {'tableNumber': message.data['tableNum'],
            'orderID': message.data['orderID']}
          );
        }
        else {
          Navigator.pushNamed(context, ChatPage.routeName);
        }
      }
    });
  }
  void initializedFirebase() async {
    try{
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    }catch(e){
      _error = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // _getToken();
    _configureFirebaseMessaging();
    initializedFirebase();
    super.initState();
  }

  // static const List<Widget> _widgetOptions = <Widget>[
  //    // NotificationPage(),
  //
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Widget getBody( )  {
    if(_selectedIndex == 0) {
      return _homePage;
    }else {
      return _notificationPage;
    }
  }
  @override
  Widget build(BuildContext context) {
    FireStoreDataNotification notifications = Provider.of<FireStoreDataNotification>(context);
    if(_error){
      return Container(
        color: Colors.white,
        child: Center(
          child: Text(
            "Lỗi kết nối",
            style: TextStyle(fontSize: 16),
            textDirection: TextDirection.ltr,
          ),
        ),
      );
    }
    else{
      if(_initialized){
        return SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  actions: [
                    PopupMenuButton(
                      iconSize: 30,
                      onSelected: (result){
                        switch(result){
                          case 'menu':
                            Navigator.pushNamed(context, MenuPage.routeName);
                            break;
                          case 'nv':
                            Navigator.pushNamed(context, EmployesPage.routeName);
                            break;
                          default:
                        }
                      },
                      itemBuilder: (context){
                        return <PopupMenuEntry<String>>[
                          PopupMenuItem(
                            child: Text('Menu',style: TextStyle(fontSize: 20),),
                            value: 'menu',
                          ),
                          PopupMenuItem(
                            child: Text('Nhân viên',style: TextStyle(fontSize: 20),),
                            value: 'nv',
                          )
                        ];
                      },
                    )
                  ],
                  title: Center(
                    child: Text(titles[_selectedIndex],
                      style: TextStyle(fontSize: 35, fontFamily: 'Berkshire Swash', fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                body: getBody(),
                floatingActionButton: Stack(
                  children: [
                    Container(
                      width: 75,
                      height: 75,
                      child: FloatingActionButton(
                        onPressed: (){
                          Navigator.pushNamed(context, ChatPage.routeName);
                          setState(() {
                            _hadMessage = false;
                          });
                        },
                        child:  Icon(Icons.message, color: Colors.white, size: 35,),
                      ),
                    ),
                    _hadMessage == false ? Positioned(top: 0,right: 0,child: Container(),)
                        : Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        alignment: Alignment.center,
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.red
                        ),
                        child: Text('N', style: TextStyle(fontSize: 18, color: Colors.white),),
                      ),
                    )
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home, size: 36,),
                      title: Text('Trang chính',style: TextStyle(fontSize: 25),)
                    ),
                    BottomNavigationBarItem(
                      icon: Stack(
                        children: [
                          Icon(Icons.notifications_none_rounded, size: 36),
                          StreamBuilder(
                            stream: notifications.getNotificationCount(),
                            builder: (context, snapshot){
                              if(snapshot.hasData){
                                if(snapshot.data.docs.length == 0){
                                  return Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(),
                                  );
                                }
                                else{
                                  return Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 19,
                                      height: 19,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Text('${snapshot.data.docs.length}', style: TextStyle(fontSize: 16,color: Colors.white),),
                                    ),
                                  );
                                }
                              }
                              return Positioned(
                                top: 0,
                                right: 0,
                                child: CircularProgressIndicator(),
                              );
                            },
                          )
                        ],
                      ),
                        title: Text('Thông báo',style: TextStyle(fontSize: 25),)
                    )
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.amber[800],
                  onTap: _onItemTapped,
                ),
            )
        );
      }
      else {
        return Container(
          color: Colors.white,
          child: Center(
            child: Text(
              "Đang kết nối",
              style: TextStyle(fontSize: 16),
              textDirection: TextDirection.ltr,
            ),
          ),
        );
      }
    }
  }
}


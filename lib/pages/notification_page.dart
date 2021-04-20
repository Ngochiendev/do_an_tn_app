import 'package:do_an_tn_app/datas/data.dart';
import 'package:do_an_tn_app/modules/notifications.dart';
import 'package:do_an_tn_app/pages/chechout_page.dart';
import 'package:do_an_tn_app/pages/order_page.dart';
import 'package:do_an_tn_app/widget/notification_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
class NotificationPage extends StatefulWidget {
  static const String routeName = '/NotificationPage';
  @override
  _NotificationPageState createState() => _NotificationPageState();
}
final FlutterLocalNotificationsPlugin flnp =
FlutterLocalNotificationsPlugin();
class _NotificationPageState extends State<NotificationPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flnp.cancelAll();
  }
  @override
  Widget build(BuildContext context) {
    FireStoreDataNotification notificationData = Provider.of<FireStoreDataNotification>(context);
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Thông báo'),
        // ),
        body: StreamBuilder<List<NotificationSnapshot>>(
          stream: notificationData.getNotificationFirebase(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              if(snapshot.data.length==0){
                return Center(
                  child: Text('Chưa có thông báo nào',style: TextStyle(fontSize: 25),),
                );
              }
              else{
                return Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: ListView.separated(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context,index){
                      MyNotification notify = snapshot.data[index].notification;
                      return InkWell(
                        onTap: (){
                          if(notify.type=='order'){
                            Navigator.pushNamed(context, OrderPage.routeName, arguments: {'tableNumber': notify.tableNum,'orderID': notify.orderID},);
                            snapshot.data[index].docs.delete();
                          }
                          else{
                            Navigator.pushNamed(context, CheckOutPage.routeName, arguments: {'tableNumber': notify.tableNum,'orderID': notify.orderID},);
                            snapshot.data[index].docs.delete();
                          }
                        },
                        child: NotificationItem(notification: notify,),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                );
              }
            }
            return Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}

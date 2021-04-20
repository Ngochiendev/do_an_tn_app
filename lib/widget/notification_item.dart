import 'package:do_an_tn_app/modules/notifications.dart';
import 'package:do_an_tn_app/pages/chechout_page.dart';
import 'package:do_an_tn_app/pages/order_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class NotificationItem extends StatelessWidget {
  final MyNotification notification;
  NotificationItem({this.notification});
  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('MMMM d H:mm:s');
    if(notification.type == 'order'){
      //Order Notification
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
          gradient: LinearGradient(
            colors: [
              Colors.amberAccent.withOpacity(0.2),
              Colors.white
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/background_order_image.jpg'),
            alignment: Alignment(1.45, 0.5),
            fit: BoxFit.fitHeight,

            colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.15), BlendMode.dstATop)
          ),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          // tileColor: Colors.deepOrange,
          leading: Container(
            alignment: Alignment.center,
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.white
            ),
            child: Icon(Icons.wine_bar_outlined, size: 30, color: Colors.deepOrange,),
          ),
          title: Text('Bàn ${notification.tableNum} order', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          subtitle: Column(
            children: [
              SizedBox(height: 10,),
              Row(children: [
                Icon(Icons.perm_identity_outlined, size: 17, color: Colors.black54,),
                SizedBox(width: 10,),
                Text('Nhân Viên Order: ${notification.waiterName}', style: TextStyle(fontSize: 14, color: Colors.black87),),
                SizedBox(width: 20,),
                Text('MSNV: ${notification.waiterID}', style: TextStyle(fontSize: 14, color: Colors.black87),),
              ],),
              SizedBox(height: 10,),
              Row(children: [
                Icon(Icons.timer, size: 17, color: Colors.black54,),
                SizedBox(width: 10,),
                Text('Thời gian: ${dateFormat.format(notification.date.toDate())}', style: TextStyle(fontSize: 14, color: Colors.black87),),
              ],),
            ],
          ),
        ),
      );
    }
    else{
      //CheckOut Notification
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
          gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.2),
                Colors.white
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight
          ),
          image: DecorationImage(
              image: AssetImage('assets/images/background_checkout_image.jpg'),
              alignment: Alignment(1.09, 0.5),
              fit: BoxFit.fitHeight,

              colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.15), BlendMode.dstATop)
          ),
        ),
        child: ListTile(
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
          // tileColor: Colors.deepOrange,
          leading: Container(
            alignment: Alignment.center,
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.white
            ),
            child: Icon(Icons.monetization_on_outlined, size: 30, color: Colors.green,),
          ),
          title: Text('Bàn ${notification.tableNum} yêu cầu thanh toán'),
          subtitle: Column(
            children: [
              SizedBox(height: 10,),
              Row(children: [
                Icon(Icons.perm_identity_outlined, size: 17, color: Colors.black54,),
                SizedBox(width: 10,),
                Text('Nhân Viên thanh toán: ${notification.waiterName}', style: TextStyle(fontSize: 14, color: Colors.black87),),
                SizedBox(width: 20,),
                Text('MSNV: ${notification.waiterID}', style: TextStyle(fontSize: 14, color: Colors.black87),),
              ],),
              SizedBox(height: 10,),
              Row(children: [
                Icon(Icons.timer, size: 17, color: Colors.black54,),
                SizedBox(width: 10,),
                Text('Thời gian: ${dateFormat.format(notification.date.toDate())}', style: TextStyle(fontSize: 14, color: Colors.black87),),
              ],),
            ],
          ),
        ),
      );
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tn_app/datas/data.dart';
import 'package:do_an_tn_app/widget/table_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    FireStoreDatabaseOrders orders = Provider.of<FireStoreDatabaseOrders>(context);
    return StreamBuilder(
      stream: orders.getAllOrderFromFireBase(),
      builder: (context, snapshot){
        if(snapshot.hasData){

          return GridView.builder(
            itemCount: 16,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
              childAspectRatio: 7/2
            ),
            padding: EdgeInsets.all(10),
            itemBuilder: (context,index){
              bool hasOrderNotDone = false;
              bool requestCheckOut, received, cancelable;
              String orderID, waiterRCO;
              Timestamp timeRCO;
              snapshot.data.forEach((orderData) {
                if(orderData.orders.table==(index+1).toString()){
                  hasOrderNotDone = true;
                  orderID = orderData.orders.orderID;
                  requestCheckOut = orderData.orders.requestCheckOut;
                  received = orderData.orders.received;
                  waiterRCO = orderData.orders.waiterRCO;
                  timeRCO = orderData.orders.timeRCO;
                  cancelable = orderData.orders.cancelable;
                }
              });
              if(hasOrderNotDone){
                return TableItem(
                  tableNum: index+1,
                  waiterRCO: waiterRCO,
                  timeRCO: timeRCO,
                  orderID: orderID,
                  checkout: false,
                  requestCheckOut: requestCheckOut,
                  received: received,
                  cancelable: cancelable,
                );
              }
              else{
                return TableItem(
                    tableNum: index+1,
                    checkout: true,
                );
              }
            },
            // separatorBuilder: (context, index) => Divider(
            //   color: Colors.grey,
            //   thickness: 1.5,
            // ),
          );
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }
}

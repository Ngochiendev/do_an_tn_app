import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Orders{
  String orderID;
  bool checkout;
  double total;
  Timestamp date, receivedTime;
  bool received;
  bool requestCheckOut;
  Timestamp timeRCO; //Request Checkout
  String table;
  String waiterRCO;
  String waiterID;
  bool cancelable;
  Orders({
    @required this.orderID,
    @required this.checkout,
    @required this.total,
    @required this.date,
    @required this.received,
    @required this.requestCheckOut,
    @required this.table,
    @required this.waiterID,
    @required this.timeRCO,
    @required this.waiterRCO,
    @required this.cancelable,
    @required this.receivedTime
  });
  factory Orders.fromJson(Map<String, dynamic> json) =>
      Orders(
          orderID: json['orderID'],
          checkout: json['checkout'],
          total: double.parse(json['total'].toString()),
          date: json['date'],
          received: json['received'],
          table: json['table'],
          requestCheckOut: json['requestCheckOut'],
          waiterID: json['waiterID'],
          waiterRCO: json['waiterRCO'],
          timeRCO:  json['timeRCO'],
          cancelable: json['cancelable'],
          receivedTime: json['receivedTime']
      );
}
class OrderSnapshot{
  Orders orders;
  DocumentReference reference;
  OrderSnapshot({this.orders, this.reference});

  OrderSnapshot.fromSnapshot(DocumentSnapshot snapshot):
        orders = Orders.fromJson(snapshot.data()),
        reference = snapshot.reference;
}
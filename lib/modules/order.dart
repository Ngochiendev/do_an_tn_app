import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Orders{
  bool checkout;
  int total;
  Timestamp date;
  bool received;
  bool requestCheckOut;
  Timestamp timeRCO; //Request Checkout
  String waiterRCO;
  String waiterID;
  Orders({
    @required this.checkout,
    @required this.total,
    @required this.date,
    @required this.received,
    @required this.requestCheckOut,
    @required this.waiterID,
    @required this.timeRCO,
    @required this.waiterRCO,
  });
  factory Orders.fromJson(Map<String, dynamic> json) =>
      Orders(
          checkout: json['checkout'],
          total: json['total'],
          date: json['date'],
          received: json['received'],
          requestCheckOut: json['requestCheckOut'],
          waiterID: json['waiterID'],
          waiterRCO: json['waiterRCO'],
          timeRCO:  json['timeRCO']
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
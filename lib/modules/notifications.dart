import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MyNotification{
  Timestamp date;
  String tableNum;
  String type;
  String waiterID;
  String waiterName;
  String orderID;
  MyNotification({
    @required this.date,
    @required this.waiterName,
    @required this.waiterID,
    @required this.type,
    @required this.tableNum,
    @required this.orderID
  });
  factory MyNotification.fromJson(Map<String, dynamic> json) =>
    MyNotification(
      waiterID: json['waiterID'],
      waiterName: json['waiterName'],
      date: json['date'],
      type: json['type'],
      tableNum: json['tableNum'],
      orderID: json['orderID']
    );
}
class NotificationSnapshot{
  MyNotification notification;
  DocumentReference docs;
  NotificationSnapshot({this.notification, this.docs});

  NotificationSnapshot.fromSnapshot(DocumentSnapshot snapshot):
      notification = MyNotification.fromJson(snapshot.data()),
      docs = snapshot.reference;
}

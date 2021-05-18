import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
class WaitersOrder{
  final String waiterID;
  final String waiterName;
  final Timestamp time;
  final bool check;
  const WaitersOrder({
    @required this.waiterID,
    @required this.waiterName,
    @required this.time,
    @required this.check
});
  factory WaitersOrder.fromJson(Map<String, dynamic> json) =>
      WaitersOrder(
          waiterID: json['waiterID'],
          waiterName: json['waiterName'],
          time: json['time'],
          check: json['check']
      );
}
class WaitersOrderSnapshot{
  WaitersOrder waitersOrder;
  DocumentReference docs;
  WaitersOrderSnapshot({this.waitersOrder, this.docs});

  WaitersOrderSnapshot.fromSnapshot(DocumentSnapshot snapshot):
      waitersOrder = WaitersOrder.fromJson(snapshot.data()),
      docs = snapshot.reference;
}

class Item {
  final String id;
  final int quantity;
  final String name;
  final double price;
  final String note;
  final String image;
  final bool check;

  const Item({
    @required this.id,
    @required this.price,
    @required this.name,
    @required this.image,
    @required this.check,
    this.note,
    @required this.quantity,
  });
  factory Item.fromJson(Map<String, dynamic> json) =>
      Item(
          id: json['id'],
          price: double.parse(json['price'].toString()),
          name: json['name'],
          note: json['note'],
          quantity: json['quantity'],
          image: json['image'],
          check: json['check']
      );
}
class ItemSnapshot{
  Item item;
  DocumentReference doc;
  ItemSnapshot({this.item, this.doc});

  ItemSnapshot.fromSnapshot(DocumentSnapshot snapshot):
        item = Item.fromJson(snapshot.data()),
        doc = snapshot.reference;
}

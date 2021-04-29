import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
class Carts{
  final String waiterID;
  final String waiterName;
  final Timestamp time;
  final bool check;
  const Carts({
    @required this.waiterID,
    @required this.waiterName,
    @required this.time,
    @required this.check
});
  factory Carts.fromJson(Map<String, dynamic> json) =>
      Carts(
          waiterID: json['waiterID'],
          waiterName: json['waiterName'],
          time: json['time'],
          check: json['check']
      );
}
class CartsSnapshot{
  Carts carts;
  DocumentReference docs;
  CartsSnapshot({this.carts, this.docs});

  CartsSnapshot.fromSnapshot(DocumentSnapshot snapshot):
      carts = Carts.fromJson(snapshot.data()),
      docs = snapshot.reference;
}

class CartItem {
  final String id;
  final int quantity;
  final String name;
  final int price;
  final String note;
  final String image;

  const CartItem({
    @required this.id,
    @required this.price,
    @required this.name,
    @required this.image,
    this.note,
    this.quantity,
  });
  factory CartItem.fromJson(Map<String, dynamic> json) =>
      CartItem(
          id: json['id'],
          price: json['price'],
          name: json['name'],
          note: json['note'],
          quantity: json['quantity'],
          image: json['image']
      );
}
class CartItemSnapshot{
  CartItem cartItem;
  DocumentReference doc;
  CartItemSnapshot({this.cartItem, this.doc});

  CartItemSnapshot.fromSnapshot(DocumentSnapshot snapshot):
        cartItem = CartItem.fromJson(snapshot.data()),
        doc = snapshot.reference;
}

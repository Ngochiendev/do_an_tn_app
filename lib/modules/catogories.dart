import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CatagoryDoc {
  final String id;
  final String name;
  final String icon;
  const CatagoryDoc({
    @required this.id,
    @required this.name,
    this.icon});
  factory CatagoryDoc.fromJson(Map<String, dynamic> json) =>
      CatagoryDoc(
          id: json['catagoryId'],
          name: json['catagoryName'],
          icon: json['catagoryIcon']
      );
  Map<String,dynamic> toJson()=>
      {
        'catagoryId': id,
        'catagoryName': name,
        'catagoryIcon': icon
      };
}

class CatagorySnapshot{
  CatagoryDoc catagoryDoc;
  DocumentReference reference;
  CatagorySnapshot({this.catagoryDoc, this.reference});

  CatagorySnapshot.fromSnapshot(DocumentSnapshot snapshot):
        catagoryDoc = CatagoryDoc.fromJson(snapshot.data()),
        reference = snapshot.reference;
}
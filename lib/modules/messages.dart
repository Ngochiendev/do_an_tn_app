import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Messages{
  final String senderID;
  final String sender;
  final Timestamp createAt;
  final String message;
  const Messages({
    @required this.senderID,
    @required this.sender,
    @required this.message,
    this.createAt
  });
  factory Messages.fromJson(Map<String , dynamic> json) =>
      Messages(
          senderID: json['senderID'],
          sender: json['sender'],
          message: json['message'],
          createAt: json['createAt']
      );
  Map<String, dynamic> toJson() =>
      {
        'senderID' : senderID,
        'sender' : sender,
        'message': message,
        'createAt': createAt
      };
}
class MessagesSnapshot{
  Messages messages;
  DocumentReference ref;

  MessagesSnapshot({this.messages, this.ref});

  MessagesSnapshot.fromSnapshot(DocumentSnapshot snapshot):
        messages = Messages.fromJson(snapshot.data()),
        ref = snapshot.reference;
}

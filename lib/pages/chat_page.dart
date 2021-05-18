import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tn_app/datas/chat_data.dart';
import 'package:do_an_tn_app/widget/messages_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
class ChatPage extends StatefulWidget {
  static const String routeName = '/ChatPage';
  @override
  _ChatPageState createState() => _ChatPageState();
}


class _ChatPageState extends State<ChatPage> {
  String message = '';
  TextEditingController _textController = TextEditingController();

  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  Future<void> _sendFCMMessage(String deviceToken) async{
    Map<String, dynamic> body ={
      "to" : deviceToken,
      "collapse_key" : "type_a",
      "notification" : {
        "body" : message,
        "title": "Thu ngân nhắn: "
      },
      "data" : {
        "type" : "messages"
      }
    };
    var response = await http.post(
      url,
      headers: {"Content-type": "application/json",
        "Authorization": "key=AAAAAZL8920:APA91bEi6ArWOfYha7oZK4itXBmkVhSSZGGw0Lo0HX6sDsW1-xPpz-xLpvC4bic2m17wUnELzBNR3w3iIs5Q542nrD71di1OThQst86oYWQhrUKfHrYeMMAgxhVRmIPiMInlrq-QSk57"},
      body: json.encode(body),
    );
  }
  @override
  Widget build(BuildContext context) {
    FireStoreDatabaseMessage firebaseMessage = Provider.of<FireStoreDatabaseMessage>(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Tin Nhắn', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('tokens').snapshots(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                void sendMessage() async{
                  FocusScope.of(context).unfocus();
                  await firebaseMessage.upLoadMessage(message, DateTime.now());
                  if(snapshot.data.docs.length>0){
                    snapshot.data.docs.forEach((DocumentSnapshot doc) {
                      _sendFCMMessage(doc.data()['deviceToken']);
                    });
                  }
                  else print('No Divice');
                  setState(() {
                    message = '';
                  });
                  _textController.clear();
                }
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: MessagesWidget(),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style: TextStyle(fontSize: 22),
                              controller: _textController,
                              textCapitalization: TextCapitalization.sentences,
                              autocorrect: true,
                              enableSuggestions: true,
                              decoration: InputDecoration(

                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  labelText: 'Nhập tin nhắn',
                                  labelStyle: TextStyle(fontSize: 22),
                                  contentPadding: EdgeInsets.all(20),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(width: 0),
                                      gapPadding: 10,
                                      borderRadius: BorderRadius.circular(25)
                                  )
                              ),
                              onChanged: (value) => setState(() {
                                message = value;
                              }),
                            ),
                          ),
                          SizedBox(width: 20,),
                          GestureDetector(
                            onTap: message.trim().isEmpty ? null : sendMessage,
                            child: Container(
                              width: 50,
                              height: 50,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue
                              ),
                              child: Icon(Icons.send, color: Colors.white,size: 28,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Center(child: CircularProgressIndicator(),);
            },
          )
      ),
    );
  }
}

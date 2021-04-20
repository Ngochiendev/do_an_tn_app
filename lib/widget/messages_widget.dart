import 'package:do_an_tn_app/datas/chat_data.dart';
import 'package:do_an_tn_app/widget/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class MessagesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FireStoreDatabaseMessage firebaseMessage = Provider.of<FireStoreDatabaseMessage>(context);
    return StreamBuilder(
      stream: firebaseMessage.getMessageFromFirebase(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          final messages = snapshot.data;
          return messages.isEmpty ?
          Center(
            child: Text('Chưa có tin nhắn hiển thị', style: TextStyle(fontSize: 25, fontFamily: 'Berkshire Swash'),),
          ) : ListView.builder(
            physics: BouncingScrollPhysics(),
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index){
              final message = messages[index].messages;
              return MessageWidget(
                  docs: messages[index].ref,
                  message: message,
                  isMe: message.senderID == 'tn'
              );
            },
          );
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tn_app/modules/messages.dart';

class FireStoreDatabaseMessage{
  int count = 0;
  Future<void> upLoadMessage(String message, DateTime date) async{
    return await FirebaseFirestore.instance.collection('messages').add({
      'senderID' : 'tn',
      'sender': 'Thu Ngân',
      'message': message,
      'createAt': date
    });
  }
  Stream<List<MessagesSnapshot>> getMessageFromFirebase(){
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection('messages')
        .orderBy('createAt', descending: true)
        .snapshots();
    return stream.map((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.map((DocumentSnapshot docs) =>
            MessagesSnapshot.fromSnapshot(docs)
        ).toList()
    );
  }
  Future<void> deleteNotificationNotRead (String tableNumber, String type) async{
    final notificationNotRead = FirebaseFirestore.instance
        .collection('notifications')
        .where('tableNum', isEqualTo: tableNumber)
        .where('type', isEqualTo: type);
    WriteBatch batch = FirebaseFirestore.instance.batch();
    return await notificationNotRead.get()
        .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((document) {
            batch.delete(document.reference);
          });
          return batch.commit();
    });
  }
}

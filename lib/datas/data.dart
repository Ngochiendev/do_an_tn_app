
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tn_app/modules/beverages.dart';
import 'package:do_an_tn_app/modules/cart.dart';
import 'package:do_an_tn_app/modules/catogories.dart';
import 'package:do_an_tn_app/modules/notifications.dart';
import 'package:do_an_tn_app/modules/order.dart';

class FireStoreDatabaseOrders{
  Stream<List<WaitersOrderSnapshot>> getWaitersFromFirebase(String orderID){
    Stream<QuerySnapshot> stream =
    FirebaseFirestore
        .instance.collection('orders').doc(orderID)
        .collection('waitersOrder')
        .snapshots();

    return stream.map((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.map((DocumentSnapshot docs) =>
            WaitersOrderSnapshot.fromSnapshot(docs)
        ).toList()
    );
  }

  Stream<List<ItemSnapshot>> getItemOrderFromFirebase(String orderID){
    Stream<QuerySnapshot> stream = 
    FirebaseFirestore.instance
        .collection('orders').doc(orderID)
        .collection('items')
        .where('check', isEqualTo: false)
        .snapshots();

    return stream.map((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.map((DocumentSnapshot docs) =>
          ItemSnapshot.fromSnapshot(docs)
        ).toList()
    );
  }

  Stream<List<ItemSnapshot>> getItemCheckOutFromFirebase(String orderID){
    Stream<QuerySnapshot> stream =
    FirebaseFirestore.instance
        .collection('orders').doc(orderID)
        .collection('items')
        .where('check', isEqualTo: true)
        .snapshots();

    return stream.map((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.map((DocumentSnapshot docs) =>
            ItemSnapshot.fromSnapshot(docs)
        ).toList()
    );
  }

  Stream<OrderSnapshot> getOrderDataFromFireBase(String orderID){
    Stream<DocumentSnapshot> stream = FirebaseFirestore.instance
        .collection('orders').doc(orderID).snapshots();
    return stream.map((DocumentSnapshot doc) => OrderSnapshot.fromSnapshot(doc));
        // .get()
        // .then((DocumentSnapshot snapshot) => OrderSnapshot.fromSnapshot(snapshot));
  }
  Stream<List<OrderSnapshot>> getAllOrderFromFireBase(){
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('orders').where('checkout', isEqualTo: false)
        .snapshots();
    return stream.map((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.map((DocumentSnapshot doc) =>
            OrderSnapshot.fromSnapshot(doc)
        ).toList()
    );
    // return querySnapshot.docs.map((DocumentSnapshot doc) => OrderSnapshot.fromSnapshot(doc)).last
  }
  Future<void> comfirmCheckOut(String orderID) async{
    return await FirebaseFirestore.instance.collection('orders').doc(orderID)
        .update({
      'checkout': true,
    });
  }
  Future<void> comfirmOrder(String orderID, double total, DateTime receivedTime) async{
    final order =  FirebaseFirestore.instance.collection('orders').doc(orderID);
    order.update({
      'total': FieldValue.increment(total),
      'received': true,
      'receivedTime': receivedTime
    });

    // carts.forEach((item) async{
    //   await order.collection('items').add({
    //     'id': item.id,
    //     'name': item.name,
    //     'quantity': item.quantity,
    //     'note': item.note,
    //     'price': item.price,
    //     'image': item.image
    //   });
    // });
  }
}
class FireStoreDataNotification{
  Stream<List<NotificationSnapshot>> getNotificationFirebase(){
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection('notifications').orderBy('date', descending: false).snapshots();

    return stream.map((QuerySnapshot querySnapshot) =>
      querySnapshot.docs.map((DocumentSnapshot docs) =>
        NotificationSnapshot.fromSnapshot(docs)
      ).toList()
    );
  }
  Stream<QuerySnapshot> getNotificationCount(){
    return FirebaseFirestore.instance.collection('notifications').snapshots();
  }
}
class FireStoreDatabaseCatagory{
  Stream<List<CatagorySnapshot>> getCatagoryFromFireBase(){
    Stream<QuerySnapshot> streamQuerySnapshot =
    FirebaseFirestore
        .instance.collection("catagories")
        .orderBy('catagoryId', descending: false)
        .snapshots();
    return streamQuerySnapshot.map((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.map((DocumentSnapshot documentSnapshot) =>
            CatagorySnapshot.fromSnapshot(documentSnapshot)
        ).toList()
    );
  }
  Future<void> addCatagory(String name, String id)async{
    return await FirebaseFirestore.instance.collection("catagories")
        .add({
      'catagoryId': id,
      'catagoryName': name,
      'catagoryIcon': ''
    }).then((value) => print("Đã thêm"));
  }
}
class FireStoreDatabaseBeverage{
  Stream<List<BeverageSnapshot>> getBeverageFromFireBase(bool isAscending, int currentIndex){
    Stream<QuerySnapshot> streamQuerySnapshot = currentIndex == 1 ?
    FirebaseFirestore
        .instance.collection("beverages")
        .orderBy('catagoryId', descending: !isAscending)
        .snapshots()
        :
    FirebaseFirestore
        .instance.collection("beverages")
        .orderBy('price', descending: !isAscending)
        .snapshots();
    return streamQuerySnapshot.map((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.map((DocumentSnapshot documentSnapshot) =>
            BeverageSnapshot.fromSnapshot(documentSnapshot)
        ).toList()
    );
  }
}
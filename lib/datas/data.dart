
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tn_app/modules/cart.dart';
import 'package:do_an_tn_app/modules/notifications.dart';
import 'package:do_an_tn_app/modules/order.dart';

class FireStoreDatabaseTables{
  Stream<List<CartsSnapshot>> getCartsFromFirebase(String tableNum, String orderID){
    Stream<QuerySnapshot> stream =
    FirebaseFirestore
        .instance.collection('tables').doc(tableNum)
        .collection('orders').doc(orderID)
        .collection('carts')
        .where('check', isEqualTo: false)
        .snapshots();

    return stream.map((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.map((DocumentSnapshot docs) =>
            CartsSnapshot.fromSnapshot(docs)
        ).toList()
    );
  }
  Stream<List<CartItemSnapshot>> getCartsItemFromFirebase(CartsSnapshot cartsSnapshot){
    Stream<QuerySnapshot> stream = cartsSnapshot.docs.collection('cartItem').snapshots();

    return stream.map((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.map((DocumentSnapshot docs) =>
          CartItemSnapshot.fromSnapshot(docs)
        ).toList()
    );
  }

  Stream<List<CartItemSnapshot>> getItemsFromFirebase(String tableNum, String orderID){
    Stream<QuerySnapshot> stream =
    FirebaseFirestore
        .instance.collection('tables').doc(tableNum)
        .collection('orders').doc(orderID)
        .collection('items')
        .orderBy('id', descending: true)
        .snapshots();
    return stream.map((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.map((DocumentSnapshot docs) =>
            CartItemSnapshot.fromSnapshot(docs)
        ).toList()
    );
  }
  Future<OrderSnapshot> getOrderDataFromFireBase(String orderID, String tableNum){
    return FirebaseFirestore.instance
        .collection('tables').doc(tableNum)
        .collection('orders').doc(orderID)
        .get()
        .then((DocumentSnapshot snapshot) => OrderSnapshot.fromSnapshot(snapshot));
  }
  Stream<List<OrderSnapshot>> getAllOrderFromFireBase(String tableNum){
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('tables').doc(tableNum)
        .collection('orders').orderBy('date',descending: true)
        .limit(1)
        .snapshots();
    return stream.map((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.map((DocumentSnapshot doc) =>
            OrderSnapshot.fromSnapshot(doc)
        ).toList()
    );
    // return querySnapshot.docs.map((DocumentSnapshot doc) => OrderSnapshot.fromSnapshot(doc)).last
  }
  Future<void> comfirmCheckOut(String orderID, String tableNum) async{
    return await FirebaseFirestore.instance.collection('tables').doc(tableNum).collection('orders').doc(orderID)
        .update({
      'checkout': true,
    });
  }
  Future<void> comfirmOrder(String orderID, List<CartItem> carts,
      String tableNum, int total) async{
    final order =  FirebaseFirestore.instance.collection('tables').doc(tableNum).collection('orders').doc(orderID);
    order.update({
      'total': FieldValue.increment(total),
      'received': true,
    });
    carts.forEach((item) async{
      await order.collection('items').add({
        'id': item.id,
        'name': item.name,
        'quantity': item.quantity,
        'desc': item.description,
        'price': item.price,
        'image': item.image
      });
    });
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
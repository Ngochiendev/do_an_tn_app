import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tn_app/datas/chat_data.dart';
import 'package:do_an_tn_app/datas/data.dart';
import 'package:do_an_tn_app/widget/order_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:do_an_tn_app/modules/cart.dart';
import 'package:intl/intl.dart';
class OrderPage extends StatefulWidget {
  String tableNumber;
  String orderID;
  OrderPage({@required this.tableNumber});
  static const String routeName = '/OrderPage';
  @override
  _OrderPageState createState() => _OrderPageState();

}
class _OrderPageState extends State<OrderPage>{
  @override
  Widget build(BuildContext context) {
    FireStoreDatabaseOrders orders = Provider.of<FireStoreDatabaseOrders>(context);
    FireStoreDatabaseMessage messages = Provider.of<FireStoreDatabaseMessage>(context);
    Map<String, dynamic> argument = ModalRoute
        .of(context)
        .settings
        .arguments;
    this.widget.tableNumber = argument['tableNumber'];
    this.widget.orderID = argument['orderID'];
    String _tableID = widget.tableNumber;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Order',style: TextStyle(
                fontSize: 40,
                fontFamily: 'Berkshire Swash',
                fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: StreamBuilder<List<WaitersOrderSnapshot>>(
            stream: orders.getWaitersFromFirebase(widget.orderID),
            builder: (context, waitersSnapshot){
              if(waitersSnapshot.hasData){
                return StreamBuilder<List<ItemSnapshot>>(
                  stream: orders.getItemOrderFromFirebase(widget.orderID),
                  builder: (context,itemsSnapshot){
                    if(itemsSnapshot.hasData){
                      if(itemsSnapshot.data.length == 0 || waitersSnapshot.data.length == 0){
                        return Center(child: Text('Chưa có order nào' ,style: TextStyle(fontSize: 25),));
                      }
                      else{
                        String dateString = waitersSnapshot.data.first.waitersOrder.time.toDate().toString();
                        DateTime date = DateFormat('yyyy-MM-dd hh:mm:ss').parse(dateString);
                        String stringDate = DateFormat('MMMM d hh:mm:ss').format(date);
                        void _confirmOrder() async{
                          double total = 0;
                          itemsSnapshot.data.forEach((data) { total+=(data.item.price*data.item.quantity); });
                          await orders.comfirmOrder(widget.orderID, total);
                          await messages.deleteNotificationNotRead(_tableID, 'order');
                          await itemsSnapshot.data.forEach((item) {
                            item.doc.update({
                              'check': true
                            });
                          });
                          await waitersSnapshot.data.forEach((waiterOrder){
                            waiterOrder.docs.update({
                              'check': true
                            });
                          });
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        }

                        return Column(
                          children: [
                            Center(
                              child: Text( 'Order bàn ${_tableID}',
                                  style: TextStyle(fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Pacifico',
                                      color: Colors.black)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text('Nhân viên:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                    // Text(' ${waiterNames}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                    Text('Thời gian: $stringDate',style: TextStyle(fontSize: 20, color: Colors.black87),),
                                    SizedBox(height: 10,)
                                  ],
                                ),
                                SizedBox(width: 10,),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                  color: Colors.white,
                                  child: ListView.separated(
                                    itemBuilder: (context,index){
                                      Item _item = itemsSnapshot.data[index].item;
                                      return OrderItem(
                                        item: _item,
                                      );
                                    },
                                    itemCount: itemsSnapshot.data.length,
                                    separatorBuilder: (context, index) => Divider(
                                      color: Colors.black12,
                                      thickness: 1,
                                    ),
                                  )
                              ),
                            ),
                            SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RaisedButton(
                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  color: Colors.deepOrange,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check,color: Colors.white,),
                                      SizedBox(width: 10,),
                                      Text('Xác nhận', style: TextStyle(fontSize: 25, color: Colors.white),)
                                    ],
                                  ),
                                  onPressed: () async{
                                    _confirmOrder();
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 15,)
                          ],
                        );
                      }
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          )
      ),
    );
  }
}

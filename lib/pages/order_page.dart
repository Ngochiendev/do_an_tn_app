import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tn_app/datas/chat_data.dart';
import 'package:do_an_tn_app/datas/data.dart';
import 'package:do_an_tn_app/modules/order.dart';
import 'package:do_an_tn_app/pages/table_page.dart';
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
    FireStoreDatabaseTables tables = Provider.of<FireStoreDatabaseTables>(context);
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
                fontSize: 30,
                fontFamily: 'Berkshire Swash',
                fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: StreamBuilder<List<CartsSnapshot>>(
            stream: tables.getCartsFromFirebase(_tableID, widget.orderID),
            builder: (context,cartsSnapshot){
              List<CartItem> cartItems =[];
              if(cartsSnapshot.hasData){
                if(cartsSnapshot.data.length == 0){
                  return Center(child: Text('Chưa có order nào' ,style: TextStyle(fontSize: 25),));
                }
                else{
                  String dateString = cartsSnapshot.data.first.carts.time.toDate().toString();
                  DateTime date = DateFormat('yyyy-MM-dd hh:mm:ss').parse(dateString);
                  String stringDate = DateFormat('MMMM d h:mm:s').format(date);
                  void _confirmOrder(){
                    int total = 0;
                    cartItems.forEach((cartItem) { total+=(cartItem.price*cartItem.quantity); });
                    tables.comfirmOrder(widget.orderID, cartItems, widget.tableNumber, total);
                    messages.deleteNotificationNotRead(_tableID, 'order');
                    cartsSnapshot.data.forEach((carts) {
                      carts.docs.update({
                        'check': true
                      });
                    });
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }

                  return Column(
                    children: [
                      Center(
                        child: Text( 'Order bàn ${_tableID}',
                            // _tableID != 0
                            // ? 'Hóa đơn bàn: ${_tableID}'
                            // : 'Hóa đơn mang về',
                            style: TextStyle(fontSize: 25,
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
                              Text('Thời gian: ${stringDate}',style: TextStyle(fontSize: 14, color: Colors.black87),),
                              SizedBox(height: 10,)
                            ],
                          ),
                          SizedBox(width: 10,),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: ListView.builder(
                            itemBuilder: (context, index){
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  StreamBuilder<List<CartItemSnapshot>>(
                                    stream: tables.getCartsItemFromFirebase(cartsSnapshot.data[index]),
                                    builder: (context,cartItemSnapshot){
                                      if(cartItemSnapshot.hasData){
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context,index){
                                            CartItem _item = cartItemSnapshot.data[index].cartItem;
                                            cartItems.add(_item);
                                            return OrderItem(
                                              cartItem: _item,
                                            );
                                          },
                                          itemCount: cartItemSnapshot.data.length,
                                        );
                                      }
                                      return CircularProgressIndicator();
                                    },
                                  ),],
                              );
                            },
                            itemCount: cartsSnapshot.data.length,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
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
                                SizedBox(width: 5,),
                                Text('Xác nhận', style: TextStyle(fontSize: 15, color: Colors.white),)
                              ],
                            ),
                            onPressed: () async{
                              cartsSnapshot.data.length == 0 && cartItems.length == 0?
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Chưa có sản phẩm'),
                                duration: Duration(seconds: 1),
                              ))
                                  : _confirmOrder();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10,)
                    ],
                  );
                }
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
      ),
    );
  }
}

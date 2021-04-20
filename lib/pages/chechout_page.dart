import 'package:do_an_tn_app/datas/chat_data.dart';
import 'package:do_an_tn_app/datas/data.dart';
import 'package:do_an_tn_app/modules/cart.dart';
import 'package:do_an_tn_app/modules/order.dart';
import 'package:do_an_tn_app/pages/order_page.dart';
import 'package:do_an_tn_app/pages/table_page.dart';
import 'package:do_an_tn_app/widget/checkout_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
class CheckOutPage extends StatelessWidget {
  String tableNumber;
  String orderID;
  String waiterName;
  String waiterID;
  CheckOutPage({@required this.tableNumber});
  static const String routeName = '/CheckOutPage';
  @override
  Widget build(BuildContext context) {
    FireStoreDatabaseTables tables = Provider.of<FireStoreDatabaseTables>(context);
    FireStoreDatabaseMessage messages = Provider.of<FireStoreDatabaseMessage>(context);
    Map<String, dynamic> argument = ModalRoute
        .of(context)
        .settings
        .arguments;
    this.tableNumber = argument['tableNumber'];
    this.orderID = argument['orderID'];
    this.waiterName = argument['waiterName'];
    this.waiterID = argument['waiterID'];
    int _tableID = int.parse(tableNumber);
    // Cart cart = tableOrder.orderTableList[_checkoutID].order;
    // List<String> productIds = cart.items.keys.toList();
    // tables.getCartTotal(orderID, _tableID);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Thanh Toán',style: TextStyle(
                fontSize: 30,
                fontFamily: 'Berkshire Swash',
                fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: FutureBuilder<OrderSnapshot>(
            future: tables.getOrderDataFromFireBase(orderID, tableNumber),
            builder: (context, orderSnapshot){
              if(orderSnapshot.hasData){
                return StreamBuilder(
                  stream: tables.getItemsFromFirebase(tableNumber, orderID),
                  builder: (context,cartItemSnapshot){
                    if(cartItemSnapshot.hasData){
                      String dateString = orderSnapshot.data.orders.timeRCO.toDate().toString();
                      DateTime date = DateFormat('yyyy-MM-dd hh:mm:ss').parse(dateString);
                      String stringDate = DateFormat('MMMM d hh:mm:ss').format(date);
                      // OrderSnapshot snapshot = tables.getOrderDataFromFireBase(orderID, _tableID)
                      void _checkout() async{
                        tables.comfirmCheckOut(orderID, tableNumber);
                        messages.deleteNotificationNotRead(tableNumber, 'checkout');
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }
                      Future<void> showAlert(){
                        return showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context){
                              return AlertDialog(
                                title: Text('Bàn đã có thêm order'),
                                content: Text('Chuyển tới trang order'),
                                actions: [
                                  TextButton(
                                      onPressed: (){
                                        Navigator.pushNamed(context, OrderPage.routeName,
                                          arguments: {'tableNumber': tableNumber,'orderID': orderID},);
                                      },
                                      child: Text('Xác Nhận', style: TextStyle(color: Colors.green),)
                                  ),
                                ],
                              );
                            }
                        );
                      }
                      return ListView(
                        children: [
                          Column(
                            children: [
                              Center(
                                child: Text(_tableID != 0
                                    ? 'Hóa đơn bàn: ${tableNumber}'
                                    : 'Hóa đơn mang về',
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
                                      Text('Nhân viên:  ${orderSnapshot.data.orders.waiterRCO}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                      SizedBox(height: 5,),
                                      Text('Mã nhân viên: ${orderSnapshot.data.orders.waiterID}',style: TextStyle(fontSize: 14, color: Colors.black54),),
                                      SizedBox(height: 5,),
                                      Text('Thời gian: ${stringDate}',style: TextStyle(fontSize: 14, color: Colors.black54),)
                                    ],
                                  ),
                                  SizedBox(width: 10,),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Container(
                                height: 350,
                                color: Colors.white,
                                child: cartItemSnapshot.data.length==0 ? Text('Không có sản phẩm')
                                    :ListView.builder(
                                  itemBuilder: (context, index){
                                    CartItem _item = cartItemSnapshot.data[index].cartItem;
                                    // _total+=(_item.price*_item.quantity);
                                    return CheckOutItem(
                                        cartItem: _item,
                                    );
                                  },
                                  itemCount: cartItemSnapshot.data.length,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Cart total: ', style: TextStyle(fontSize: 18, color: Colors.grey),),
                                        Text('${NumberFormat('###,###','es_US').format(orderSnapshot.data.orders.total)} VNĐ',
                                          style: TextStyle(fontSize: 15, color: Colors.black87),)
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Discount: ', style: TextStyle(fontSize: 18, color: Colors.grey),),
                                        Text('0.0 %',
                                          style: TextStyle(fontSize: 15, color: Colors.black87),)
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                      thickness: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Subtotal:',
                                          style: TextStyle(fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Pacifico'),),
                                        Text('${NumberFormat('###,###','es_US').format(orderSnapshot.data.orders.total)} VNĐ',
                                          style: TextStyle(fontSize: 20, color: Colors.red),)
                                      ],
                                    ),
                                    SizedBox(height: 15,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RaisedButton(
                                            padding: EdgeInsets.symmetric(vertical: 15),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20)
                                            ),
                                            color: Colors.blue,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.check,color: Colors.white,),
                                                SizedBox(width: 5,),
                                                Text('Xác nhận thanh toán', style: TextStyle(fontSize: 15, color: Colors.white),)
                                              ],
                                            ),
                                            onPressed: () async{
                                              if(cartItemSnapshot.data.length == 0) {
                                                Scaffold.of(context).showSnackBar(SnackBar(
                                                  content: Text('Chưa có sản phẩm'),
                                                  duration: Duration(seconds: 1),
                                                ));
                                              }
                                              else if(orderSnapshot.data.orders.received==false){
                                                showAlert();
                                              }
                                              else{
                                                _checkout();
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                );
              }
              return Center(child: CircularProgressIndicator(),);
            },
          )
      ),
    );
  }

}

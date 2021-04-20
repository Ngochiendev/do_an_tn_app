import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tn_app/datas/data.dart';
import 'package:do_an_tn_app/modules/cart.dart';
import 'package:do_an_tn_app/modules/order.dart';
import 'package:do_an_tn_app/pages/chechout_page.dart';
import 'package:do_an_tn_app/pages/order_page.dart';
import 'package:do_an_tn_app/pages/order_page_no_item.dart';
import 'package:do_an_tn_app/services/notification.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class TableItem extends StatefulWidget {
  int tableNum;
  TableItem({@required this.tableNum});
  @override
  _TableItemState createState() => _TableItemState();

}
class _TableItemState extends State<TableItem>{
  @override
  void initState() {
    // TODO: implement initState
    // Provider.of<NotificationService>(context,listen: false).initilize();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // NotificationService notification  = Provider.of<NotificationService>(context);
    FireStoreDatabaseTables tables = Provider.of<FireStoreDatabaseTables>(context);
    // Provider.of<NotificationService>(context,listen: false).initilize();
    return StreamBuilder<List<OrderSnapshot>>(
      stream: tables.getAllOrderFromFireBase(widget.tableNum.toString()),
      builder: (context,orderSnapshot){
        if(orderSnapshot.hasData){
          if(orderSnapshot.data.length != 0 && orderSnapshot.data.first.orders.checkout == false){
            // snapshot.data.first.reference.collection('items').get().then(() => null)
            String orderID = widget.tableNum.toString()+orderSnapshot.data.first.orders.date.toDate().toString();
            return StreamBuilder(
              stream: tables.getCartsFromFirebase(widget.tableNum.toString(), orderID),
              builder: (context, cartSnapshot){
                if(cartSnapshot.hasData){
                  Future<void> _showWaiterName() async {
                    String waiterNames = '';
                    cartSnapshot.data.forEach((docs)=> waiterNames+= docs.carts.waiterName+ '(ms: '
                        + docs.carts.waiterID +')' +'\n');
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Nhân viên order'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(waiterNames),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Xác nhận'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                  Future<void> _showWaiterNameRCO() async {
                    String waiterName = orderSnapshot.data.first.orders.waiterRCO;
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Nhân viên yêu cầu thanh toán'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(waiterName),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Xác nhận'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                  if(orderSnapshot.data.first.orders.received==false){
                    return Stack(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, OrderPage.routeName, arguments: {'tableNumber': widget.tableNum.toString(), 'orderID': orderID});
                          },
                          splashColor: Colors.deepPurple,
                          child: Container(
                            child: Center(
                              child: Text('Table ${widget.tableNum}',style: TextStyle(fontSize: 20,fontFamily: 'Pacifico', color: Colors.white),),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.amberAccent,
                                borderRadius: BorderRadius.circular(15)
                            ),
                          ),
                        ),
                        Positioned(
                            top: 0,
                            right: 5,
                            child: Row(
                              children: [
                                cartSnapshot.data.length > 0?
                                Container(
                                    alignment: Alignment.center,
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.red
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add,size: 20,color: Colors.white,),
                                        // Text('+', style: TextStyle(fontSize: 20, color: Colors.white),),
                                        Icon(Icons.wine_bar,size: 20,color: Colors.white,)
                                      ],
                                    )
                                ) : Container(),
                              ],
                            )
                        ),
                        Positioned(
                            bottom: 3,
                            left: 5,
                            child: InkWell(
                              onTap: (){
                                _showWaiterName();
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.black54,
                                ),
                                child: Icon(Icons.perm_identity, color: Colors.white,),
                              ),
                            )
                        )
                      ],
                    );
                  }
                  else {
                    return Stack(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pushNamed(context,
                                orderSnapshot.data.first.orders.requestCheckOut == false ? OrderPageNoItem.routeName : CheckOutPage.routeName,
                                arguments: {'tableNumber': widget.tableNum.toString(), 'orderID': orderID});
                          },
                          splashColor: Colors.deepPurple,
                          child: Container(
                            child: Center(
                              child: Text('Table ${widget.tableNum}',style: TextStyle(fontSize: 20,fontFamily: 'Pacifico', color: Colors.white),),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15)
                            ),
                          ),
                        ),
                        Positioned(
                            top: 0,
                            right: 5,
                            child: Row(
                              children: [
                                orderSnapshot.data.first.orders.requestCheckOut == true ?
                                Container(
                                  alignment: Alignment.center,
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.green
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Text('+', style: TextStyle(fontSize: 20, color: Colors.white),),
                                      Icon(Icons.fact_check_outlined,size: 20,color: Colors.white,)
                                    ],
                                  ),
                                ) : Container(),
                              ],
                            )
                        ),
                        Positioned(
                          bottom: 3,
                          left: 5,
                          child: orderSnapshot.data.first.orders.requestCheckOut == true ?
                          InkWell(
                            onTap: (){
                              _showWaiterNameRCO();
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.black54,
                              ),
                              child: Icon(Icons.perm_identity, color: Colors.white,),
                            ),
                          ) :
                          Container(),
                        )
                      ],
                    );
                  }
                }
                return CircularProgressIndicator();
              },
            );
          }
          else{
            return InkWell(
              onTap: (){
                // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:sss");
                // var orderTime = dateFormat.parse(DateTime.now().toString());
                Navigator.pushNamed(context, OrderPageNoItem.routeName, arguments: {'tableNumber': widget.tableNum.toString()});
              },
              splashColor: Colors.deepPurple,
              child: Container(
                child: Center(
                  child: Text('Table ${widget.tableNum}',style: TextStyle(fontSize: 20,fontFamily: 'Pacifico', color: Colors.white),),
                ),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.black54.withOpacity(0.3),
                          Colors.black54
                        ],
                        end: Alignment.bottomLeft,
                        begin: Alignment.topRight
                    ),
                    borderRadius: BorderRadius.circular(15)
                ),
              ),
            );
          }
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }
}

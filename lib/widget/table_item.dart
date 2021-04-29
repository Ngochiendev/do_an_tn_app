import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tn_app/datas/data.dart';
import 'package:do_an_tn_app/modules/cart.dart';
import 'package:do_an_tn_app/modules/order.dart';
import 'package:do_an_tn_app/pages/chechout_page.dart';
import 'package:do_an_tn_app/pages/order_page.dart';
import 'package:do_an_tn_app/pages/order_page_no_item.dart';
import 'package:do_an_tn_app/services/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
                  String getEmployesName(){
                    String names = '';
                    cartSnapshot.data.forEach((snapshot) {
                        names+=snapshot.carts.waiterName + ', ';
                      }
                    );
                    return names;
                  }
                  DateFormat dateFormat = DateFormat('hh:mm:ss aaa');
                  if(orderSnapshot.data.first.orders.received==false){
                    // !!!!!! Trang thai khach order !!!!!!!!!
                    return Stack(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, OrderPage.routeName, arguments: {'tableNumber': widget.tableNum.toString(), 'orderID': orderID});
                          },
                          splashColor: Colors.deepPurple,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30)
                            ),
                            height: 140,
                            child: Card(
                                clipBehavior: Clip.antiAlias,
                                elevation: 3,
                                child: Container(
                                  decoration: cartSnapshot.data.length > 0
                                      ? BoxDecoration()
                                      : BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage('assets/images/ordering.jpg'),
                                            alignment: Alignment(0.7,0),
                                            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
                                            fit: BoxFit.contain
                                          )
                                      ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: Container(width: 30, height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              color: Colors.amberAccent
                                          ),
                                        ),
                                        title: Text('Table ${widget.tableNum}',
                                          style: TextStyle(fontSize: 23,fontFamily: 'Berkshire Swash', color: Colors.black),),
                                        subtitle: Row(
                                          children: [
                                            Text('Tình trạng:',),
                                            SizedBox(width: 5,),
                                            Text(cartSnapshot.data.length > 0 ? 'Khách gọi nước': 'Có khách',
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),)
                                          ],
                                        ),
                                        trailing: cartSnapshot.data.length > 0 ?
                                        Column(
                                          children: [
                                            Icon(Icons.watch_later_outlined, size: 25,),
                                            SizedBox(height: 5,),
                                            Text(dateFormat.format(cartSnapshot.data.first.carts.time.toDate()),
                                              style: TextStyle(fontSize: 15, color: Colors.black),)
                                          ],
                                        ) : Text(''),
                                      ),
                                      SizedBox(height: 20,),
                                      cartSnapshot.data.length > 0 ?
                                      Row(
                                        children: [
                                          SizedBox(width: 20,),
                                          Icon(Icons.perm_identity, size: 22,),
                                          SizedBox(width: 5),
                                          Text('Nhân viên order: ' ,style: TextStyle(fontSize: 15),),
                                          Container(
                                            width: 220,
                                            height: 20,
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                Text(getEmployesName(),
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)
                                              ],
                                            ),
                                          )
                                        ],
                                      ) : Container(),
                                    ],
                                  ),
                                )
                            ),

                          )
                        ),
                      ],
                    );
                  }
                  else {
                    // !!!!!! Trang thai cho checkout !!!!!!!!!
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
                            height: 140,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 3,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Container(width: 30, height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: orderSnapshot.data.first.orders.requestCheckOut == true
                                              ? Colors.green
                                              : Colors.blue,
                                      ),

                                    ),
                                    title: Text('Table ${widget.tableNum}',
                                      style: TextStyle(fontSize: 23,fontFamily: 'Berkshire Swash', color: Colors.black),),
                                    subtitle: Row(
                                      children: [
                                        Text('Tình trạng:',),
                                        SizedBox(width: 5,),
                                        Text(orderSnapshot.data.first.orders.requestCheckOut == true
                                            ? 'Yêu cầu thanh toán'
                                            : 'Chưa có order mới',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),)
                                      ],
                                    ),
                                    trailing: orderSnapshot.data.first.orders.requestCheckOut == true ?
                                    Column(
                                      children: [
                                        Icon(Icons.watch_later_outlined, size: 25,),
                                        SizedBox(height: 5,),
                                        Text(dateFormat.format(orderSnapshot.data.first.orders.timeRCO.toDate()),
                                          style: TextStyle(fontSize: 15, color: Colors.black),)
                                      ],
                                    ) : Text(''),
                                  ),
                                  SizedBox(height: 20,),
                                  orderSnapshot.data.first.orders.requestCheckOut == true ?
                                  Row(
                                    children: [
                                      SizedBox(width: 20,),
                                      Icon(Icons.perm_identity, size: 22,),
                                      SizedBox(width: 5),
                                      Text('Nhân viên thanh toán: ' ,style: TextStyle(fontSize: 15),),
                                      Text(orderSnapshot.data.first.orders.waiterRCO,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)
                                    ],
                                  ):
                                      Container(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }
                return Center(child: CircularProgressIndicator(),);
              },
            );
          }
          else{
            // !!!!!! Trang thai chua co khach !!!!!!!!!
            return InkWell(
              onTap: (){
                // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:sss");
                // var orderTime = dateFormat.parse(DateTime.now().toString());
                Navigator.pushNamed(context, OrderPageNoItem.routeName, arguments: {'tableNumber': widget.tableNum.toString()});
              },
              splashColor: Colors.deepPurple,
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 3,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/no-item.png'),
                            alignment: Alignment(0.7,0),
                            fit: BoxFit.contain
                        )
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(width: 30, height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.black45
                            ),
                          ),
                          title: Text('Table ${widget.tableNum}',
                            style: TextStyle(fontSize: 23,fontFamily: 'Berkshire Swash', color: Colors.black),),
                          subtitle: Row(
                            children: [
                              Text('Tình trạng:',),
                              SizedBox(width: 5,),
                              Text('Trống', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),)
                            ],
                          ),

                        ),
                      ],
                    ),
                  )
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

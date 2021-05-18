import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tn_app/datas/data.dart';
import 'package:do_an_tn_app/modules/cart.dart';
import 'package:do_an_tn_app/pages/chechout_page.dart';
import 'package:do_an_tn_app/pages/order_page.dart';
import 'package:do_an_tn_app/pages/order_page_no_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class TableItem extends StatelessWidget {
  int tableNum;
  bool checkout;
  bool requestCheckOut;
  bool received;
  bool cancelable;
  String orderID;
  Timestamp timeRCO;
  String waiterRCO;
  TableItem({
    @required this.tableNum,
    @required this.checkout,
    this.requestCheckOut,
    this.received,
    this.orderID,
    this.cancelable,
    this.waiterRCO,
    this.timeRCO
  });
  @override
  Widget build(BuildContext context) {
    FireStoreDatabaseOrders orders = Provider.of<FireStoreDatabaseOrders>(context);
    if(checkout){
      return InkWell(
        onTap: (){
          Navigator.pushNamed(context, OrderPageNoItem.routeName, arguments: {'tableNumber': tableNum.toString()});
        },
        splashColor: Colors.deepPurple,
        child: Container(
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
                      leading: Container(width: 40, height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.black45
                        ),
                      ),
                      title: Text('Table $tableNum',
                        style: TextStyle(fontSize: 28,fontFamily: 'Berkshire Swash', color: Colors.black),),
                      subtitle: Row(
                        children: [
                          Text('Tình trạng:', style: TextStyle(fontSize: 19),),
                          SizedBox(width: 10,),
                          Text('Trống', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 19),)
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
    else{
      DateFormat dateFormat = DateFormat('hh:mm:ss aaa');
      if(received){
        return Stack(
          children: [
            InkWell(
              onTap: (){
                Navigator.pushNamed(context,
                    requestCheckOut == false ? OrderPageNoItem.routeName : CheckOutPage.routeName,
                    arguments: {'tableNumber': tableNum.toString(), 'orderID': orderID});
              },
              splashColor: Colors.deepPurple,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 3,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(width: 40, height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: requestCheckOut == true
                                ? Colors.green
                                : Colors.blue,
                          ),

                        ),
                        title: Text('Table $tableNum',
                          style: TextStyle(fontSize: 28,fontFamily: 'Berkshire Swash', color: Colors.black),),
                        subtitle: Row(
                          children: [
                            Text('Tình trạng:',style: TextStyle(fontSize: 19),),
                            SizedBox(width: 10,),
                            Text(requestCheckOut == true
                                ? 'Yêu cầu thanh toán'
                                : 'Chưa có order mới',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87,fontSize: 19),)
                          ],
                        ),
                        trailing: requestCheckOut == true ?
                        Column(
                          children: [
                            Icon(Icons.watch_later_outlined, size: 30,),
                            SizedBox(height: 3,),
                            Text(dateFormat.format(timeRCO.toDate()),
                              style: TextStyle(fontSize: 20, color: Colors.black),)
                          ],
                        ) : Text(''),
                      ),
                      SizedBox(height: 55,),
                      requestCheckOut == true ?
                      Row(
                        children: [
                          SizedBox(width: 20,),
                          Icon(Icons.perm_identity, size: 26,),
                          SizedBox(width: 10),
                          Text('Nhân viên thanh toán: ' ,style: TextStyle(fontSize: 20),),
                          Text(waiterRCO,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
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
      else{
        return StreamBuilder<List<WaitersOrderSnapshot>>(
          stream: orders.getWaitersFromFirebase(orderID),
          builder: (context, waitersOrderSnapshot){
            if(waitersOrderSnapshot.hasData){
              return Stack(
                children: [
                  InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, OrderPage.routeName,
                            arguments: {'tableNumber': tableNum.toString(), 'orderID': orderID,});
                      },
                      splashColor: Colors.deepPurple,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 3,
                            child: Container(
                              decoration: cancelable
                                  ? BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/ordering.jpg'),
                                      alignment: Alignment(0.7,0),
                                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
                                      fit: BoxFit.contain
                                  )
                              )
                                  : BoxDecoration(),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Container(width: 40, height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(40),
                                          color: Colors.amberAccent
                                      ),
                                    ),
                                    title: Text('Table $tableNum',
                                      style: TextStyle(fontSize: 28,fontFamily: 'Berkshire Swash', color: Colors.black),),
                                    subtitle: Row(
                                      children: [
                                        Text('Tình trạng:',style: TextStyle(fontSize: 19),),
                                        SizedBox(width: 8,),
                                        Text(cancelable ? 'Có khách': 'Khách gọi nước',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 19),)
                                      ],
                                    ),
                                    trailing: waitersOrderSnapshot.data.length > 0 ?
                                    Column(
                                      children: [
                                        Icon(Icons.watch_later_outlined, size: 30,),
                                        SizedBox(height: 3,),
                                        Text(dateFormat.format(waitersOrderSnapshot.data.first.waitersOrder.time.toDate()),
                                          style: TextStyle(fontSize: 20, color: Colors.black),)
                                      ],
                                    ):
                                    Text('') ,

                                  ),
                                  SizedBox(height: 55,),
                                  waitersOrderSnapshot.data.length>0 ?
                                  Row(
                                    children: [
                                      SizedBox(width: 20,),
                                      Icon(Icons.perm_identity, size: 26,),
                                      SizedBox(width: 8),
                                      Text('Nhân viên order: ' ,style: TextStyle(fontSize: 20),),
                                      Container(
                                        width: 260,
                                        height: 23,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            Text(waitersOrderSnapshot.data.map((data){
                                              return data.waitersOrder.waiterName;
                                            }).toList().join(', '),
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
                                          ],
                                        ),
                                      )
                                    ],
                                  ) :
                                  Container() ,
                                ],
                              ),
                            )
                        ),

                      )
                  ),
                ],
              );
            }
            return Center(child: CircularProgressIndicator(),);
          },
        );
      }
    }
  }
}


import 'package:do_an_tn_app/modules/cart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:transparent_image/transparent_image.dart';
class OrderItem extends StatelessWidget {
  // final String id;
  // final String productId;
  // final int quantity;
  // final int price;
  // final String name;
  // final String desc;
  final CartItem cartItem;
  OrderItem({
    @required this.cartItem
    // @required this.id,
    // @required this.productId,
    // @required this.quantity,
    // @required this.price,
    // @required this.name,
    // @required this.desc
  });
  @override
  Widget build(BuildContext context) {
    Future<void> _showDescription() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ghi chú'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(cartItem.note),
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
    return Slidable(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          // border: Border.all(width: 1, color: Colors.grey),
          color: Colors.white,
          // boxShadow: [
          //   BoxShadow(
          //       offset: Offset(1,2),
          //       color: Colors.black26,
          //       blurRadius: 2.0
          //   )
          // ]
        ),
        child: Row(
          children: [
            Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                  boxShadow:  [
                    BoxShadow(
                        offset: Offset(2,4),
                        color: Colors.black45,
                        blurRadius: 4.0
                    )
                  ]
              ),
              child: FadeInImage.memoryNetwork(
                  fit: BoxFit.cover,
                  placeholder: kTransparentImage,
                  image: cartItem.image
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cartItem.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                  SizedBox(height: 5,),
                  Container(
                    height: 20,
                    child: ListView(
                      children: [
                        Text('Ghi chú: ${cartItem.note}',style: TextStyle(fontSize: 15, color: Colors.black),)
                      ],
                    ),
                  )
                ],
              ),
            ),
            Text('Số lượng: ${cartItem.quantity} ', style: TextStyle(fontSize: 15, color: Colors.green),)
          ],
        ),
      ),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      secondaryActions: [
        IconSlideAction(
          caption: 'Xem ghi chú',
          color: Colors.blue,
          icon: Icons.announcement,
          onTap: (){
              _showDescription();
          },
        ),
      ],
    );

  }
}

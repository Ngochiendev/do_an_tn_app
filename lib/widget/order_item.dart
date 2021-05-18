import 'package:do_an_tn_app/modules/cart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:transparent_image/transparent_image.dart';
class OrderItem extends StatelessWidget {
  final Item item;
  OrderItem({
    @required this.item
  });
  @override
  Widget build(BuildContext context) {
    Future<void> _showDescription() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ghi chú',style: TextStyle(fontSize: 27),),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(item.note, style: TextStyle(fontSize: 22),),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Xác nhận',style: TextStyle(fontSize: 20),),
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
              height: 70.0,
              width: 70.0,
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
                  image: item.image
              ),
            ),
            SizedBox(width: 20,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),),
                  SizedBox(height: 5,),
                  Container(
                    height: 26,
                    child: ListView(
                      children: [
                        Text('Ghi chú: ${item.note}',style: TextStyle(fontSize: 19, color: Colors.black),)
                      ],
                    ),
                  )
                ],
              ),
            ),
            Text('Số lượng: ${item.quantity} ', style: TextStyle(fontSize: 19, color: Colors.green),)
          ],
        ),
      ),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      secondaryActions: [
        GestureDetector(
          child: Container(
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.announcement, size: 35, color: Colors.white,),
                Text('Xem ghi chú', style: TextStyle(fontSize: 20, color: Colors.white),)
              ],
            ),
          ),
          onTap: (){
            _showDescription();
          },
        ),
      ],
    );

  }
}

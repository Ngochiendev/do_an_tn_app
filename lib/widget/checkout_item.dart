import 'package:do_an_tn_app/modules/cart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
class CheckOutItem extends StatelessWidget {
  final Item item;
  CheckOutItem({
    @required this.item
  });
  @override
  Widget build(BuildContext context) {
    return Container(
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
                Text(item.name, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),),
                SizedBox(height: 10,),
                Text('Số lương: ${item.quantity}',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),)
              ],
            ),
          ),
          Text('\$: ${NumberFormat('###,###','es_US').format(item.quantity*item.price)} VNĐ', style: TextStyle(fontSize: 20, color: Colors.green),)
        ],
      ),
    );
  }
}

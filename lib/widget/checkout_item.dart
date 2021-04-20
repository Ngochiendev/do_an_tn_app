import 'package:do_an_tn_app/modules/cart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class CheckOutItem extends StatelessWidget {
  final CartItem cartItem;
  // final String id;
  // final String productId;
  // final int quantity;
  // final int price;
  // final String name;
  CheckOutItem({
    @required this.cartItem
    // @required this.id,
    // @required this.productId,
    // @required this.quantity,
    // @required this.price,
    // @required this.name,
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
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/${cartItem.image}'),
                    fit: BoxFit.cover
                ),
                boxShadow:  [
                  BoxShadow(
                      offset: Offset(2,4),
                      color: Colors.black45,
                      blurRadius: 4.0
                  )
                ]
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cartItem.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                SizedBox(height: 5,),
                Text('Số lương: ${cartItem.quantity}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),)
              ],
            ),
          ),
          Text('\$: ${NumberFormat('###,###','es_US').format(cartItem.quantity*cartItem.price)} VNĐ', style: TextStyle(fontSize: 15, color: Colors.green),)
        ],
      ),
    );
  }
}

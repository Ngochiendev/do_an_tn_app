import 'package:flutter/material.dart';
class OrderPageNoItem extends StatelessWidget {
  String tableNumber;
  OrderPageNoItem({@required this.tableNumber});
  static const routeName = 'OderPageNoItem';
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> argument = ModalRoute
        .of(context)
        .settings
        .arguments;
    this.tableNumber = argument['tableNumber'].toString();
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
          body: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text('Order bàn: ${tableNumber}'
                        // tableNumber != 0
                        // ? 'Hóa đơn bàn: ${tableNumber}'
                        // : 'Hóa đơn mang về'
                        ,
                        style: TextStyle(fontSize: 35,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pacifico',
                            color: Colors.black)),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/no-item.png'),
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
                  SizedBox(height: 20,),
                  Text('Chưa có order nào', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold , color: Colors.black54),)
                ],
              ),
            ],
          )
      ),
    );
  }
}

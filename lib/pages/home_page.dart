import 'package:do_an_tn_app/widget/table_item.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 15,
      itemBuilder: (context,index){
        return TableItem(tableNum: index+1);
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey,
        thickness: 1.5,
      ),
    );
    //   GridView.builder(
    //   padding: const EdgeInsets.all(20),
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2,
    //     childAspectRatio: 3/2,
    //     mainAxisSpacing: 10,
    //     crossAxisSpacing: 10,
    //   ),
    //   itemCount: 15,
    //   itemBuilder: (context, index){
    //     return TableItem(tableNum: index+1);
    //   },
    // );
  }
}

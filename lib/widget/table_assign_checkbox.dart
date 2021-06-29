import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class TableAssignCheckBox extends StatefulWidget {
  int tableNum;
  bool check;
  final ValueChanged<bool> callBack;
  TableAssignCheckBox({
    @required this.check,
    @required this.callBack,
    @required this.tableNum
});
  @override
  _TableAssignCheckBoxState createState() => _TableAssignCheckBoxState(callback: callBack);
}

class _TableAssignCheckBoxState extends State<TableAssignCheckBox> {
  final ValueChanged<bool> callback;
  _TableAssignCheckBoxState({this.callback});
  bool hasCheck;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hasCheck = widget.check;
  }
  @override
  Widget build(BuildContext context) {
    
    return InkWell(
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(15),
              color: hasCheck? Colors.green : Colors.black12,
              boxShadow: [
                BoxShadow(
                    offset: Offset(3,4),
                    color: Colors.black26,
                    blurRadius: 3.0
                )
              ]
          ),
          child: Row(
            children: [
              Checkbox(
                  value: hasCheck,
                  onChanged: (value){
                    setState(() {
                      hasCheck = value;
                    });
                    callback(hasCheck);
                  }
              ),
              Text('${NumberFormat("00").format(widget.tableNum)}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)
            ],
          )
      ),
      onTap: (){
        setState(() {
          hasCheck = !hasCheck;
        });
        callback(hasCheck);
      },
      splashColor: Colors.blueAccent,
    );
  }
}

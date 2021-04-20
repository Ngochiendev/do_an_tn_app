import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class AddBeverages extends StatefulWidget {
  static const String routeName = 'AddPage';
  @override
  _AddBeveragesState createState() => _AddBeveragesState();
}

class _AddBeveragesState extends State<AddBeverages> {
  String cataID = '';
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  List<String> catagory = ['cf', 'ck', 'st', 'ne', 'tr'];
  // TextEditingController cataIDControl = TextEditingController();
  TextEditingController imageControl = TextEditingController();
  TextEditingController nameControl = TextEditingController();
  TextEditingController priceControl = TextEditingController();
  TextEditingController infoControl = TextEditingController();
  TextEditingController idControl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formState,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  controller: nameControl,
                  decoration: InputDecoration(
                      labelText: 'Tên đồ uống',
                      border: OutlineInputBorder(
                          borderRadius:BorderRadius.all(Radius.circular(10))
                      )
                  ),
                  // onSaved: (newValue) {mh.tenMH=newValue;},
                  validator: (value) => value.isEmpty ? "Chưa có tên " : null,
                ),

                DropdownButtonFormField<String>(
                  items: catagory.map((catagory) => DropdownMenuItem<String>(
                    child: Text(catagory),
                    value: catagory,)
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      cataID = value;
                    });
                  },
                  validator: (value) => value ==null? "Chưa chọn loại mặt hàng" : null,
                  decoration: InputDecoration(
                      labelText: 'Loại đồ uống',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      )
                  ),),

                TextFormField(
                  controller: priceControl,
                  decoration: InputDecoration(
                      labelText: 'Giá',
                      border: OutlineInputBorder(
                          borderRadius:BorderRadius.all(Radius.circular(10))
                      )
                  ),
                  // onSaved: (newValue) {mh.soLuong= int.parse(newValue);},
                  validator: (value) => value.isEmpty ? "Chưa có Giá" : null,
                ),
                TextFormField(
                  controller: idControl,
                  decoration: InputDecoration(
                      labelText: 'ID',
                      border: OutlineInputBorder(
                          borderRadius:BorderRadius.all(Radius.circular(10))
                      )
                  ),
                  // onSaved: (newValue) {mh.soLuong= int.parse(newValue);},
                  validator: (value) => value.isEmpty ? "Chưa có ID" : null,
                ),
                TextFormField(
                  controller: infoControl,
                  decoration: InputDecoration(
                      labelText: 'Thông tin',
                      border: OutlineInputBorder(
                          borderRadius:BorderRadius.all(Radius.circular(10))
                      )
                  ),
                  // onSaved: (newValue) {mh.soLuong= int.parse(newValue);},
                  validator: (value) => value.isEmpty ? "Chưa có thông tin" : null,
                ),
                TextFormField(
                  controller: imageControl,
                  decoration: InputDecoration(
                      labelText: 'Hình',
                      border: OutlineInputBorder(
                          borderRadius:BorderRadius.all(Radius.circular(10))
                      )
                  ),
                  // onSaved: (newValue) {mh.soLuong= int.parse(newValue);},
                  validator: (value) => value.isEmpty ? "Chưa có hình" : null,
                ),
                Row(
                  children: [
                    Expanded(child: SizedBox(), flex: 1,),
                    RaisedButton(
                      child: Text('Thêm'),
                      color: Colors.white,
                      onPressed:() {
                        if(_formState.currentState.validate()) {
                          FirebaseFirestore.instance.collection('beverages').add({
                            'catagoryId' : cataID,
                            'id': idControl.text,
                            'image': imageControl.text,
                            'info': infoControl.text,
                            'name': nameControl.text,
                            'price': int.parse(priceControl.text)
                          });
                          imageControl.clear();
                          nameControl.clear();
                          priceControl.clear();
                          infoControl.clear();
                          idControl.clear();
                        }
                      },),
                    SizedBox(width: 20,),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

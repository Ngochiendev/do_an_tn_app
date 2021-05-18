import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tn_app/modules/catogories.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:do_an_tn_app/datas/data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
class AddBeverages extends StatefulWidget {
  static const String routeName = 'AddPage';
  @override
  _AddBeveragesState createState() => _AddBeveragesState();
}

class _AddBeveragesState extends State<AddBeverages> {
  String cataID = '';
  CollectionReference bevaragesRef;
  firebase_storage.Reference ref;
  GlobalKey<FormState> _formBeverageState = GlobalKey<FormState>();
  GlobalKey<FormState> _formCatagoryState = GlobalKey<FormState>();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File _image;
  final picker = ImagePicker();
  bool added = false;
  bool picked = false;
  TextEditingController nameControl = TextEditingController();
  MoneyMaskedTextController priceControl = MoneyMaskedTextController(
      decimalSeparator: '',
      thousandSeparator: ',',
      precision: 0,
  );
  TextEditingController infoControl = TextEditingController();
  TextEditingController catagoryNameControl = TextEditingController();
  TextEditingController catagoryIDControl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    FireStoreDatabaseCatagory fireStoreCatagory = Provider.of<FireStoreDatabaseCatagory>(context);
    Future<void> _showAddCatagoryDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Nhập danh mục đồ uống cần thêm', textAlign: TextAlign.center, style: TextStyle(fontSize: 25),),
            contentPadding: EdgeInsets.all(15),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Form(
                    key: _formCatagoryState,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      children: [
                        SizedBox(height: 15,),
                        TextFormField(
                          style: TextStyle(fontSize: 25),
                          controller: catagoryIDControl,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 16),
                              labelText: 'ID danh mục',
                              labelStyle: TextStyle(fontSize: 25),
                              border: OutlineInputBorder(
                                  borderRadius:BorderRadius.all(Radius.circular(20))
                              )
                          ),
                          // onSaved: (newValue) {mh.tenMH=newValue;},
                          validator: (value) => value.isEmpty ? "Chưa có ID " : null,
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          style: TextStyle(fontSize: 25),
                          controller: catagoryNameControl,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(fontSize: 25),
                              errorStyle: TextStyle(fontSize: 16),
                              labelText: 'Tên danh mục',
                              border: OutlineInputBorder(
                                  borderRadius:BorderRadius.all(Radius.circular(20))
                              )
                          ),
                          // onSaved: (newValue) {mh.tenMH=newValue;},
                          validator: (value) => value.isEmpty ? "Chưa có tên " : null,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Xác nhận', style: TextStyle(color: Colors.red, fontSize: 28),),
                onPressed: () {
                  if(_formCatagoryState.currentState.validate()){
                    fireStoreCatagory.addCatagory(catagoryNameControl.text.trim(), catagoryIDControl.text.trim());
                    Navigator.of(context).pop();
                  }
                },
              ),
              TextButton(
                child: Text('Hủy', style: TextStyle(color: Colors.grey, fontSize: 28),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Thêm đồ uống',style: TextStyle(fontSize: 40,
              fontFamily: 'Berkshire Swash',
              fontWeight: FontWeight.bold),),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(10).copyWith(top: 30),
                child: Form(
                  key: _formBeverageState,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      TextFormField(
                        controller: nameControl,
                        style: TextStyle(
                          fontSize: 25
                        ),
                        decoration: InputDecoration(
                            errorStyle: TextStyle(fontSize: 18),
                            contentPadding: EdgeInsets.all(20),
                            labelText: 'Tên đồ uống',
                            labelStyle: TextStyle(fontSize: 25),
                            border: OutlineInputBorder(
                                borderRadius:BorderRadius.all(Radius.circular(10))
                            )
                        ),
                        // onSaved: (newValue) {mh.tenMH=newValue;},
                        validator: (value) => value.isEmpty ? "Chưa có tên " : null,
                      ),
                      SizedBox(height: 20,),
                      StreamBuilder(
                        stream: fireStoreCatagory.getCatagoryFromFireBase(),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List data = snapshot.data;
                            return DropdownButtonFormField(
                              items: data.map((catagorySnapshot) => DropdownMenuItem(
                                child: Text(catagorySnapshot.catagoryDoc.name, style: TextStyle(fontSize: 25),),
                                value: catagorySnapshot.catagoryDoc.id,)
                              ).toList(),
                              onChanged: (value) {
                                setState(() {
                                  cataID = value;
                                });
                              },
                              isExpanded: false,
                              validator: (value) => value ==null? "Chưa chọn loại mặt hàng" : null,
                              decoration: InputDecoration(
                                  errorStyle: TextStyle(fontSize: 18),
                                  contentPadding: EdgeInsets.all(20),
                                  labelText: 'Loại đồ uống',
                                  labelStyle: TextStyle(fontSize: 25),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  )
                              ),);
                          }
                          return Center(child: CircularProgressIndicator(),);
                        },
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton(
                            child: Text('+ Thêm danh mục đồ uống',style: TextStyle(color: Colors.white, fontSize: 20),),
                            padding: EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)
                            ),
                            color: Colors.redAccent,
                            onPressed: (){
                              _showAddCatagoryDialog();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        style: TextStyle(fontSize: 25),
                        controller: priceControl,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            suffixText: 'VNĐ',
                            suffixStyle: TextStyle(fontSize: 25, color: Colors.black45),
                            labelText: 'Giá',
                            contentPadding: EdgeInsets.all(20),
                            labelStyle: TextStyle(fontSize: 25),
                            border: OutlineInputBorder(
                                borderRadius:BorderRadius.all(Radius.circular(10))
                            )
                        ),
                        // onSaved: (newValue) {mh.soLuong= int.parse(newValue);},
                        validator: (value) => value.isEmpty ? "Chưa có Giá" : null,
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: infoControl,
                        style: TextStyle(fontSize: 25),
                        decoration: InputDecoration(
                            errorStyle: TextStyle(fontSize: 18),
                            labelText: 'Thông tin',
                            contentPadding: EdgeInsets.all(20),
                            labelStyle: TextStyle(fontSize: 25),
                            border: OutlineInputBorder(
                                borderRadius:BorderRadius.all(Radius.circular(10))
                            )
                        ),
                        validator: (value) => value.isEmpty ? "Chưa có thông tin" : null,
                      ),
                      SizedBox(height: 25,),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: picked
                            ? Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(_image),
                                  fit: BoxFit.cover)),
                        )
                            : DottedBorder(
                              borderType: BorderType.RRect,
                              color: Colors.blue,
                              strokeWidth: 3,
                              dashPattern: [8,4],
                              child: Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                    color: Colors.grey
                                ),
                                child: IconButton(
                                    icon: Icon(Icons.add_a_photo_outlined,size: 70,),
                                    onPressed: () =>
                                        chooseImage()
                                ),
                              ),
                        ),
                      ),

                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            color: Colors.deepOrange,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Thêm sản phẩm', style: TextStyle(fontSize: 25, color: Colors.white),)
                              ],
                            ),
                            onPressed:() {
                              if(_formBeverageState.currentState.validate()) {
                                setState(() {
                                  added = true;
                                });
                                uploadFile().whenComplete((){
                                  setState(() {
                                    added = false;
                                  });
                                  Navigator.of(context).pop();
                                  nameControl.clear();
                                  priceControl.updateValue(0);
                                  infoControl.clear();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              added
                  ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          'Đang thêm...',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CircularProgressIndicator()
                    ],
                  ))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile?.path);
    });
    if (pickedFile.path == null) retrieveLostData();
    setState(() {
      picked = true;
    });
  }
  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image=File(response.file.path);
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    if(_image==null){
      bevaragesRef.add({
        'catagoryId' : cataID,
        'id': DateTime.now().toString(),
        'image': 'https://firebasestorage.googleapis.com/v0/b/cafeorderapp-a7803.appspot.com/o/images%2Fno_image.jpg?alt=media&token=9e9552d4-bbd0-4caf-bc60-8e956b97db14',
        'info': infoControl.text.trim(),
        'name': nameControl.text.trim(),
        'price': priceControl.numberValue
      });
    }
    else{
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(_image.path)}');
      await ref.putFile(_image).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          bevaragesRef.add({
            'catagoryId' : cataID,
            'id': DateTime.now().toString(),
            'image': value,
            'info': infoControl.text,
            'name': nameControl.text,
            'price': priceControl.numberValue
          });
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bevaragesRef = FirebaseFirestore.instance.collection('beverages');

  }
}

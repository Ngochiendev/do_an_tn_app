import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tn_app/modules/catogories.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:do_an_tn_app/datas/data.dart';
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
  TextEditingController priceControl = TextEditingController();
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
            title: Text('Nhập danh mục đồ uống cần thêm', textAlign: TextAlign.center,),
            contentPadding: EdgeInsets.all(5),
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
                          controller: catagoryIDControl,
                          decoration: InputDecoration(
                              labelText: 'ID danh mục',
                              border: OutlineInputBorder(
                                  borderRadius:BorderRadius.all(Radius.circular(20))
                              )
                          ),
                          // onSaved: (newValue) {mh.tenMH=newValue;},
                          validator: (value) => value.isEmpty ? "Chưa có ID " : null,
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          controller: catagoryNameControl,
                          decoration: InputDecoration(
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
                child: Text('Xác nhận', style: TextStyle(color: Colors.red, fontSize: 20),),
                onPressed: () {
                  if(_formCatagoryState.currentState.validate()){
                    fireStoreCatagory.addCatagory(catagoryNameControl.text.trim(), catagoryIDControl.text.trim());
                    Navigator.of(context).pop();
                  }
                },
              ),
              TextButton(
                child: Text('Hủy', style: TextStyle(color: Colors.grey, fontSize: 20),),
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
          title: Text('Thêm đồ uống'),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formBeverageState,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      SizedBox(height: 10,),
                      StreamBuilder(
                        stream: fireStoreCatagory.getCatagoryFromFireBase(),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List data = snapshot.data;
                            return DropdownButtonFormField(
                              items: data.map((catagorySnapshot) => DropdownMenuItem(
                                child: Text(catagorySnapshot.catagoryDoc.name),
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
                                  labelText: 'Loại đồ uống',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  )
                              ),);
                          }
                          return Center(child: CircularProgressIndicator(),);
                        },
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton(
                            child: Text('+ Thêm danh mục đồ uống',style: TextStyle(color: Colors.white, fontSize: 15),),
                            padding: EdgeInsets.all(10),
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
                        controller: priceControl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Giá',
                            border: OutlineInputBorder(
                                borderRadius:BorderRadius.all(Radius.circular(10))
                            )
                        ),
                        // onSaved: (newValue) {mh.soLuong= int.parse(newValue);},
                        validator: (value) => value.isEmpty ? "Chưa có Giá" : null,
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        controller: infoControl,
                        decoration: InputDecoration(
                            labelText: 'Thông tin',
                            border: OutlineInputBorder(
                                borderRadius:BorderRadius.all(Radius.circular(10))
                            )
                        ),
                        validator: (value) => value.isEmpty ? "Chưa có thông tin" : null,
                      ),
                      SizedBox(height: 15,),
                      Container(
                        padding: EdgeInsets.all(4),
                        child: picked
                            ? Container(
                          width: 120,
                          height: 120,
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
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                    color: Colors.grey
                                ),
                                child: IconButton(
                                    icon: Icon(Icons.add_a_photo_outlined,size: 40,),
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
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            color: Colors.deepOrange,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Thêm sản phẩm', style: TextStyle(fontSize: 15, color: Colors.white),)
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
                                  priceControl.clear();
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
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
        'price': int.parse(priceControl.text)
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
            'price': int.parse(priceControl.text)
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

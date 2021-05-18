import 'dart:io';

import 'package:do_an_tn_app/modules/beverages.dart';
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
class EditBeveragesPage extends StatefulWidget {
  static const String routeName = 'EditBeveragesPage';
  BeverageSnapshot beverageSnapshot;
  @override
  _EditBeveragesPageState createState() => _EditBeveragesPageState();
}

class _EditBeveragesPageState extends State<EditBeveragesPage> {
  String cataID = '';
  firebase_storage.Reference ref;
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
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
  @override
  Widget build(BuildContext context) {
    FireStoreDatabaseCatagory fireStoreCatagory = Provider.of<FireStoreDatabaseCatagory>(context);
    Map<String, dynamic> argument = ModalRoute
        .of(context)
        .settings
        .arguments;
    widget.beverageSnapshot = argument['beverageSnapshot'];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chỉnh sửa thông tin',style: TextStyle(fontSize: 40,
              fontFamily: 'Berkshire Swash',
              fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(10).copyWith(top: 30),
                child: Form(
                  key: _formState,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFormField(

                        style: TextStyle(fontSize: 25),
                        controller: nameControl..text = widget.beverageSnapshot.beverages.name,
                        decoration: InputDecoration(
                            errorStyle: TextStyle(fontSize: 18),
                            labelText: 'Tên đồ uống',
                            labelStyle: TextStyle(fontSize: 25),
                            contentPadding: EdgeInsets.all(20),
                            border: OutlineInputBorder(
                                borderRadius:BorderRadius.all(Radius.circular(10))
                            )
                        ),
                        // onSaved: (newValue) {mh.tenMH=newValue;},
                        validator: (value) => value.isEmpty ? "Chưa có tên " : null,
                      ),
                      SizedBox(height: 25,),
                      StreamBuilder(
                        stream: fireStoreCatagory.getCatagoryFromFireBase(),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List data = snapshot.data;
                            return DropdownButtonFormField(
                              value: widget.beverageSnapshot.beverages.catagoryId,
                              items: data.map((catagorySnapshot) => DropdownMenuItem(
                                child: Text(catagorySnapshot.catagoryDoc.name ,style: TextStyle(fontSize: 25),),
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
                                  labelStyle: TextStyle(fontSize: 25),
                                  contentPadding: EdgeInsets.all(20),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  )
                              ),);
                          }
                          return Center(child: CircularProgressIndicator(),);
                        },
                      ),
                      SizedBox(height: 25,),
                      TextFormField(
                        style: TextStyle(fontSize: 25),
                        controller: priceControl..updateValue(widget.beverageSnapshot.beverages.price),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            suffixText: 'VNĐ',
                            suffixStyle: TextStyle(fontSize: 25, color: Colors.black45),
                            labelText: 'Giá',
                            labelStyle: TextStyle(fontSize: 25),
                            contentPadding: EdgeInsets.all(20),
                            border: OutlineInputBorder(
                                borderRadius:BorderRadius.all(Radius.circular(10))
                            )
                        ),
                        // onSaved: (newValue) {mh.soLuong= int.parse(newValue);},
                        validator: (value) => value.isEmpty ? "Chưa có Giá" : null,
                      ),
                      SizedBox(height: 25,),
                      TextFormField(
                        style: TextStyle(fontSize: 25),
                        controller: infoControl..text = widget.beverageSnapshot.beverages.description,
                        maxLines: null,
                        decoration: InputDecoration(
                            errorStyle: TextStyle(fontSize: 18),
                            labelText: 'Thông tin',
                            labelStyle: TextStyle(fontSize: 25),
                            contentPadding: EdgeInsets.all(20),
                            border: OutlineInputBorder(
                                borderRadius:BorderRadius.all(Radius.circular(10))
                            )
                        ),
                        validator: (value) => value.isEmpty ? "Chưa có thông tin" : null,
                      ),
                      SizedBox(height: 25,),
                      Container(
                        padding: EdgeInsets.all(4),
                        child: picked
                            ? Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(_image),
                                  fit: BoxFit.cover)
                          ),
                        )
                            : DottedBorder(
                          borderType: BorderType.RRect,
                          color: Colors.blue,
                          strokeWidth: 3,
                          dashPattern: [8,4],
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
                                    image: NetworkImage(widget.beverageSnapshot.beverages.image),
                                    fit: BoxFit.cover)
                            ),
                            child: IconButton(
                                icon: Icon(Icons.add_a_photo_outlined,color: Colors.blue,size: 70,),
                                onPressed: () =>
                                    chooseImage()
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25,),
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
                                Text('Cập nhập', style: TextStyle(fontSize: 25, color: Colors.white),)
                              ],
                            ),
                            onPressed:() {
                              if(_formState.currentState.validate()) {
                                setState(() {
                                  added = true;
                                });
                                uploadFile().whenComplete((){
                                  setState(() {
                                    added = false;
                                  });
                                  Navigator.of(context).pop();
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
                          'Cập nhập...',
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
  String getCatagoryId(){
    if(cataID==''){
      return widget.beverageSnapshot.beverages.catagoryId;
    }
    else{
      return cataID;
    }
  }
  Future uploadFile() async {
    if(_image==null){
      widget.beverageSnapshot.documentReference.update({
        'catagoryId' : getCatagoryId(),
        'info': infoControl.text,
        'name': nameControl.text,
        'price': priceControl.numberValue
      });
    }
    else{
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(_image.path)}');
      await ref.putFile(_image).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          widget.beverageSnapshot.documentReference.update({
            'catagoryId' : getCatagoryId(),
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
  }
}

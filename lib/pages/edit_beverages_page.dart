import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tn_app/modules/beverages.dart';
import 'package:do_an_tn_app/modules/catogories.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:do_an_tn_app/datas/data.dart';
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
  TextEditingController priceControl = TextEditingController();
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
          title: Text('Chỉnh sửa thông tin'),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formState,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      TextFormField(
                        controller: nameControl..text = widget.beverageSnapshot.beverages.name,
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
                              value: widget.beverageSnapshot.beverages.catagoryId,
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
                      SizedBox(height: 10,),
                      TextFormField(
                        controller: priceControl..text = widget.beverageSnapshot.beverages.price.toString(),
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
                        controller: infoControl..text = widget.beverageSnapshot.beverages.description,
                        maxLines: null,
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
                                  fit: BoxFit.cover)
                          ),
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
                                image: DecorationImage(
                                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
                                    image: NetworkImage(widget.beverageSnapshot.beverages.image),
                                    fit: BoxFit.cover)
                            ),
                            child: IconButton(
                                icon: Icon(Icons.add_a_photo_outlined,color: Colors.blue,size: 40,),
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
                                Text('Cập nhập', style: TextStyle(fontSize: 15, color: Colors.white),)
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
                          'Cập nhập...',
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
        'price': int.parse(priceControl.text)
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
  }
}

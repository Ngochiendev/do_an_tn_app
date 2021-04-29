import 'dart:math';

import 'package:do_an_tn_app/datas/data.dart';
import 'package:do_an_tn_app/modules/beverages.dart';
import 'package:do_an_tn_app/pages/add_beverages.dart';
import 'package:do_an_tn_app/pages/edit_beverages_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
class MenuPage extends StatefulWidget {
  static const String routeName = 'MenuPage';
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _currentSortColumn = 1;
  bool _isAscending = false;
  @override
  Widget build(BuildContext context) {
    FireStoreDatabaseBeverage fireStoreBeverages = Provider.of<FireStoreDatabaseBeverage>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Menu',style: TextStyle(
              fontSize: 30,
              fontFamily: 'Berkshire Swash',
              fontWeight: FontWeight.bold)
          ),
          centerTitle: true,
        ),
        floatingActionButton:  FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context, AddBeverages.routeName);
          },
          child:  Icon(Icons.add, color: Colors.white,),
        ),
        body: StreamBuilder(
          stream: fireStoreBeverages.getBeverageFromFireBase(_isAscending, _currentSortColumn),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return ListView(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        sortColumnIndex: _currentSortColumn,
                        sortAscending: _isAscending,
                        dataRowHeight: 70,
                        columns: [
                          DataColumn(label: Text('Tên', style: TextStyle(fontSize: 20),)),
                          DataColumn(
                            label: Text('Danh mục', style: TextStyle(fontSize: 20),),
                            onSort: (columnIndex, _){
                              setState(() {
                                _currentSortColumn = columnIndex;
                                if(_isAscending == true) {
                                  _isAscending = false;
                                }
                                else{
                                  _isAscending = true;
                                }
                              });
                            }
                          ),
                          DataColumn(label: Text('Ảnh', style: TextStyle(fontSize: 20),)),
                          DataColumn(
                              label: Text('Giá', style: TextStyle(fontSize: 20),),
                              onSort: (columnIndex, _){
                                setState(() {
                                  _currentSortColumn = columnIndex;
                                  if(_isAscending == true) {
                                    _isAscending = false;
                                  }
                                  else{
                                    _isAscending = true;
                                  }
                                });
                              }
                          ),
                          DataColumn(label: Text('Xoá', style: TextStyle(fontSize: 20),)),
                          DataColumn(label: Text('Sửa', style: TextStyle(fontSize: 20),)),
                        ],
                        rows: _buildList(context, snapshot)
                    ),
                  )
                ],
              );
            }
            return Center(child: CircularProgressIndicator(),);
          },
        )

      ),
    );
  }
  List<DataRow> _buildList(BuildContext context,AsyncSnapshot<List<BeverageSnapshot>> snapshot ){
    return snapshot.data.map((data) => _buildRow(context, data)).toList();

  }
  DataRow _buildRow(BuildContext context, BeverageSnapshot data){
    return DataRow(
        cells: [
            DataCell(Text(data.beverages.name, style: TextStyle(fontSize: 16),)),
            DataCell(Text(data.beverages.catagoryId, style: TextStyle(fontSize: 16),)),
            DataCell(
          Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            width: 55,
            height: 55,
            child: FadeInImage.memoryNetwork(
                fit: BoxFit.cover,
                placeholder: kTransparentImage,
                image: data.beverages.image
            ),
          )
      ),
            DataCell(Text(NumberFormat('###,###','es_US').format(data.beverages.price), style: TextStyle(fontSize: 16),)),
            DataCell(
                IconButton(
                  icon: Icon(Icons.cancel, color: Colors.red,),
                  onPressed: (){
                    _showDeleteAlert(data,context);
                  },
              )
            ),
            DataCell(
                IconButton(
                  icon: Icon(Icons.article_rounded, color: Colors.amberAccent,),
                  onPressed: (){
                    Navigator.pushNamed(context, EditBeveragesPage.routeName, arguments: {'beverageSnapshot': data});
                  },
                )
            ),
          ]);
  }
  Future<void> _showDeleteAlert(BeverageSnapshot beverageSnapshot,BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Icon(Icons.warning_amber_outlined, color: Colors.amberAccent,size: 60,),
              Text('Bạn có chắc muốn xóa sản phẩm',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),),
            ],
          ),
          contentPadding: EdgeInsets.all(5),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(height: 15,),
                Row(
                  children: [
                    SizedBox(width: 20,),
                    Text('Tên: ', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 10,),
                    Text(beverageSnapshot.beverages.name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    SizedBox(width: 20,),
                    Text('Giá: ', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 10,),
                    Text('${NumberFormat('###,###','es_US').format(beverageSnapshot.beverages.price)} VNĐ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                  ],
                ),
                SizedBox(height: 18,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  height: 160,
                  child: FadeInImage.memoryNetwork(
                      fit: BoxFit.cover,
                      placeholder: kTransparentImage,
                      image: beverageSnapshot.beverages.image
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Xác nhận', style: TextStyle(color: Colors.red, fontSize: 20),),
              onPressed: () {
                Navigator.of(context).pop();
                beverageSnapshot.documentReference.delete();
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
}

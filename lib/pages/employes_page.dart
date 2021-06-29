import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tn_app/widget/table_assign_checkbox.dart';
import 'package:flutter/material.dart';
class EmployesPage extends StatefulWidget {
  static const String routeName = 'EmployesPage';
  @override
  _EmployesPageState createState() => _EmployesPageState();
}

class _EmployesPageState extends State<EmployesPage> {
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  TextEditingController nameControl = TextEditingController();
  TextEditingController passControl = TextEditingController();
  TextEditingController comfirmPassControl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Future<void> _showAddEmployeeDialog(QuerySnapshot snapshot) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thêm nhân viên mới', textAlign: TextAlign.center, style: TextStyle(fontSize: 29),),
            contentPadding: EdgeInsets.all(25),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Form(
                    key: _formState,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      children: [
                        SizedBox(height: 15,),
                        Container(
                          width: 500,
                          child: TextFormField(
                            style: TextStyle(fontSize: 25),
                            controller: nameControl,
                            decoration: InputDecoration(
                                errorStyle: TextStyle(fontSize: 16),
                                labelStyle: TextStyle(fontSize: 25),
                                contentPadding: EdgeInsets.all(20),
                                labelText: 'Tên nhân viên(không dấu)',
                                prefixIcon: Icon(Icons.perm_identity_outlined,size: 30,),
                                border: OutlineInputBorder(
                                    borderRadius:BorderRadius.all(Radius.circular(20))
                                )
                            ),
                            // onSaved: (newValue) {mh.tenMH=newValue;},
                            validator: (value) => value.isEmpty ? "Chưa có tên nhân viên " : null,
                          ),
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          style: TextStyle(fontSize: 25),
                          controller: passControl,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 16),
                              labelText: 'Mật khẩu',
                              labelStyle: TextStyle(fontSize: 25),
                              contentPadding: EdgeInsets.all(20),
                              prefixIcon: Icon(Icons.lock_open, size: 30,),
                              border: OutlineInputBorder(
                                  borderRadius:BorderRadius.all(Radius.circular(20))
                              )
                          ),
                          // onSaved: (newValue) {mh.tenMH=newValue;},
                          validator: (value) => value.isEmpty ? "Chưa có mật khẩu " : null,
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          style: TextStyle(fontSize: 25),
                          controller: comfirmPassControl,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 16),
                              labelText: 'Xác nhận mật khẩu',
                              labelStyle: TextStyle(fontSize: 25),
                              contentPadding: EdgeInsets.all(20),
                              prefixIcon: Icon(Icons.admin_panel_settings_outlined,size: 30,),
                              border: OutlineInputBorder(
                                  borderRadius:BorderRadius.all(Radius.circular(20))
                              )
                          ),
                          // onSaved: (newValue) {mh.tenMH=newValue;},
                          validator: (value) {
                            if(value.isEmpty){
                              return "Chưa có xác nhận mật khẩu ";
                            }
                            else{
                              if(value != passControl.text){
                                return "Mật khẩu không khớp";
                              }
                              else{
                                return null;
                              }
                            }
                          }
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Xác nhận', style: TextStyle(color: Colors.red, fontSize: 29),),
                onPressed: () {
                  if(_formState.currentState.validate()){
                    FirebaseFirestore.instance.collection('employes').add({
                      'name': nameControl.text,
                      'pass': passControl.text,
                      'id': (snapshot.docs.length+1).toString().padLeft(3,'0'),
                      'tableAssign': []
                    });
                    Navigator.of(context).pop();
                    nameControl.clear();
                    passControl.clear();
                    comfirmPassControl.clear();
                  }
                },
              ),
              TextButton(
                child: Text('Hủy', style: TextStyle(color: Colors.grey, fontSize: 29),),
                onPressed: () {
                  Navigator.of(context).pop();
                  nameControl.clear();
                  passControl.clear();
                  comfirmPassControl.clear();
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
            title: Text('Nhân viên',style: TextStyle(
                fontSize: 40,
                fontFamily: 'Berkshire Swash',
                fontWeight: FontWeight.bold)
            ),
            centerTitle: true,
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('employes').orderBy('name').snapshots(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                return ListView(
                  children: [
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 20,),
                        RaisedButton(
                          child: Text('+ Thêm nhân viên mới', style: TextStyle(color: Colors.white, fontSize: 25),),
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          color: Colors.lightGreen,
                          onPressed: (){
                            _showAddEmployeeDialog(snapshot.data);
                          },
                        ),

                      ],
                    ),
                    SizedBox(height: 30,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          columnSpacing: 120,
                          dataRowHeight: 120,
                          columns: [
                            DataColumn(label: Text('Nhân viên', style: TextStyle(fontSize: 30),)),
                            DataColumn(label: Text('ID', style: TextStyle(fontSize: 30),)),
                            DataColumn(label: Text('Password', style: TextStyle(fontSize: 30),)),
                            DataColumn(label: Text('Bàn phụ trách', style: TextStyle(fontSize: 30),)),
                            DataColumn(label: Text('Xoá', style: TextStyle(fontSize: 30),)),
                          ],
                          rows: _buildList(context, snapshot.data)
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
  List<DataRow> _buildList(BuildContext context,QuerySnapshot snapshot ){
    return snapshot.docs.map((DocumentSnapshot  doc) => _buildRow(context, doc)).toList();
  }
  DataRow _buildRow(BuildContext context, DocumentSnapshot employeeSnapshot){
    var _listTableAssign = employeeSnapshot.data()['tableAssign'];
    _listTableAssign.sort((a,b) => int.parse(a).compareTo(int.parse(b)));
    return DataRow(
        cells: [
          DataCell(Text(employeeSnapshot.data()['name'], style: TextStyle(fontSize: 28),)),
          DataCell(Text(employeeSnapshot.data()['id'], style: TextStyle(fontSize: 28),)),
          DataCell(Text(employeeSnapshot.data()['pass'], style: TextStyle(fontSize: 28),)),
          DataCell(
              InkWell(
               child: Container(
                 height: double.infinity,
                 width: double.infinity,
                 child: Row(
                   children: [
                     Icon(Icons.edit, size: 30, color: Colors.black26,),
                     SizedBox(width: 5,),
                     Text(
                          _listTableAssign.length > 0
                              ?  _listTableAssign.join(', ')
                              : 'Chưa chỉ định',
                          style: TextStyle(fontSize: 28)
                     ),
                   ],
                 ),
               ),
               onTap: () {
                  _showEditAssignTable(employeeSnapshot,employeeSnapshot.data()['tableAssign'],context);
               },
              )
          ),
          DataCell(
              IconButton(
                icon: Icon(Icons.cancel, color: Colors.red,size: 40,),
                onPressed: (){
                  _showDeleteAlert(employeeSnapshot,context);
                },
              )
          ),
        ]
    );
  }
  Future<void> _showDeleteAlert(DocumentSnapshot doc,BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Icon(Icons.warning_amber_outlined, color: Colors.amberAccent,size: 80,),
              Text('Bạn có chắc muốn xóa nhân viên',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),),
            ],
          ),
          contentPadding: EdgeInsets.all(5),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(height: 20,),
                Row(
                  children: [
                    SizedBox(width: 29,),
                    Text('Tên: ', style: TextStyle(fontSize: 29)),
                    SizedBox(width: 15,),
                    Text(doc.data()['name'],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 29))
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    SizedBox(width: 20,),
                    Text('MSNV: ', style: TextStyle(fontSize: 29)),
                    SizedBox(width: 10,),
                    Text(doc.data()['id'],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 29))
                  ],
                ),
                SizedBox(height: 26,),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Xác nhận', style: TextStyle(color: Colors.red, fontSize: 29),),
              onPressed: () {
                Navigator.of(context).pop();
                doc.reference.delete();
              },
            ),
            TextButton(
              child: Text('Hủy', style: TextStyle(color: Colors.grey, fontSize: 29),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _showEditAssignTable(DocumentSnapshot doc,List<dynamic> tablesAssign, BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 2, color: Colors.black45))
            ),
            child: Row(
              children: [
                Icon(Icons.app_registration , color: Colors.black26,size: 50,),
                SizedBox(width: 10,),
                Text('Chọn Bàn Cho Nhân Viên Phụ Trách',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),),
              ],
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(height: 20,),
                Row(
                  children: [
                    SizedBox(width: 20,),
                    Text('Tên nhân viên: ', style: TextStyle(fontSize: 29)),
                    SizedBox(width: 10,),
                    Text(doc.data()['name'],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 29))
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    SizedBox(width: 20,),
                    Text('MSNV: ', style: TextStyle(fontSize: 29)),
                    SizedBox(width: 10,),
                    Text(doc.data()['id'],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 29))
                  ],
                ),
                SizedBox(height: 26,),
                Container(
                  width: 300,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('tablesCount').doc('CountTablesInCafe').snapshots(),
                    builder: (context, countTables){
                      if(countTables.hasData){
                        int count = int.parse(countTables.data.data()['count'].toString());
                        return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.all(20),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 8/5,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          ),
                          itemCount: count,
                          itemBuilder: (context, index){
                            return TableAssignCheckBox(
                                tableNum: index+1,
                                check: tablesAssign.contains((index+1).toString()),
                                callBack: (assign){
                                  if(assign){
                                    tablesAssign.add((index+1).toString());
                                  }
                                  else{
                                    tablesAssign.remove((index+1).toString());
                                  }
                                }
                            );
                          }
                        );
                      }
                      return Center(child: CircularProgressIndicator(),);
                    },
                  )
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Xác nhận', style: TextStyle(color: Colors.red, fontSize: 29),),
              onPressed: () {
                doc.reference.update({
                  'tableAssign': tablesAssign
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Hủy', style: TextStyle(color: Colors.grey, fontSize: 29),),
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

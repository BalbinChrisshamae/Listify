import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mad2_midterm_project/components/appbar.dart';
import 'package:mad2_midterm_project/constants/style_constants.dart';
import 'package:mad2_midterm_project/screens/add_item_screen.dart';
import 'package:mad2_midterm_project/screens/home_screen.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:intl/intl.dart';



class AddItemScreen extends StatefulWidget {
  AddItemScreen(this.UserId, {Key? key}) : super(key: key) {
    _reference = FirebaseFirestore.instance.collection('users').doc(UserId);
    _futureData = _reference.get();
  }

  String UserId;
  late DocumentReference _reference;
  late Future<DocumentSnapshot> _futureData;
  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {


  late Map data;
  late DocumentReference _reference;
  final _formkey = GlobalKey<FormState>();

  final itemController = TextEditingController();

  final descController = TextEditingController();
  final db = FirebaseFirestore.instance;

  final collectionPath = 'users';
  var eme;
 
  DateTime current_date = DateTime.now();
  void registerClient() async {
    EasyLoading.show(
      status: 'Processing...',
    );
    String due = DateFormat('yyyy-MM-dd').format(current_date);
    await db.collection('item_list').add({
      'user_uid' : widget.UserId,
      'item': itemController.text,
      'description': descController.text,
      'duedate': due,
      'status': false
    });
    EasyLoading.showSuccess('Successfully added ToDo Item.');
    Navigator.pop(context);
  }

  void validateInput() {
    if (eme == 'not null') {
      //cause form to validate
      if (_formkey.currentState!.validate()) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.confirm,
          text: null,
          title: 'Are you sure?',
          confirmBtnText: 'YES',
          cancelBtnText: 'No',
          onConfirmBtnTap: () {
            //yes
            Navigator.pop(context);
            registerClient();
          },
        );
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Due Date'),
              content: Text("Please enter due date to proceed registration"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: widget._futureData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Some error occurred ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            DocumentSnapshot documentSnapshot = snapshot.data;
            data = documentSnapshot.data() as Map;
            return Scaffold(
              appBar: AppbarAccount(sex: data['sex'], name: data['firstname']),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  
                  child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Add ToDo Item:'),
                        const SizedBox(
                          height: 12.0,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required. Please enter the ToDo Item.';
                            }
                            return null;
                          },
                          controller: itemController,
                          decoration: const InputDecoration(
                            labelText: 'To Do',
                            border: OutlineInputBorder(),
                          ),
                          style: inputTextSize,
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required. Please enter description.';
                            }
                            return null;
                          },
                          controller: descController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          style: inputTextSize,
                          minLines: 2,
                          maxLines: 5,
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        const Text(
                          'Due Date : ',
                          style: inputTextSize,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: backColor),
                          onPressed: () async {
                            DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: current_date,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));

                            if (newDate == null) return;

                            if (newDate != null) {
                              eme = 'not null';
                            }
                            setState(() {
                              current_date = newDate;
                            });
                          },
                          child: Text(
                            ' ${current_date.year}/${current_date.month}/${current_date.day}',
                            style: inputTextSize,
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        ElevatedButton(
                          onPressed: validateInput,
                          style: ElevatedButton.styleFrom(
                              shape: roundShape, backgroundColor: backColor),
                          child: const Text('ADD', style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                          OutlinedButton(
                 onPressed: () => Navigator.pop(context
                  ),
               
                  style: OutlinedButton.styleFrom(
                    shape: roundShape,
                    backgroundColor: Colors.white38,
                  ),
                  child: const Text('Cancel',),
                ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        });
  }
}

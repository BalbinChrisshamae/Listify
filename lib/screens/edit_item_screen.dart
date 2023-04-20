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

class EditItemScreen extends StatefulWidget {
  EditItemScreen(this.UserId, this.documents, this.db, this.index, {Key? key})
      : super(key: key) {
    _reference = FirebaseFirestore.instance.collection('users').doc(UserId);
    _futureData = _reference.get();
  }

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents;
  final FirebaseFirestore db;
  final int index;
  String UserId;
  late DocumentReference _reference;
  late Future<DocumentSnapshot> _futureData;
  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  late Map data;
  late DocumentReference _reference;
  final _formkey = GlobalKey<FormState>();
  final itemController = TextEditingController();

  final descController = TextEditingController();
  final db = FirebaseFirestore.instance;

  final collectionPath = 'users';
  var eme;
  bool isUpdate = false;
  bool showdate = true;
  var editTime;

  DateTime? bday;

  void registerClient() async {
    if (bday == null) {
      await db
          .collection('item_list')
          .doc(widget.documents[widget.index].id)
          .update({
        'item': itemController.text,
        'description': descController.text
      });
    } else {
      String due = DateFormat('yyyy-MM-dd').format(editTime);
      await db
          .collection('item_list')
          .doc(widget.documents[widget.index].id)
          .update({
        'item': itemController.text,
        'description': descController.text,
        'duedate': due
      });
    }

    EasyLoading.showSuccess('Successfully updated ToDo Item.');
    Navigator.pop(context);
  }

  void validateInput() {
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
  }

  @override
  Widget build(BuildContext context) {
    var dueTime = DateTime.parse(widget.documents[widget.index]['duedate']);
    String stringdue = DateFormat('MMMM d, y').format(dueTime);

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
                        const Text('Edit ToDo Item:'),
                        const SizedBox(
                          height: 12.0,
                        ),
                        TextFormField(
                          enabled: isUpdate,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required. Please enter the ToDo Item.';
                            }
                            return null;
                          },
                          controller: itemController
                            ..text = widget.documents[widget.index]['item'],
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
                          enabled: isUpdate,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required. Please enter description.';
                            }
                            return null;
                          },
                          controller: descController
                            ..text =
                                widget.documents[widget.index]['description'],
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
                        Visibility(
                          visible: showdate,
                          child: TextFormField(
                            enabled: isUpdate,
                            controller: TextEditingController()
                              ..text = stringdue,
                            decoration: const InputDecoration(
                              labelText: 'Birth Date',
                              border: OutlineInputBorder(),
                            ),
                            style: inputTextSize,
                          ),
                        ),
                        Visibility(
                          visible: isUpdate,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
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
                                        initialDate: dueTime,
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100));

                                    if (newDate == null) return;

                                    if (newDate != null) {
                                      eme = 'not null';
                                      bday = newDate;
                                    }
                                    setState(() {
                                      dueTime = newDate;
                                      editTime = newDate;
                                      bday = newDate;
                                    });
                                  },
                                  child: bday != null
                                      ? Text(
                                          ' ${bday!.year} / ${bday!.month} / ${bday!.day}')
                                      : Text(
                                          '${dueTime.year}/${dueTime.month}/${dueTime.day}')),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        ElevatedButton(
                          onPressed: isUpdate
                              ? () {
                                  validateInput();
                                }
                              : () {
                                  setState(() {
                                    isUpdate = !isUpdate;
                                    showdate = !showdate;
                                  });
                                },
                          style: ElevatedButton.styleFrom(
                              shape: roundShape, backgroundColor: backColor),
                          child: isUpdate
                              ? const Text(
                                  'SUBMIT EDIT',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : const Text(
                                  ' EDIT ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                        ),
                        OutlinedButton(
                          onPressed: isUpdate
                              ? () {
                                  setState(() {
                                    isUpdate = !isUpdate;
                                    showdate = !showdate;
                                  });
                                }
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            shape: roundShape,
                            backgroundColor: Colors.white38,
                          ),
                          child: isUpdate
                              ? const Text(
                                  'Cancel',
                                )
                              : const Icon(Icons.arrow_back_ios_new),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        });
  }
}

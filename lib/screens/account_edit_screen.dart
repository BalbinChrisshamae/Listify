import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mad2_midterm_project/components/appbar.dart';
import 'package:mad2_midterm_project/constants/style_constants.dart';
import 'package:mad2_midterm_project/screens/add_item_screen.dart';
import 'package:mad2_midterm_project/screens/home_screen.dart';
import 'package:mad2_midterm_project/screens/user_screen.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:intl/intl.dart';

class AcountEditScreen extends StatefulWidget {
  AcountEditScreen(this.UserId, {Key? key}) : super(key: key) {
    _reference = FirebaseFirestore.instance.collection('users').doc(UserId);
    _futureData = _reference.get();
  }

  String UserId;
  late DocumentReference _reference;
  late Future<DocumentSnapshot> _futureData;
  @override
  State<AcountEditScreen> createState() => _AcountEditScreenState();
}

class _AcountEditScreenState extends State<AcountEditScreen> {
  late Map data;
  late DocumentReference _reference;
  final _formkey = GlobalKey<FormState>();
  final itemController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final sexController = TextEditingController();
  final bdayController = TextEditingController();

  final collectionPath = 'users';
  bool isUpdate = false;
  bool showdate = true;
  DateTime? bday;
  var userbday;
  var eme;




  void validateInput() {
    if (_formkey.currentState!.validate()) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: '',
        title: 'Are you sure you want to update your records?',
        confirmBtnText: 'YES',
        cancelBtnText: 'No',
        onCancelBtnTap: () {
          Navigator.pop(context);
        },
        onConfirmBtnTap: () {
          //yes
          Navigator.pop(context);

          if (bday == null) {
            Map<String, dynamic> dataToUpdate = {
              'firstname': fnameController.text,
              'lastname': lnameController.text,
              'sex': sexController.text,
            };

            //Call update()
            widget._reference.update(dataToUpdate);
          } else {
            Map<String, dynamic> dataToUpdate = {
              'firstname': fnameController.text,
              'lastname': lnameController.text,
              'sex': sexController.text,
              'birthdate': Timestamp.fromDate(userbday),
            };
            //Call update()
            widget._reference.update(dataToUpdate);
          }
          EasyLoading.showSuccess('Your account has been updated.');
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
                builder: (context) => UserScreen(widget.UserId)));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final fnameController = TextEditingController();
    // final lnameController = TextEditingController();
    // final sexController = TextEditingController();
    return FutureBuilder<DocumentSnapshot>(
        future: widget._futureData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Some error occurred ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            DocumentSnapshot documentSnapshot = snapshot.data;
            data = documentSnapshot.data() as Map;
            Timestamp timestamp = data['birthdate'];
            DateTime birthdate = timestamp.toDate();

            String birthDateString =
                '${DateFormat('MMMM dd, yyyy').format(birthdate)}';
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
                        const SizedBox(
                          height: 12.0,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required. Please enter your first name.';
                            }
                            return null;
                          },
                          enabled: isUpdate,
                          controller: fnameController..text = data['firstname'],
                          decoration: const InputDecoration(
                            labelText: 'First Name',
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
                              return 'Required. Please enter last name.';
                            }
                            return null;
                          },
                          enabled: isUpdate,
                          controller: lnameController..text = data['lastname'],
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
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
                              return 'Required. Please enter sex.';
                            } else if (value != 'Female' && value != 'Male') {
                              return 'Please enter valid sex (Female, Male).';
                            }
                            return null;
                          },
                          controller: sexController..text = data['sex'],
                          decoration: const InputDecoration(
                            labelText: 'Sex',
                            border: OutlineInputBorder(),
                          ),
                          style: inputTextSize,
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Visibility(
                          visible: showdate,
                          child: TextFormField(
                            enabled: isUpdate,
                            controller: bdayController..text = birthDateString,
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
                                Text(
                                  'Birth Date: ${birthDateString}',
                                  style: inputTextSize,
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: backColor),
                                  onPressed: () async {
                                    DateTime? newDate = await showDatePicker(
                                        context: context,
                                        initialDate: birthdate,
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100));

                                    if (newDate == null) return;

                                    if (newDate != null) {
                                      eme = 'not null';
                                      bday = newDate;
                                      
                                    }
                                    setState(() {
                                      bday = newDate;
                                      userbday =  newDate;
                                    });
                                  },
                                  child: bday != null
                                      ? Text(
                                          ' ${bday!.year} / ${bday!.month} / ${bday!.day}')
                                      : Text('${birthDateString}'),
                                ),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                
                              ],
                            )),
                            ElevatedButton(
                                  onPressed: isUpdate
                                      ? () {
                                          validateInput();
                                          //Navigator.pop(context);
                                        }
                                      : () {
                                          setState(() {
                                            isUpdate = !isUpdate;
                                            showdate = !showdate;
                                          });
                                        },
                                  style: ElevatedButton.styleFrom(
                                      shape: roundShape,
                                      backgroundColor: backColor),
                                  child: isUpdate
                                      ? Text(
                                          'SUBMIT EDIT',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          ' EDIT ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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
                                      ? Text(
                                          'Cancel',
                                        )
                                      : Icon(Icons.arrow_back_ios_new),
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

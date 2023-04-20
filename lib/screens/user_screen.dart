import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad2_midterm_project/components/all_list.dart';
import 'package:mad2_midterm_project/components/appbar.dart';
import 'package:mad2_midterm_project/components/finished_list.dart';
import 'package:mad2_midterm_project/components/ongoing_list.dart';
import 'package:mad2_midterm_project/components/tab_bar.dart';
import 'package:mad2_midterm_project/constants/style_constants.dart';
import 'package:mad2_midterm_project/screens/add_item_screen.dart';
import 'package:mad2_midterm_project/screens/home_screen.dart';

class UserScreen extends StatefulWidget {
  UserScreen(this.UserId, {Key? key}) : super(key: key) {
    _reference = FirebaseFirestore.instance.collection('users').doc(UserId);
    _futureData = _reference.get();
  }

  String UserId;
  late DocumentReference _reference;
  late Future<DocumentSnapshot> _futureData;
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Map data;
  late DocumentReference _reference;
  final _formkey = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final fnameController = TextEditingController();
    final lnameController = TextEditingController();
    return FutureBuilder<DocumentSnapshot>(
        future: widget._futureData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Some error occurred ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            DocumentSnapshot documentSnapshot = snapshot.data;
            data = documentSnapshot.data() as Map;

            return DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar:
                    AppbarAccount(sex: data['sex'], name: data['firstname']),
                body: Column(
                  children: [
                    SizedBox(
                      height: 55,
                      child: TabbarWidget(),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(child: AllList(db: db, widget: widget)),
                          ),
                           Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(child: OngoingListWidget(db: db, widget: widget)),
                          ),
                         
                           Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(child: FinishedListWidget(db: db, widget: widget)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: backColor,
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => AddItemScreen(widget.UserId),
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
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


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad2_midterm_project/components/list_card.dart';
import 'package:mad2_midterm_project/screens/user_screen.dart';
import 'package:intl/intl.dart';

class AllList extends StatelessWidget {
  const AllList({
    super.key,
    required this.db,
    required this.widget,
  });

  final FirebaseFirestore db;
  final UserScreen widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Expanded(child: AllListWidget(db: db, widget: widget))],
    );
  }
}

class AllListWidget extends StatelessWidget {
  const AllListWidget({
    super.key,
    required this.db,
    required this.widget,
  });

  final FirebaseFirestore db;
  final UserScreen widget;

  @override
  Widget build(BuildContext context) {
    String current_date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String due;
    var tileColor = Colors.white;
    Widget dueText = Text('');

    return StreamBuilder(
        stream: db
            .collection('item_list')
            .where('user_uid', isEqualTo: widget.UserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            var documents = snapshot.data!.docs;
            return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  DateTime dateTime =
                      DateTime.parse(documents[index]['duedate']);
                  due = DateFormat('MMMM d, y').format(dateTime);

                  if (current_date == documents[index]['duedate'] &&
                      documents[index]['status'] == false) {
                    tileColor = Color.fromARGB(255, 231, 236, 248);
                    dueText = Text(
                      ' Due Today: ${due}',
                      style: TextStyle(color: Colors.red),
                    );
                  } else if ((dateTime.isBefore(DateTime.now())) &&
                      documents[index]['status'] == false) {
                    tileColor = Color.fromARGB(255, 184, 196, 224);
                    dueText = Text(
                      'PAST DUE: ${due}',
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    );
                  } else {
                    tileColor = Colors.white;
                    dueText = Text(
                      due,
                    );
                  }

                  return ListCard(
                      documents: documents,
                      index: index,
                      db: db,
                      tileColor: tileColor,
                      dueText: dueText);
                });
          } else {
            return const Center(child: Text('No records'));
          }
        });
  }
}

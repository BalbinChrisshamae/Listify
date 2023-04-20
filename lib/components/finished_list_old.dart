import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad2_midterm_project/screens/user_screen.dart';
import 'package:intl/intl.dart';

class FinishedList extends StatelessWidget {
  const FinishedList ({
    super.key,
    required this.db,
    required this.widget,
  });

  final FirebaseFirestore db;
  final UserScreen widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Expanded(child: FinishedListWidget(db: db, widget: widget))],
    );
  }
}

class FinishedListWidget extends StatelessWidget {
  const FinishedListWidget({
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
             .where('status', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          var documents = snapshot.data!.docs;
          return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                DateTime dateTime = DateTime.parse(documents[index]['duedate']);
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
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  );
                } else {
                  tileColor = Colors.white;
                  dueText = Text(
                   due,
                  );
                }

                return Card(
                  child: Dismissible(
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_forever,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    key: ValueKey(documents[index].id),
                    onDismissed: (direction) async {
                      await db
                          .collection('item_list')
                          .doc(documents[index].id)
                          .delete();
                    },
                    child: ListTile(
                      tileColor: tileColor,
                      title: Text(documents[index]['item']),
                      subtitle: dueText,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            activeColor: Colors.grey,
                            value: documents[index]['status'],
                            onChanged: (value) async {
                              bool val;
                              if (value == 'false') {
                                val = true;
                              } else {
                                val = false;
                              }
                              await db
                                  .collection('item_list')
                                  .doc(documents[index].id)
                                  .update({'status': value});
                            },
                          ),
                          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }
}

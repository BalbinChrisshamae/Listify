
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad2_midterm_project/screens/edit_item_screen.dart';

class ListCard extends StatelessWidget {
  const ListCard({
    super.key,
    required this.documents,
    required this.db,
    required this.tileColor,
    required this.dueText,
    required this.index
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents;
  final FirebaseFirestore db;
  final Color tileColor;
  final Widget dueText;
  final int index;

  @override
  Widget build(BuildContext context) {
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
              IconButton(onPressed: (){
                  var uid = FirebaseAuth.instance.currentUser!.uid;
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>EditItemScreen(uid, documents, db, index)
                      // EditItemScreen(uid,documents,index, db),
                    ),
                  );}, icon: Icon(Icons.edit)),
            ],
          ),
        ),
      ),
    );
  }
}

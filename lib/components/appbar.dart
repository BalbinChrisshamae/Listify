import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad2_midterm_project/constants/style_constants.dart';
import 'package:mad2_midterm_project/screens/account_edit_screen.dart';
import 'package:mad2_midterm_project/screens/home_screen.dart';

class AppbarAccount extends StatelessWidget implements PreferredSizeWidget {
  const AppbarAccount({
    Key? key,
    required this.sex,
    required this.name,
  }) : super(key: key);

  final String sex;
  final String name;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        backgroundColor: backColor,
        title: Text(
          name,
          style: TextStyle(
            color: fColor,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundImage: sex == 'Female'
                ? const AssetImage('assets/images/girl.png')
                : const AssetImage('assets/images/boy.png'),
          ),
        ),
        actions: [
          DropdownButton(
            icon: const Icon(Icons.more_vert),
            items: [
              DropdownMenuItem(
                child: Text(
                  'Logout',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                value: 'logout',
              ),
              DropdownMenuItem(
                child: Text(
                  'Account',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                value: 'account',
              ),
            ],
            onChanged: (val) {
              if (val == 'logout') {

                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              }else{
                  var uid = FirebaseAuth.instance.currentUser!.uid;
                  Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => AcountEditScreen(uid),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}


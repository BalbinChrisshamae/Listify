import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad2_midterm_project/constants/style_constants.dart';
import 'package:mad2_midterm_project/screens/login_screen.dart';
import 'package:mad2_midterm_project/screens/register_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wsize = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(12),
              child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
              Container(
                padding: EdgeInsets.all(12),
                child: Center(
                    child: Text(
                  'Listify',
                  style: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold, color: backColor),
                )),
              ),
              Container(
                  padding: EdgeInsetsDirectional.only(top: 20),
                  child: Image.asset(
                    'assets/images/bgpic.png',
                    width: wsize * 0.8,
                    height: wsize * 0.8,
                  )),
              Center(
                  child: Text(
                'Welcome to Listify',
                style: TextStyle(
                  color: fColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              )),
              Center(
                  child: Text(
                'Organize your life, one list at a time with Listify.',
                style: TextStyle(color: fColor, fontSize: 18),
                textAlign: TextAlign.center,
              )),
              const SizedBox(
                height: 12,
              ),
               OutlinedButton(
                 onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const  LoginScreen(),
                    ),
                  ),
               
                  style: OutlinedButton.styleFrom(
                    shape: roundShape,
                    backgroundColor: Colors.white38,
                  ),
                  child: const Text('Login',),
                ),
              ElevatedButton(
                      onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const  RegisterScreen(),
                    ),
                  ),
                child: Text('Join Now Register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: backColor,
                  shape: roundShape,
                ),
              ),
                    ],
                  ),
            )),
      ),
    );
  }
}

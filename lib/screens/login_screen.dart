import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mad2_midterm_project/constants/style_constants.dart';
import 'package:mad2_midterm_project/screens/user_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    const inputTextSize = TextStyle(
      fontSize: 16,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    'Hello Again!',
                    style: TextStyle(
                      color: fColor,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                      color: fColor,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    'back',
                    style: TextStyle(
                      color: fColor,
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
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
                            return 'Required. Please enter an email address.';
                          }
                          if (!EmailValidator.validate(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        controller: emailController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 218, 235, 249),
                          labelText: 'Email Address',
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
                            return '*Required. Please enter your password.';
                          }
                          if (value.length <= 6) {
                            return 'Password should be more than 6 characters.';
                          }
                          return null;
                        },
                        obscureText: obscurePassword,
                        controller: passwordController,
                        decoration: InputDecoration(
                           filled: true,
                          fillColor: Color.fromARGB(255, 218, 235, 249),
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                            icon: Icon(obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                        style: inputTextSize,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(12),
                            shape: roundShape,
                            backgroundColor: backColor),
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    //login
    if (_formkey.currentState!.validate()) {
      EasyLoading.show(status: 'Processing...');
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((userCredential) {
        String userId = userCredential.user!.uid;
        EasyLoading.dismiss();
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
                builder: (context) => UserScreen(userId)));
      }).catchError((err) {
        print(err);
        EasyLoading.showError('Invalid email and/or password.');
      });
    }
  }
}

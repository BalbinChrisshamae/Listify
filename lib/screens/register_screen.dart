import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mad2_midterm_project/constants/style_constants.dart';
import 'package:mad2_midterm_project/screens/user_screen.dart';
import 'package:quickalert/quickalert.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final sexController = TextEditingController();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpassController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  var obscurePassword = true;

  final collectionPath = 'users';
  var eme;

  DateTime current_date = DateTime.now();

  void registerClient() async {
    try {
      EasyLoading.show(
        status: 'Processing...',
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (userCredential.user == null) {
        throw FirebaseAuthException(code: 'null-usercredential');
      }
      //created user account -> uid
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection(collectionPath).doc(uid).set({
        'firstname': fnameController.text,
        'lastname': lnameController.text,
        'sex': sexController.text,
        'birthdate': current_date,
      });

      EasyLoading.showSuccess('User account has been registered.');
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => UserScreen(uid),
        ),
      );
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'weak-password') {
        EasyLoading.showError(
            'Your password is weak. Please enter more than 6 characters.');
        return;
      }
      if (ex.code == 'email-already-in-use') {
        EasyLoading.showError(
            ('Your password is already registered. Please enter a new email address.'));
        return;
      }
      if (ex.code == 'null-usercredential') {
        EasyLoading.showError(
            'An error occurred while creating your account. Please try again');
        return;
      }
      print(ex.code);
    }
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
              title: Text('Birth Date is Required'),
              content:
                  Text("Please enter your birth date to proceed registration"),
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
    const inputTextSize = TextStyle(
      fontSize: 16,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backColor,
        title: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Register your account:'),
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
                  controller: fnameController,
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
                  controller: lnameController,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required. Please enter sex.';
                    } else if (value != 'Female' &&
                        value != 'Male') {
                      return 'Please enter valid sex (Female, Male).';
                    }
                    return null;
                  },
                  controller: sexController,
                  decoration: const InputDecoration(
                    labelText: 'Sex',
                    border: OutlineInputBorder(),
                  ),
                  style: inputTextSize,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                const Text(
                  'Birth Date : ',
                  style: inputTextSize,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backColor
                  ),
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
                  height: 12.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter your password.';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords don\'t match.';
                    }
                    return null;
                  },
                  obscureText: obscurePassword,
                  controller: confirmpassController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  style: inputTextSize,
                ),
                ElevatedButton(
                
                  onPressed: validateInput,
                  style: ElevatedButton.styleFrom(
                    shape: roundShape,
                    //backgroundColor: backColor
                  ),
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

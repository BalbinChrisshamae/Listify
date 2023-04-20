import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2_midterm_project/firebase_options.dart';
import 'package:mad2_midterm_project/screens/home_screen.dart';
import 'package:mad2_midterm_project/screens/user_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MidtermProject());
}

class MidtermProject extends StatelessWidget {
  const MidtermProject({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.spaceGrotesk().fontFamily
      ),
      home: StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            var uid = FirebaseAuth.instance.currentUser!.uid;
            print(uid);
            return UserScreen(uid);
          }
          return HomeScreen();
        },
        stream: FirebaseAuth.instance.authStateChanges(),
      ),
      builder: EasyLoading.init(),
    );
  }
}

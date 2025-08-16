import 'package:flutter/material.dart';
import 'package:note_app/app/auth/login.dart';
import 'package:note_app/app/auth/signup.dart';
import 'package:note_app/app/homepage.dart';
import 'package:note_app/app/notes/add.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref =
      await SharedPreferences.getInstance(); //هيك انا صرت قادر اصل للشيرد بريف
  // باي مكان في التطبيق سواء احصل على قيمتها اول اني اسندلها قيمة

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.blue,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          centerTitle: true,
        ),
      ),
      initialRoute: sharedPref.getString("id") == null ? "/login" : "home",
      routes: {
        "/login": (context) => Login(),
        "signup": (context) => Signup(),
        "home": (context) => Homepage(),
        "addnotes": (context) => AddNotes(),
      },
    );
  }
}

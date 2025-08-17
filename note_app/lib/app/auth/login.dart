import 'package:flutter/material.dart';
import 'package:note_app/component/crud.dart';
import 'package:note_app/component/customtextfield.dart';
import 'package:note_app/component/valid.dart';
import 'package:note_app/constant/linkapi.dart';
import 'package:note_app/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formstate = GlobalKey();
  bool isLoading = false;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final Crud _crud = Crud();

  Login() async {
    isLoading = true;
    setState(() {});
    var response = await _crud.postRequest(linkLogin, {
      "email": emailcontroller.text,
      "password": passwordcontroller.text,
    });
    isLoading = false;
    setState(() {});
    if (response["status"] == "success") {
      sharedPref.setString(
        "id",
        response["data"]["id"].toString(),
      ); // هيك اي شخص لما يسجل دخول يتم
      // تسجيل الاي دي تبعه بمتغير الشيرد بريف كسترنج
      sharedPref.setString("username", response["data"]["username"]);
      sharedPref.setString("email", response["data"]["email"]);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تم تسجيل الدخول بنجاح", textAlign: TextAlign.right),
        ),
      );
      Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "البريد الالكتروني او كلمة السر او الحساب  غير صحيح",
            textAlign: TextAlign.right,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: isLoading == true
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Form(
                    key: formstate,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/images/notebook.png",
                            width: 120,
                            height: 120,
                          ),
                        ),
                        CustomtextfieldSign(
                          valid: (value) {
                            return valiInput(value!, 3, 30);
                          },
                          hinttext: "email",
                          mycontroller: emailcontroller,
                        ),
                        CustomtextfieldSign(
                          valid: (value) {
                            return valiInput(value!, 3, 20);
                          },
                          hinttext: "password",
                          mycontroller: passwordcontroller,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                            color: Colors.black,
                            padding: EdgeInsets.symmetric(
                              horizontal: 70,
                              vertical: 10,
                            ),
                            onPressed: () async {
                              if (formstate.currentState!.validate()) {
                                await Login();
                              }
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 7),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed("signup");
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ), 
                ],
              ),
      ),
    );
  }
}

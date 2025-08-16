import 'package:flutter/material.dart';
import 'package:note_app/component/crud.dart';
import 'package:note_app/component/customtextfield.dart';
import 'package:note_app/component/valid.dart';
import 'package:note_app/constant/linkapi.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  GlobalKey<FormState> formstate = GlobalKey();
  final Crud _crud = Crud(); //_ يغني انه خاص في هاي الصقحة

  bool isLoading = false;
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  signUp() async {
    isLoading = true;
    setState(() {});
    var response = await _crud.postRequest(linkSignUp, {
      "username": usernamecontroller.text,
      "email": emailcontroller.text,
      "password": passwordcontroller.text,
    });
    isLoading = false;
    setState(() {});
    if (response["status"] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تم إنشاء الحساب بنجاح", textAlign: TextAlign.right),
        ),
      );
      Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("فشلت عملية إنشاءالحساب", textAlign: TextAlign.right),
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
                            return valiInput(value!, 3, 20);
                          },
                          hinttext: "username",
                          mycontroller: usernamecontroller,
                        ),
                        CustomtextfieldSign(
                          valid: (value) {
                            return valiInput(value!, 5, 40);
                          },
                          hinttext: "email",
                          mycontroller: emailcontroller,
                        ),
                        CustomtextfieldSign(
                          valid: (value) {
                            return valiInput(value!, 3, 10);
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
                                await signUp();
                              }
                            },
                            child: Text(
                              "Signup",
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
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              "/login",
                              (context) => false,
                            );
                          },
                          child: Text(
                            "Login",
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

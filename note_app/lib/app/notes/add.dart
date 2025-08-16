import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/component/crud.dart';
import 'package:note_app/component/customtextfield.dart';
import 'package:note_app/component/valid.dart';
import 'package:note_app/constant/linkapi.dart';
import 'package:note_app/main.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  File? myfile;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool isLoading = false;

  GlobalKey<FormState> formstate = GlobalKey();
  final Crud _crud = Crud();

  // before image fileeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
  // addNotes() async {
  //   if (formstate.currentState!.validate()) {
  //     isLoading = true;
  //     setState(() {});
  //     var response = await _crud.postRequest(linkaAddNotes, {
  //       "title": titleController.text,
  //       "content": contentController.text,
  //       "id": sharedPref.getString("id"),
  //     });
  //     isLoading = false;
  //     setState(() {});
  //     if (response["status"] == "success") {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(
  //             "تم إضافة الملاحظة بنجاح",
  //             textAlign: TextAlign.right,
  //           ),
  //         ),
  //       );
  //       Navigator.pushNamedAndRemoveUntil(context, "home", (route) => false);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(
  //             "فشلت عملية إضافة الملاحظة",
  //             textAlign: TextAlign.right,
  //           ),
  //         ),
  //       );
  //     }
  //   }
  // }

  addNotes() async {
    if (myfile == null) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "لم يتم اختيار صورة",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await _crud.postRequestWithFile(linkaAddNotes, {
        "title": titleController.text,
        "content": contentController.text,
        "id": sharedPref.getString("id"),
      }, myfile!);
      isLoading = false;
      setState(() {});
      if (response["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "تم إضافة الملاحظة بنجاح",
              textAlign: TextAlign.right,
            ),
          ),
        );
        Navigator.pushNamedAndRemoveUntil(context, "home", (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "فشلت عملية إضافة الملاحظة",
              textAlign: TextAlign.right,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Add Notes"),
        ),
        body: isLoading == true
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: formstate,
                child: ListView(
                  children: [
                    CustomtextfieldSign(
                      hinttext: "title",
                      mycontroller: titleController,
                      valid: (value) {
                        return valiInput(value!, 3, 10);
                      },
                    ),
                    CustomtextfieldSign(
                      hinttext: "content",
                      mycontroller: contentController,
                      valid: (value) {
                        return valiInput(value!, 5, 30);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: MaterialButton(
                        color: myfile == null ? Colors.blue : Colors.green,

                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                width: double.infinity, // هيك بوخذ العرض كامل
                                height:
                                    MediaQuery.of(context).size.height * 0.2,

                                child: Column(
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        XFile? xFile = await ImagePicker()
                                            .pickImage(
                                              source: ImageSource.gallery,
                                            );
                                        myfile = File(xFile!.path);
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      },
                                      child: Text(
                                        "From Gallery",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        XFile? xFile = await ImagePicker()
                                            .pickImage(
                                              source: ImageSource.camera,
                                            );

                                        myfile = File(xFile!.path);
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      },
                                      child: Text(
                                        "From Camera",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          "Choose Image",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: MaterialButton(
                        color: Colors.blueAccent,
                        onPressed: () async {
                          await addNotes();
                        },
                        child: Text(
                          "Add Note",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

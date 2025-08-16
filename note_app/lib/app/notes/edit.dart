import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/component/crud.dart';
import 'package:note_app/component/customtextfield.dart';
import 'package:note_app/component/valid.dart';
import 'package:note_app/constant/linkapi.dart';

class EditNotes extends StatefulWidget {
  final notes;
  const EditNotes({super.key, required this.notes});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool isLoading = false;

  File? myfile;

  GlobalKey<FormState> formstate = GlobalKey();
  final Crud _crud = Crud();

  editNotes() async {
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response;

      if (myfile == null) {
        response = await _crud.postRequest(linkEditNotes, {
          "title": titleController.text,
          "content": contentController.text,
          "id": widget.notes["notes_id"].toString(),
          "imagename": widget.notes["notes_image"].toString(),
        });
      } else {
        response = await _crud.postRequestWithFile(linkEditNotes, {
          "title": titleController.text,
          "content": contentController.text,
          "imagename": widget.notes["notes_image"].toString(),
          "id": widget.notes["notes_id"].toString(),
        }, myfile!);
      }
      isLoading = false;
      setState(() {});
      if (response["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "تم تعديل الملاحظة بنجاح",
              textAlign: TextAlign.right,
            ),
          ),
        );
        Navigator.pushNamedAndRemoveUntil(context, "home", (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "فشلت عملية تعديل الملاحظة",
              textAlign: TextAlign.right,
            ),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    titleController.text = widget.notes["notes_title"];
    contentController.text = widget.notes["notes_content"];
    super.initState();
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
          title: Text("Edit Notes"),
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
                        return valiInput(value!, 3, 50);
                      },
                    ),
                    CustomtextfieldSign(
                      hinttext: "content",
                      mycontroller: contentController,
                      valid: (value) {
                        return valiInput(value!, 5, 100);
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
                          await editNotes();
                        },
                        child: Text(
                          "Edit Note",
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

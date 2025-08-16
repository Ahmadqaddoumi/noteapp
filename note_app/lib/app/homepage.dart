import 'package:flutter/material.dart';
import 'package:note_app/app/notes/edit.dart';
import 'package:note_app/component/cardnotes.dart';
import 'package:note_app/component/crud.dart';
import 'package:note_app/constant/linkapi.dart';
import 'package:note_app/main.dart';
import 'package:note_app/modelclass/notemodel.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Crud _crud = Crud();
  bool isLoading = false;
  getNotes() async {
    var response = await _crud.postRequest(linkViewNotes, {
      "id": sharedPref.getString("id"),
    });
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              sharedPref.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "تم تسجيل الخروج بنجاح",
                    textAlign: TextAlign.right,
                  ),
                ),
              );
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil("/login", (route) => false);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "addnotes");
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,

        child: Icon(Icons.add),
      ),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                FutureBuilder(
                  future: getNotes(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data["data"] == null) {
                      //or snapshot.data["status"]==failed
                      return Center(
                        child: Text(
                          "لا يوجد ملاحظات",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      );
                    }
                    List notes = snapshot.data["data"];
                    //snapshot.data["data"] هيك انت وصل للست الي فيها مابات الملاحظات
                    //snapshot.data["status"] هاي الحالة
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: notes.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Cardnotes(
                            ontap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return EditNotes(
                                      notes: snapshot.data["data"][index],
                                    );
                                  },
                                ),
                              );
                            },

                            onlongpress: () async {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      "تأكيد الحذف",
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Text(
                                      "هل انت متأكد من حذف هذه الملاحظة؟",
                                    ),
                                    actions: [
                                      MaterialButton(
                                        color: Colors.green,
                                        onPressed: () async {
                                          isLoading = true;
                                          setState(() {});
                                          var response = await _crud.postRequest(
                                            linkDeleteNotes,
                                            {
                                              "id": snapshot
                                                  .data["data"][index]["notes_id"],
                                              "imagename": snapshot
                                                  .data["data"][index]["notes_image"],
                                            },
                                          );
                                          isLoading = false;
                                          setState(() {});
                                          if (response["status"] == "success") {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "تم حذف الملاحظة بنجاح",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            );
                                            Navigator.pushNamed(
                                              context,
                                              "home",
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "فشلت عمليةالملاحظة",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Text(
                                          "نعم",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      MaterialButton(
                                        color: Colors.red,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "لا",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            //هاض هو الجيسون مررته للدوت فرم جيسون عشان يحوله لاوبجكت
                            //snapshot.data["data"][index]
                            noteModel: NoteModel.fromJson(
                              snapshot.data["data"][index],
                            ),
                          );
                        },
                      );
                    }

                    return Center(child: Text("Loading....."));
                  },
                ),
              ],
            ),
    );
  }
}

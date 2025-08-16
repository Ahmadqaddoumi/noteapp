import 'package:flutter/material.dart';
import 'package:note_app/constant/linkapi.dart';
import 'package:note_app/modelclass/notemodel.dart';

class Cardnotes extends StatelessWidget {
  final void Function()? ontap;
  final void Function()? onlongpress;
  final NoteModel noteModel;

  const Cardnotes({
    super.key,
    required this.ontap,
    required this.noteModel,
    required this.onlongpress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      onLongPress: onlongpress,
      child: Card(
        shadowColor: Colors.black,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Image.network(
                  "$linkImageRoot/${noteModel.notesImage}",
                  width: 100,
                  height: 100,
                ),
              ),
              Expanded(
                flex: 2, //  هاي الخصاية معناها انو هاض بوخذ ثلثين  العرض
                child: ListTile(
                  title: Text("${noteModel.notesTitle}"),
                  subtitle: Text("${noteModel.notesContent}"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

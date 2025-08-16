import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomtextfieldSign extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontroller;
  String? Function(String?)? valid;
  CustomtextfieldSign({
    super.key,
    required this.hinttext,
    required this.mycontroller,
    required this.valid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: mycontroller,
        validator: valid,
        decoration: InputDecoration(
          hintText: hinttext,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

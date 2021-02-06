import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

TextStyle kMetinStili = TextStyle(
  color: Colors.black,
  fontSize: 23,
  fontWeight: FontWeight.bold,
);
TextStyle kMetinStili2 = TextStyle(
  color: Colors.white,
  fontSize: 23,
  fontWeight: FontWeight.bold,
);

Future<bool> buildShowToast() {
  return Fluttertoast.showToast(
    msg: "Formun tamamını doldurmalısınız.",
    backgroundColor: Colors.red,
  );
}

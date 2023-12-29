import 'package:flutter/material.dart';

Widget mytext(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      color: Colors.deepPurple,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget textfield(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 11,
      color: Colors.grey[600],
     
    ),
  );
}

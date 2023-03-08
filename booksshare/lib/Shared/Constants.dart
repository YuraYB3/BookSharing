// ignore_for_file: file_names

import 'package:flutter/material.dart';

var textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    labelStyle: const TextStyle(color: Colors.grey),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.white, width: 2.0)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Color(0xff008787), width: 1.0)));

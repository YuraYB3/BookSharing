// ignore_for_file: file_names

import 'package:booksshare/Shared/appTheme.dart';
import 'package:flutter/material.dart';

var textInputDecoration = const InputDecoration(
    fillColor: Colors.white,
    labelStyle: TextStyle(color: Colors.grey),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide:
            BorderSide(color: AppTheme.secondBackgroundColor, width: 1.0)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide:
            BorderSide(color: AppTheme.secondBackgroundColor, width: 2.0)));

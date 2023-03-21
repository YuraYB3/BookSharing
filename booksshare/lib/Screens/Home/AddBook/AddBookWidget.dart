// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../Services/auth.dart';
import '../../../Shared/Constants.dart';
import '../../../Services/UserBooks.dart';

class AddBookWidget extends StatefulWidget {
  const AddBookWidget({super.key});

  @override
  State<AddBookWidget> createState() => _AddBookWidgetState();
}

class _AddBookWidgetState extends State<AddBookWidget> {
  final _formKey = GlobalKey<FormState>();
  String autorBook = '';
  String nameBook = '';

  @override
  Widget build(BuildContext context) {
    AuthService auth = AuthService();
    var uId = auth.getUserID();
    BookService bookList = BookService(uId!);
    return FloatingActionButton(
        backgroundColor: const Color(0xff008787),
        child: const Icon(Icons.add),
        onPressed: () {
          showMaterialModalBottomSheet(
            bounce: true,
            context: context,
            enableDrag: true,
            builder: (BuildContext context) {
              return Container(
                height: 470,
                color: const Color(0xff008787),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: "Enter the title of the book"),
                          validator: (value) => value!.isEmpty
                              ? 'You should enter the title of the book'
                              : null,
                          style: const TextStyle(),
                          onChanged: (val) {
                            setState(() {
                              nameBook = val;
                            });
                          }),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: "Enter the author of the book"),
                        validator: (value) => value!.isEmpty
                            ? 'You should enter the author of the book'
                            : null,
                        style: const TextStyle(),
                        onChanged: (val) {
                          setState(() {
                            autorBook = val;
                          });
                        },
                      ),
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(Colors.amber)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            bookList.addBooks(nameBook, autorBook);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Add Book'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}

// ignore_for_file: file_names

import 'package:flutter/material.dart';
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
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 500,
                color: const Color(0xff008787),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
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
                      Container(
                        height: 20,
                      ),
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
                      Container(
                        height: 20,
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

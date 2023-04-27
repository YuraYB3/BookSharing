// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../Services/authService.dart';
import '../../Shared/appTheme.dart';
import '../../Services/bookService.dart';

class AddBookWidget extends StatefulWidget {
  const AddBookWidget({super.key});

  @override
  State<AddBookWidget> createState() => _AddBookWidgetState();
}

class _AddBookWidgetState extends State<AddBookWidget> {
  final _formKey = GlobalKey<FormState>();
  String autorBook = '';
  String nameBook = '';
  String descriptionBook = '';
  late XFile? file;

  @override
  Widget build(BuildContext context) {
    bool isImageLoaded = false;
    AuthService auth = AuthService();
    var uId = auth.getUserID();
    BookService bookList = BookService(uId!);
    return SizedBox(
      width: 150,
      height: 40,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: AppTheme.secondBackgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                Icons.add,
                size: 24,
                color: Colors.amber,
              ),
            ],
          ),
          onPressed: () {
            showMaterialModalBottomSheet(
              bounce: true,
              context: context,
              enableDrag: true,
              builder: (BuildContext context) {
                return Container(
                  height: 470,
                  color: AppTheme.secondBackgroundColor,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 28.0),
                              child: GestureDetector(
                                onTap: () async {
                                  ImagePicker imagePicker = ImagePicker();
                                  XFile? f = await imagePicker.pickImage(
                                      source: ImageSource.gallery);

                                  if (f != null) {
                                    setState(() {
                                      file = f;
                                      isImageLoaded = true;
                                    });
                                  }
                                },
                                child: Container(
                                  height: 250,
                                  width: 150,
                                  color: Colors.white,
                                  child: isImageLoaded == true
                                      ? Center(
                                          child: Image.file(File(file!.path),
                                              fit: BoxFit.fill),
                                        )
                                      : const Center(
                                          child: Icon(Icons.add_a_photo)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 250,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 200,
                                    child: TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: "Назва книги",
                                            hintStyle:
                                                TextStyle(color: Colors.white),
                                            labelStyle:
                                                TextStyle(color: Colors.white),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                borderSide: BorderSide(
                                                    color: AppTheme.textColor,
                                                    width: 1.0)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                borderSide: BorderSide(
                                                    color: AppTheme.textColor,
                                                    width: 2.0))),
                                        validator: (value) => value!.isEmpty
                                            ? 'Введіть назву книги'
                                            : null,
                                        style: const TextStyle(),
                                        onChanged: (val) {
                                          setState(() {
                                            nameBook = val;
                                          });
                                        }),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 200,
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          hintText: "Автор книги",
                                          hintStyle:
                                              TextStyle(color: Colors.white),
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                  color: AppTheme.textColor,
                                                  width: 1.0)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                  color: AppTheme.textColor,
                                                  width: 2.0))),
                                      validator: (value) => value!.isEmpty
                                          ? 'Введіть автор книги'
                                          : null,
                                      style: const TextStyle(),
                                      onChanged: (val) {
                                        setState(() {
                                          autorBook = val;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 200,
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          hintText: "Опис",
                                          hintStyle:
                                              TextStyle(color: Colors.white),
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                  color: AppTheme.textColor,
                                                  width: 1.0)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                  color: AppTheme.textColor,
                                                  width: 2.0))),
                                      validator: (value) => value!.isEmpty
                                          ? 'Введіть опис книги'
                                          : null,
                                      style: const TextStyle(),
                                      onChanged: (val) {
                                        setState(() {
                                          descriptionBook = val;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Colors.amber)),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                bookList.addBooks(nameBook, autorBook, file!,
                                    descriptionBook);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Додати книгу'),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}

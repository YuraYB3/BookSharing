// ignore_for_file: file_names

import 'package:booksshare/Shared/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../Services/authService.dart';
import '../../Shared/constants.dart';
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
    return Container(
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
            children: [
              const Icon(
                Icons.add,
                size: 24,
              ),
              Container(width: 5),
              const Text(
                'ADD',
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
          onPressed: () {
            showMaterialModalBottomSheet(
              bounce: true,
              context: context,
              enableDrag: true,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Container(
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
                                child: Container(
                                  height: 250,
                                  width: 150,
                                  color: Colors.white,
                                  child: isImageLoaded == true
                                      ? const Center(
                                          child: Text("Image chosen"),
                                        )
                                      : Center(
                                          child: IconButton(
                                              onPressed: () async {
                                                ImagePicker imagePicker =
                                                    ImagePicker();
                                                XFile? f =
                                                    await imagePicker.pickImage(
                                                        source: ImageSource
                                                            .gallery);
                                                setState(() {
                                                  file = f;
                                                  isImageLoaded = true;
                                                });
                                              },
                                              icon: const Icon(
                                                  Icons.add_a_photo)),
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
                                          decoration: textInputDecoration
                                              .copyWith(hintText: "Book title"),
                                          validator: (value) => value!.isEmpty
                                              ? 'You should enter the title of the book'
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
                                        decoration: textInputDecoration
                                            .copyWith(hintText: "Author"),
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
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 200,
                                      child: TextFormField(
                                        decoration: textInputDecoration
                                            .copyWith(hintText: "Description"),
                                        validator: (value) => value!.isEmpty
                                            ? 'You should enter the description'
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
                              child: const Text('Add Book'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}

// ignore_for_file: file_names

import 'package:booksshare/Services/databaseUserService.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../Shared/appTheme.dart';
import '../../Widgets/AppBar/userAppBar.dart';
import '../../Widgets/Panel/userPanel.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  UserAppBar userAppBar = UserAppBar();
  bool isChangeNameClicked = false;
  bool isChangePasswordClicked = false;
  var _newNickName = '';
  DatabaseUserService databaseUserService = DatabaseUserService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: userAppBar.headerBar(context),
        backgroundColor: AppTheme.backgroundColor,
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            commonSettings(),
            profileSettings(),
            accountSettings(),
            informationWidget(),
          ],
        ),
        drawer: UserPanel());
  }

  Widget commonSettings() {
    return Column(
      children: [
        Container(
          color: AppTheme.backgroundColor,
          height: 50,
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Загальні',
                  style: TextStyle(
                      color: AppTheme.secondBackgroundColor,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          child: Container(
            height: 50,
            color: const Color.fromARGB(255, 232, 232, 228),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.language_outlined,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Text('Мова'),
                  Expanded(child: Container()),
                  const Text('Українська'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget profileSettings() {
    return Column(
      children: [
        Container(
          color: AppTheme.backgroundColor,
          height: 50,
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Налаштування профілю',
                  style: TextStyle(
                      color: AppTheme.secondBackgroundColor,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(),
          height: 50,
          color: const Color.fromARGB(255, 232, 232, 228),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: isChangeNameClicked == false
                ? Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text('Змінити нікнейм'),
                      Expanded(child: Container()),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          setState(() {
                            isChangeNameClicked = !isChangeNameClicked;
                          });
                        },
                      )
                    ],
                  )
                : Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          setState(() {
                            isChangeNameClicked = !isChangeNameClicked;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text('Новий нікнейм:'),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                          width: 150,
                          child: TextField(
                            onChanged: (value) {
                              _newNickName = value;
                            },
                          )),
                      Expanded(child: Container()),
                      ElevatedButton(
                        onPressed: () async {
                          if (_newNickName.trim().isEmpty) {
                            Fluttertoast.showToast(
                              msg: 'Введіть нікнейм!!!',
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          } else {
                            await databaseUserService.updateName(_newNickName);
                            setState(() {
                              isChangeNameClicked = !isChangeNameClicked;
                              _newNickName = '';
                            });
                            Fluttertoast.showToast(
                              msg: 'Нікнейм оновлено!',
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: AppTheme.secondBackgroundColor,
                        ),
                        child: const Text('ОК'),
                      )
                    ],
                  ),
          ),
        ),
        GestureDetector(
          child: Container(
            height: 50,
            color: const Color.fromARGB(255, 232, 232, 228),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  Icon(
                    Icons.photo_camera,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text('Змінити фото'),
                ],
              ),
            ),
          ),
          onTap: () async {
            ImagePicker imagePicker = ImagePicker();

            XFile? file =
                await imagePicker.pickImage(source: ImageSource.gallery);

            if (file != null) {
              try {
                databaseUserService.updateProfileImage(file);
                Fluttertoast.showToast(
                  msg: 'Оновлено',
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: const Color.fromARGB(255, 43, 200, 29),
                  textColor: Colors.white,
                );
              } catch (e) {
                Fluttertoast.showToast(
                  msg: e.toString(),
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: const Color.fromARGB(255, 200, 29, 29),
                  textColor: Colors.white,
                );
              }
            } else {
              Fluttertoast.showToast(
                msg: 'Ви не обрали фото',
                gravity: ToastGravity.BOTTOM,
                backgroundColor: const Color.fromARGB(255, 200, 29, 29),
                textColor: Colors.white,
              );
            }
          },
        ),
      ],
    );
  }

  Widget accountSettings() {
    return Column(
      children: [
        Container(
          color: AppTheme.backgroundColor,
          height: 50,
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Налаштування акаунту',
                  style: TextStyle(
                      color: AppTheme.secondBackgroundColor,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          child: Container(
            height: 50,
            color: const Color.fromARGB(255, 232, 232, 228),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.password,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text('Змінити пароль'),
                    Expanded(child: Container()),
                  ],
                )),
          ),
          onTap: () async {
            await databaseUserService.updatePassword();
            Fluttertoast.showToast(
              msg: 'Лист відправлено!',
              gravity: ToastGravity.BOTTOM,
              backgroundColor: const Color.fromARGB(255, 29, 200, 38),
              textColor: Colors.white,
            );
          },
        ),
        GestureDetector(
          child: Container(
            height: 50,
            color: const Color.fromARGB(255, 232, 232, 228),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.delete_forever,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Text('Видалити профіль'),
                  Expanded(child: Container()),
                ],
              ),
            ),
          ),
          onTap: () async {
            try {
              bool confirmDelete = await showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: AppTheme.secondBackgroundColor,
                    title: const Text(
                      'Видалити акаунт',
                      style: TextStyle(color: AppTheme.textColor),
                    ),
                    content: const Text(
                      'Ви дійсно хочете видалити акаунт?',
                      style: TextStyle(color: AppTheme.textColor),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text(
                          'Відмінити',
                          style: TextStyle(color: AppTheme.iconColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Видалити',
                            style: TextStyle(color: AppTheme.iconColor)),
                      ),
                    ],
                  );
                },
              );
              if (confirmDelete == true) {
                await databaseUserService.deleteAccount(context);
              }
            } catch (e) {}
            //
          },
        ),
      ],
    );
  }

  Widget informationWidget() {
    return Column(
      children: [
        Container(
          color: AppTheme.backgroundColor,
          height: 50,
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Інформація',
                  style: TextStyle(
                      color: AppTheme.secondBackgroundColor,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          child: Container(
            height: 50,
            color: const Color.fromARGB(255, 232, 232, 228),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Text('Інформація про додаток'),
                  Expanded(child: Container()),
                ],
              ),
            ),
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return infoWidget();
                });
          },
        ),
      ],
    );
  }

  Widget infoWidget() {
    return AlertDialog(
      title: const Center(
          child: Text(
        "Інформація",
        style: TextStyle(color: Colors.white),
      )),
      backgroundColor: AppTheme.secondBackgroundColor,
      content: const SizedBox(
        height: 170,
        width: 250,
        child: Text(
          'Додаток створив: \nСтудент IV курсу\nспеціальості комп\'ютерних наук\nБережник Юрій Юрійович \n\nДодаток було створено під час виконання дипломної роботи.\n\nТНТУ, 2023',
          style: TextStyle(color: Colors.white),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Закрити",
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
  }
}

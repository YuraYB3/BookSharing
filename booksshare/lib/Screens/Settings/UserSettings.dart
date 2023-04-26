// ignore_for_file: file_names

import 'package:flutter/material.dart';

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
            child: isChangeNameClicked
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
                      const SizedBox(width: 150, child: TextField()),
                      Expanded(child: Container()),
                      ElevatedButton(
                        onPressed: () {},
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
        AnimatedContainer(
          duration: Duration(),
          height: 50,
          color: const Color.fromARGB(255, 232, 232, 228),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: isChangePasswordClicked
                ? Row(
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
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          setState(() {
                            isChangePasswordClicked = !isChangePasswordClicked;
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
                            isChangePasswordClicked = !isChangePasswordClicked;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text('Новий пароль:'),
                      const SizedBox(
                        width: 5,
                      ),
                      const SizedBox(width: 150, child: TextField()),
                      Expanded(child: Container()),
                      ElevatedButton(
                        onPressed: () {},
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
        ),
      ],
    );
  }
}

// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Services/authService.dart';
import '../../Services/messageService.dart';
import '../../Shared/appTheme.dart';
import '../../Shared/constants.dart';
import '../../Widgets/userInfo.dart';
import '../Profile/userProfile.dart';
import 'messageBubble.dart';

class MessangerScreen extends StatefulWidget {
  final String friendshipID;
  final String userID;

  const MessangerScreen(
      {super.key, required this.userID, required this.friendshipID});

  @override
  State<MessangerScreen> createState() => _MessangerScreenState();
}

class _MessangerScreenState extends State<MessangerScreen> {
  final _formKey = GlobalKey<FormState>();
  UserInformation userList = UserInformation();
  MessageService messageService = MessageService();
  var _enteredMessage = '';

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    var currentUser = authService.getUserID();
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppTheme.secondBackgroundColor,
        title: Row(
          children: [
            GestureDetector(
              child: SizedBox(
                  height: 50,
                  width: 50,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: userList.userImage(widget.userID))),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UserProfile(userID: widget.userID)));
              },
            ),
            Container(
              width: 15,
            ),
            userList.userName(widget.userID),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('message')
                  .doc(widget.friendshipID)
                  .collection('dialogue')
                  .orderBy('timeSend', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final chatDocs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      message: chatDocs[index]['message'],
                      isMe: currentUser == chatDocs[index]['senderID'],
                    );
                  },
                );
              },
            ),
          ),
          newMessageWidget(currentUser!),
        ],
      ),
    );
  }

  Widget newMessageWidget(String currentUser) {
    return Container(
      color: AppTheme.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Введіть повідмовлення...'),
                    onChanged: (value) {
                      _enteredMessage = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Будь-ласка введіть повідомлення :(';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: AppTheme.secondBackgroundColor,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      messageService.sendMessage(
                        widget.friendshipID,
                        _enteredMessage.trim(),
                        currentUser,
                      );
                      _formKey.currentState!.reset();
                      _enteredMessage = '';
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

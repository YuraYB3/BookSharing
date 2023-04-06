import 'package:booksshare/Models/userModel.dart';
import 'package:booksshare/Screens/Profile/UserProfile.dart';
import 'package:booksshare/Services/databaseUserService.dart';
import 'package:booksshare/Shared/appTheme.dart';
import 'package:booksshare/Widgets/Panel/userPanel.dart';
import 'package:booksshare/Widgets/userInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Models/bookModel.dart';
import '../../Services/authService.dart';
import '../../Services/bookService.dart';
import '../Library/bookDetailsScreen.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchQuery = '';
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  UserPanel userPanel = UserPanel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: AppTheme.secondBackgroundColor,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.iconColor,
          indicatorWeight: 3,
          labelColor: AppTheme.textColor,
          tabs: const [
            Tab(text: 'Your friends'),
            Tab(text: 'Books'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [existFriends(context), searchFriends(context)],
      ),
      drawer: userPanel,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget existFriends(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Center(
          child: Text('You dont have any friends yet! HAHAHAHHA'),
        )
      ],
    );
  }

  Widget searchFriends(BuildContext context) {
    AuthService _auth = AuthService();
    var uid = _auth.getUserID();
    DatabaseUserService userService = DatabaseUserService(uid: uid);
    CollectionReference userColection =
        FirebaseFirestore.instance.collection("users");
    var bookList = BookService(uid!);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: TextField(
                decoration: const InputDecoration(
                    fillColor: AppTheme.secondBackgroundColor,
                    hoverColor: AppTheme.secondBackgroundColor,
                    focusColor: AppTheme.secondBackgroundColor,
                    hintText: '   Search .....',
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white, width: 2.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white, width: 1.0)),
                    suffixIcon: Icon(Icons.search,
                        color: AppTheme.secondBackgroundColor),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    )),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
          ),
          searchQuery.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Center(
                      child: Text("Введіть імя користувача!"),
                    ),
                  ],
                )
              : StreamBuilder<List<UserModel>>(
                  stream: userService.readAllUsers(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<UserModel>> snapshot) {
                    if (snapshot.hasError) {
                      return Text("{$snapshot.error}");
                    }

                    if (snapshot.hasData) {
                      final users = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return FutureBuilder<DocumentSnapshot>(
                            future: userColection.doc(user.uid).get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.done) {
                                final userName =
                                    user.userNickName!.toLowerCase();
                                final query = searchQuery.toLowerCase();
                                final containsQuery = userName.contains(query);
                                if (searchQuery.length >= 3 && containsQuery) {
                                  return Container(
                                    child: ListTile(
                                      horizontalTitleGap: 20,
                                      isThreeLine: true,
                                      title: const Text("Користувач"),
                                      subtitle: Text(user.userNickName!),
                                      leading: SizedBox(
                                        height: 300,
                                        width: 50,
                                        child: Image.network(user.userImage!,
                                            width: 200,
                                            height: 300,
                                            fit: BoxFit.cover),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserProfile(
                                                        userID: user.uid)));
                                      },
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          );
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  })
        ],
      ),
    );
  }
}

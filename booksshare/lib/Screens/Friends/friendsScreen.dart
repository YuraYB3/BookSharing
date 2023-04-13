// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Models/friendshipModel.dart';
import '../../Models/userModel.dart';
import '../../Services/authService.dart';
import '../../Services/databaseUserService.dart';
import '../../Services/friendshipService.dart';
import '../../Shared/appTheme.dart';
import '../../Widgets/Panel/userPanel.dart';
import '../../Widgets/userInfo.dart';
import '../Message/messangerScreen.dart';
import '../Profile/userProfile.dart';

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
            Tab(text: 'Global'),
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
    AuthService auth = AuthService();
    var uid = auth.getUserID();
    var userList = UserInformation();
    FriendshipService friendshipService = FriendshipService();
    return FutureBuilder<List<FriendshipModel>>(
      future: friendshipService.getUserFriends(uid!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Сталася помилка: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                child: Text('Зараз тут пусто...'),
              )
            ],
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final friends = snapshot.data!;
        return ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            final friendID =
                friend.firstUser == uid ? friend.secondUser : friend.firstUser;
            return Padding(
                padding: const EdgeInsets.all(1.0),
                child: ListTile(
                  horizontalTitleGap: 20,
                  isThreeLine: true,
                  title: const Text("Користувач"),
                  subtitle: userList.userNameBlack(
                    friendID,
                  ),
                  leading: SizedBox(
                      height: 300,
                      width: 50,
                      child: userList.userImage(friendID)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MessangerScreen(
                                  userID: friendID,
                                  friendshipID: friend.friendshipID,
                                )));
                  },
                ));
          },
        );
      },
    );
  }

  Widget searchFriends(BuildContext context) {
    AuthService auth = AuthService();
    var uid = auth.getUserID();
    DatabaseUserService userService = DatabaseUserService(uid: uid);
    CollectionReference userColection =
        FirebaseFirestore.instance.collection("users");

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
                                  return ListTile(
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
                                              builder: (context) => UserProfile(
                                                  userID: user.uid)));
                                    },
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

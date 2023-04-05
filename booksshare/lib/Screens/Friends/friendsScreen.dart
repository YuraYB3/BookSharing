import 'package:booksshare/Shared/appTheme.dart';
import 'package:booksshare/Widgets/Panel/userPanel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
          child: Text('You dont have friends yet! HAHAHAHHA'),
        )
      ],
    );
  }

  Widget searchFriends(BuildContext context) {
    return Column(
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
                      borderSide: BorderSide(color: Colors.white, width: 2.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0)),
                  suffixIcon:
                      Icon(Icons.search, color: AppTheme.secondBackgroundColor),
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
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text(searchQuery)),
                ],
              ),
      ],
    );
  }
}

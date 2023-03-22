// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/userModel.dart';
import '../../Services/DatabaseUser.dart';
import '../AppBar/UserAppBar.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Widget build(BuildContext context) {
    UserAppBar userBar = UserAppBar();
    return StreamProvider<List<UserModel>?>.value(
        value: DatabaseUserService(uid: '').users,
        initialData: null,
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 60,
              backgroundColor: const Color(0xff008787),
              title: const Text(''),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Tab 1'),
                  Tab(text: 'Tab 2'),
                ],
              ),
            ),
            backgroundColor: Colors.white,
            body: TabBarView(
              controller: _tabController,
              children: const [
                Center(
                  child: Text('This is Tab 1'),
                ),
                Center(
                  child: Text('This is Tab 2'),
                ),
              ],
            )));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

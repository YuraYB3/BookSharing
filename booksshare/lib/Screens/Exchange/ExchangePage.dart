// ignore_for_file: file_names
import 'package:booksshare/Services/Auth.dart';
import 'package:booksshare/Services/BookSwap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/BookSwapModel.dart';
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
    BookSwap bookSwap = BookSwap();
    AuthService authService = AuthService();
    var id = authService.getUserID();
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
                indicatorColor: Colors.amber,
                indicatorWeight: 5,
                labelColor: Colors.white,
                tabs: const [
                  Tab(text: 'Received'),
                  Tab(text: 'Sent'),
                ],
              ),
            ),
            backgroundColor: Colors.white,
            body: TabBarView(
              controller: _tabController,
              children: [
                ExchangeScreen('senderID', () {}, 'sender'),
                ExchangeScreen('receiverID', () {}, 'receiver')
              ],
            )));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  StreamBuilder<List<BookSwapModel>> ExchangeScreen(
      String user, Function action, String exchangeType) {
    BookSwap bookSwap = BookSwap();
    AuthService authService = AuthService();
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection("users");
    CollectionReference bookCollection =
        FirebaseFirestore.instance.collection("books");
    var id = authService.getUserID();
    return StreamBuilder<List<BookSwapModel>>(
        stream: bookSwap.getBookSwap(user, id!),
        builder: (BuildContext context,
            AsyncSnapshot<List<BookSwapModel>> snapshot) {
          if (snapshot.hasError) {
            return const Text("ERROR!!!");
          }
          if (snapshot.hasData) {
            final swap = snapshot.data!;
            return ListView.builder(
                itemCount: swap.length,
                itemBuilder: (context, index) {
                  final bookswap = swap[index];
                  return FutureBuilder<DocumentSnapshot>(
                      future: userCollection
                          .doc(exchangeType == 'sender'
                              ? bookswap.receiverID
                              : bookswap.senderID)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.done) {
                          Map<String, dynamic> userdata =
                              userSnapshot.data!.data() as Map<String, dynamic>;

                          return FutureBuilder<DocumentSnapshot>(
                              future: bookCollection
                                  .doc(bookswap.desiredBookID)
                                  .get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot>
                                      bookSnapshot) {
                                if (bookSnapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> bookdata =
                                      bookSnapshot.data!.data()
                                          as Map<String, dynamic>;
                                  return Card(
                                    borderOnForeground: true,
                                    elevation: 5.5,
                                    shadowColor: const Color(0xff008787),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            height: 100,
                                            width: 90,
                                            child: Image(
                                                image:
                                                    CachedNetworkImageProvider(
                                                  bookdata['cover'],
                                                ),
                                                fit: BoxFit.cover)),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 50),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Назва книги:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Container(
                                                    width: 1,
                                                  ),
                                                  Text(
                                                    '${bookdata['name']}',
                                                    style: const TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    exchangeType == 'sender'
                                                        ? "Власник книги:"
                                                        : "Орендар:",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Container(
                                                    width: 1,
                                                  ),
                                                  Text(
                                                      '${userdata['name']}  ${userdata['surname']}',
                                                      style: const TextStyle(
                                                          color: Colors.grey)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                                return Container();
                              });
                        }
                        return Container();
                      });
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

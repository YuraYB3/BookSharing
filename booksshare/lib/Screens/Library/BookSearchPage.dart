import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookSearchScreen extends StatefulWidget {
  @override
  _BookSearchScreenState createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  String _getText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by title',
          ),
          onChanged: (value) {
            _searchText = value;
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('books')
            .orderBy('title')
            .startAt([_searchText.toLowerCase()]).endAt(
                [_searchText.toLowerCase() + '\uf8ff']).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final docs = snapshot.data?.docs;
          if (docs!.isEmpty) {
            return Center(
              child: Text('No books found'),
            );
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (BuildContext context, int index) {
              final doc = docs[index];
              return ListTile(
                title: Text(doc['title']),
                subtitle: Text(doc['name']),
              );
            },
          );
        },
      ),
    );
  }
}

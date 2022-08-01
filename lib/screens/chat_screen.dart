import '../chats/messages.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatty'),
        actions: [
          DropdownButton(
            items: [
              DropdownMenuItem(
                // ignore: avoid_unnecessary_containers
                value: 'logout',
                // ignore: avoid_unnecessary_containers
                child: Container(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
              ),
            ],
            onChanged: (identifier) {
              if (identifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
          ),
        ],
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Column(
          children: const [
            Expanded(
              child: Messages(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/2b6EW2uEmah0L00mgRDj/messages')
              .add({
            'text': 'We do beilieve it\'d turn out well.',
          });
        },
      ),
    );
  }
}

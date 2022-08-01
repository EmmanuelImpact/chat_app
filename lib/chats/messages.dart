import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chat').snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final chatDocs = chatSnapshot.data!.docs;
        return ListView.builder(
          itemBuilder: (ctx, index) {
            return Text(chatDocs[index]['text']);
          },
          itemCount: chatDocs.length,
        );
      },
    );
  }
}

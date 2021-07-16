import 'package:chat/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());

        final chatDocs = chatSnapshot.data?.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs?.length,
          itemBuilder: (context, i) => MessageBubble(
            key: ValueKey(chatDocs![i].id),
            message: chatDocs[i].get('text'),
            userImage: chatDocs[i].get('userImage'),
            userName: chatDocs[i].get('userName'),
            belongsToMe: FirebaseAuth.instance.currentUser?.uid ==
                chatDocs[i].get('userId'),
          ),
        );
      },
    );
  }
}

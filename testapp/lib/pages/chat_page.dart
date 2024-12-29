import 'package:flutter/material.dart';
import 'package:testapp/models/user_profile.dart';

class ChatPage extends StatefulWidget {
  final UserProfile chatUser;

  const ChatPage({super.key, required this.chatUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
        title: Text(widget.chatUser.name ?? "Unknown User"),

      ),
   
    );
  }
}

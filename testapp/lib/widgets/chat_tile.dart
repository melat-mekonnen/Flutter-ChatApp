import 'package:flutter/material.dart';
import 'package:testapp/models/user_profile.dart';

class ChatTile extends StatelessWidget {
  final UserProfile userProfile;
  final Function onTap;

  const ChatTile({super.key, required this.userProfile , required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: false,
      leading: CircleAvatar(),
      title: Text(userProfile.name!),
      onTap: (){onTap();},

    );
  }
}

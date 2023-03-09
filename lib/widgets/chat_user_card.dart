import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_stack/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    log('Image url: ${widget.user.image}');
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
      color: const Color.fromARGB(255, 202, 251, 255),
      child: InkWell(
        onTap: () {},
        child: ListTile(
            //const CircleAvatar(
            //   backgroundColor: Color.fromARGB(255, 0, 167, 170),
            //   foregroundColor: Color.fromARGB(255, 255, 255, 255),
            //   child: Icon(CupertinoIcons.person),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .01),
              child: CachedNetworkImage(
                width: mq.height * .055,
                height: mq.height * .055,
                imageUrl: widget.user.image,
                // placeholder: (context, url) =>
                //     const CircleAvatar(child: Icon(CupertinoIcons.person)),
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
              ),
            ),
            title: Text(widget.user.name),
            subtitle: Text(
              widget.user.about,
              maxLines: 1,
            ),
            trailing: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 5, 125, 35),
                    borderRadius: BorderRadius.circular(10)))),
      ),
    );
  }
}

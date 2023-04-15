// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../Shared/appTheme.dart';

class MessageBubble extends StatefulWidget {
  final String message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color:
                  widget.isMe ? AppTheme.secondBackgroundColor : Colors.amber,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft:
                      !widget.isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomRight:
                      widget.isMe ? Radius.circular(0) : Radius.circular(12))),
          width: 180,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            widget.message,
            style: TextStyle(color: widget.isMe ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }
}

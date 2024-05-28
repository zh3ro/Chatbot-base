import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    required this.text,
    required this.isFromuser,
    super.key,
    });
  
  final String text;
  final bool isFromuser;


  @override
  
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isFromuser ? MainAxisAlignment.end:MainAxisAlignment.start,
      children: [
        Flexible(
          child: 
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            margin: const EdgeInsets.only(bottom: 8),
            constraints: const BoxConstraints(maxWidth: 520),
            decoration: BoxDecoration(
              color: isFromuser
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                MarkdownBody(data: text),
              ],
            ),
          ),)
      ],
    );
  }
}
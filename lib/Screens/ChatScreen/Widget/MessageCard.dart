import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class MessageCard extends StatelessWidget {
  bool isSented;
  bool isRead;
  String messageTime;
  String message;
  MessageCard({
    super.key,
    required this.isSented,
    required this.isRead,
    required this.messageTime,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          (isSented) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          constraints: BoxConstraints(
            maxWidth: 300,
            minWidth: 80,
            minHeight: 30,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: isSented ? Radius.circular(10) : Radius.circular(0),
              bottomRight: !isSented ? Radius.circular(10) : Radius.circular(0),
            ),
            color:
                (isSented)
                    ? AppTheme.primaryColor.withOpacity(.1)
                    : Colors.black26.withOpacity(.05),
          ),
          child: Text(message, style: TextStyle(fontSize: 14)),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment:
              (isSented) ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(
              DateFormat(
                "dd-MM-yy | hh:mm a",
              ).format(DateTime.parse(messageTime)),
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(width: 5),
            if (isSented)
              FaIcon(
                FontAwesomeIcons.check,
                color: (isRead) ? Colors.blue : Colors.black45,
                size: 10,
              ),

            if (isSented && isRead)
              FaIcon(
                FontAwesomeIcons.check,
                color: (isRead) ? Colors.blue : Colors.black45,
                size: 10,
              ),
          ],
        ),
      ],
    );
  }
}

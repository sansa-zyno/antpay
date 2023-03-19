import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/screens/chat/messages_screen.dart';
import 'package:flutter/material.dart';

class ChatBodyWidget extends StatelessWidget {
  const ChatBodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(image: AssetImage(stickers)),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [gd1, gd2, gd3, gd4, gd5],
                  stops: [0.02, 0.2, 0.6, 0.8, 1.0]),
            ),
            child: Messages(
              username: "",
            )),
      );
}

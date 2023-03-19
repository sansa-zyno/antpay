import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/helpers/common.dart';
import 'package:ant_pay/screens/contact_list.dart';
import 'package:ant_pay/widgets/chat_body_widget.dart';
import 'package:ant_pay/widgets/chat_header_widget.dart';
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatsPage extends StatelessWidget {
  List<Map> users = [
    {"name": "Johnson Thompson okemuteeee", "avatar": male},
    {"name": "Bob Thompson", "avatar": female},
    {"name": "Johnson Marley", "avatar": male},
    {"name": "Monday Thompson", "avatar": female},
    {"name": "Marley Thompson", "avatar": male},
    {"name": "Johnson Marley", "avatar": female},
    {"name": "Monday Thompson", "avatar": male},
    {"name": "Marley Thompson", "avatar": female}
  ];
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          backgroundColor: appColor,
          body: Stack(
            children: [
              Positioned(
                  top: 0, left: 15, child: Image.asset(heart_red_2, width: 70)),
              Column(
                children: [ChatHeaderWidget(users: users), ChatBodyWidget()],
              ),
            ],
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                  heroTag: "hero1",
                  backgroundColor: Colors.white,
                  child: Icon(
                    FontAwesomeIcons.edit,
                    color: appColor,
                  ),
                  onPressed: () {}),
              SizedBox(height: 15),
              FloatingActionButton(
                  heroTag: "hero2",
                  backgroundColor: Colors.white,
                  child: Icon(
                    FontAwesomeIcons.camera,
                    color: appColor,
                  ),
                  onPressed: () {}),
              SizedBox(height: 15),
              FloatingActionButton(
                  heroTag: "hero3",
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.chat,
                    color: appColor,
                  ),
                  onPressed: () {
                    changeScreen(context, ContactList());
                  })
            ],
          ),
        ),
      );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      );
}

import 'dart:convert';
import 'dart:developer';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/helpers/common.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/screens/notifications.dart';
import 'package:ant_pay/screens/profile.dart';
import 'package:ant_pay/services/http.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatHeaderWidget extends StatefulWidget {
  //final List<User> users;
  final List<Map> users;

  const ChatHeaderWidget({
    required this.users,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatHeaderWidget> createState() => _ChatHeaderWidgetState();
}

class _ChatHeaderWidgetState extends State<ChatHeaderWidget> {
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserController userController = Provider.of<UserController>(context);
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      alignment: Alignment.bottomRight,
                    ),
                    IconButton(
                      onPressed: () {
                        changeScreen(context, Notifications());
                      },
                      icon: Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                      alignment: Alignment.bottomLeft,
                    ),
                  ],
                ),
                Text(
                  'Chats',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                InkWell(
                  onTap: () {
                    changeScreen(context, UserProfile());
                  },
                  child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: userController.getCurrentUser.avatarUrl != null
                          ? Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Color(0xff6E01CE), width: 3),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(userController
                                          .getCurrentUser.avatarUrl!),
                                      fit: BoxFit.cover)),
                            )
                          : Center(child: CircularProgressIndicator())),
                )
              ],
            ),
          ),
          SizedBox(height: 12),
          /* Container(
              height: 75,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 8),
                itemCount: widget.users.length,
                itemBuilder: (context, index) {
                  final user = widget.users[index];

                  return Container(
                    margin: EdgeInsets.only(right: 10),
                    child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.white, width: 3),
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Color(0xff6E01CE), width: 3),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage(user["avatar"]),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: 70,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      user["name"],
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  );
                },
              ),
            ),*/
          /*SizedBox(
              height: 15,
            )*/
        ],
      ),
    );
  }
}

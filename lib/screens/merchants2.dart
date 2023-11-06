import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/constants/app_strings.dart';
import 'package:ant_pay/helpers/common.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/screens/chat/chat_screen.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Merchants2 extends StatefulWidget {
  final String category;
  Merchants2({required this.category});

  @override
  State<Merchants2> createState() => _Merchants2State();
}

class _Merchants2State extends State<Merchants2> {
  Future<QuerySnapshot> getmerchants() async {
    QuerySnapshot merchants = await FirebaseFirestore.instance
        .collection("merchants")
        .where("category", isEqualTo: widget.category)
        .get();
    return merchants;
  }

  @override
  Widget build(BuildContext context) {
    UserController userController = Provider.of<UserController>(context);
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: appColor,
      body: Stack(
        children: [
          Positioned(
              top: 0, left: 15, child: Image.asset(heart_red_2, width: 70)),
          Column(
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: titleBarOffset,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: gd2,
                            size: 20,
                          ),
                        ),
                        Spacer(),
                        CustomText(
                          text: widget.category,
                          color: Colors.white,
                          size: 16,
                        ),
                        Spacer(),
                        SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
              Expanded(
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
                          colors: [appColor, gd2, gd3, gd4, gd5],
                          stops: [0.02, 0.2, 0.6, 0.8, 1.0]),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: Offset(2, 2))
                              ]),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  //controller: controller,
                                  //keyboardType: type ?? TextInputType.text,
                                  //obscureText: obsecureText ?? false,
                                  decoration: new InputDecoration(
                                      prefix: Text("   "),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: appColor,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      alignLabelWithHint: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                      hintText: 'Search ${widget.category}',
                                      labelStyle: TextStyle(
                                        fontFamily: "Nunito",
                                      ),
                                      hintStyle: TextStyle(
                                          fontFamily: "Nunito",
                                          fontSize: 14,
                                          color: appColor)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: FutureBuilder<QuerySnapshot>(
                              future: getmerchants(),
                              builder: (context, snapshot) {
                                return snapshot.hasData
                                    ? ListView.builder(
                                        itemCount: snapshot.data!.docs.length,
                                        padding: EdgeInsets.all(0),
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                              onTap: () async {
                                                User me = User(
                                                    uid: userController
                                                        .getCurrentUser.uid!,
                                                    name: userController
                                                        .getCurrentUser
                                                        .displayName!,
                                                    avatar: userController
                                                        .getCurrentUser
                                                        .avatarUrl);
                                                User merchant = User(
                                                    uid: snapshot.data!
                                                        .docs[index]["uid"],
                                                    name: snapshot
                                                            .data!.docs[index]
                                                        ["displayName"],
                                                    avatar: snapshot
                                                            .data!.docs[index]
                                                        ["avatarUrl"]);
                                                appProvider.getChatData(
                                                    merchant.uid,
                                                    ConversationType.user,
                                                    true);
                                                changeScreen(
                                                    context,
                                                    ChatScreen(
                                                        me: me,
                                                        type: ConversationType
                                                            .user,
                                                        conversationWith:
                                                            merchant,
                                                        conversationId: ""));
                                              },
                                              leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: Image.network(
                                                  snapshot.data!.docs[index]
                                                      ["avatarUrl"],
                                                  height: 40,
                                                ),
                                              ),
                                              title: CustomText(
                                                text: snapshot.data!.docs[index]
                                                    ["displayName"],
                                                size: 16,
                                                weight: FontWeight.bold,
                                                color: appColor,
                                              ),
                                              trailing: Icon(
                                                Icons.arrow_forward_ios,
                                                color: appColor,
                                                size: 20,
                                              ));
                                        })
                                    : Center(
                                        child: CircularProgressIndicator());
                              }),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}

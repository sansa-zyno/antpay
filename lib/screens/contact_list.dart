import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/helpers/common.dart';
import 'package:ant_pay/providers/app_provider.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/screens/chat/chat_screen.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    UserController userController = Provider.of<UserController>(context);
    return SafeArea(
      child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(stickers)),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [gd1, gd2, gd3, gd4, gd5],
                stops: [0.02, 0.2, 0.6, 0.8, 1.0]),
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              await appProvider.getContacts();
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(heart_red, width: 50),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      sun,
                      width: 100,
                    ),
                  ),
                  Positioned(
                      top: 90,
                      right: 0,
                      child: Image.asset(
                        dollar,
                        width: 50,
                      )),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      child: Image.asset(
                        car,
                        width: 70,
                      )),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset(
                        money_and_gold,
                        width: 70,
                      )),
                  Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 65,
                          margin: EdgeInsets.only(right: 25),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Color(0xff6E01CE),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all()),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                size: 15,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              CustomText(
                                text: "Add",
                                color: Colors.white,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 311,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
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
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    alignLabelWithHint: false,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    hintText: 'Search Contacts',
                                    labelStyle: TextStyle(
                                      fontFamily: "Nunito",
                                    ),
                                    hintStyle: TextStyle(fontFamily: "Nunito")),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      appProvider.contacts != null
                          ? Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: appProvider.contacts!.length,
                                  itemBuilder: (ctx, index) {
                                    return ListTile(
                                      onTap: () {
                                        User me = User(
                                            uid: userController
                                                .getCurrentUser.uid!,
                                            name: userController
                                                .getCurrentUser.displayName!,
                                            avatar: userController
                                                .getCurrentUser.avatarUrl);
                                        User recipient = User(
                                            uid: appProvider.contacts![index]
                                                ["doc"]["uid"],
                                            name: appProvider.contacts![index]
                                                ["name"],
                                            avatar: appProvider.contacts![index]
                                                ["doc"]["avatarUrl"]);
                                        appProvider.getChatData(recipient.uid,
                                            ConversationType.user, true);
                                        changeScreen(
                                            context,
                                            ChatScreen(
                                                me: me,
                                                type: ConversationType.user,
                                                conversationWith: recipient,
                                                conversationId: ""));
                                      },
                                      leading: Container(
                                        width: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xff6E01CE),
                                                width: 3),
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    appProvider.contacts![index]
                                                        ["doc"]["avatarUrl"]),
                                                fit: BoxFit.cover)),
                                      ),
                                      title: CustomText(
                                          text: appProvider.contacts![index]
                                              ["name"]),
                                      subtitle: CustomText(
                                        text: appProvider.contacts![index]
                                            ["doc"]["status"],
                                        color: Colors.black45,
                                      ),
                                      trailing: Container(
                                        margin: EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xff6E01CE),
                                                width: 1.5),
                                            shape: BoxShape.circle),
                                        width: 15,
                                      ),
                                    );
                                  }),
                            )
                          : CircularProgressIndicator()
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}

import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/constants/app_strings.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/utils/call_utilities.dart';
import 'package:ant_pay/utils/permissions.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late UserController userController;
  Stream<QuerySnapshot>? callhistory;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userController = Provider.of<UserController>(context, listen: false);
    callhistory = FirebaseFirestore.instance
        .collection("callhistorys")
        .doc(userController.getCurrentUser.uid!.toLowerCase())
        .collection("callhistory")
        .snapshots();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    callhistory = null;
  }

  @override
  Widget build(BuildContext context) {
    userController = Provider.of<UserController>(context);
    return Scaffold(
      backgroundColor: appColor,
      body: Stack(
        children: [
          Positioned(
              top: 0, left: 15, child: Image.asset(heart_red_2, width: 70)),
          Column(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: titleBarOffset,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        /*Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),*/
                        Spacer(),
                        CustomText(
                          text: "Call",
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
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(color: Colors.grey))),
                            child: CustomText(
                              text: "Outgoing",
                              color: Colors.grey,
                              size: 14,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(color: Colors.grey))),
                            child: CustomText(
                              text: "Incoming",
                              color: Colors.grey,
                              size: 14,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(),
                            child: CustomText(
                              text: "Missed",
                              color: Colors.grey,
                              size: 14,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                                color: Color(0xffADFFE1),
                                borderRadius: BorderRadius.circular(15)),
                            child: CustomText(
                              text: "View all",
                              color: Colors.black,
                              size: 14,
                            ),
                          )
                        ],
                      ),
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
                      //image: DecorationImage(image: AssetImage(stickers)),
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
                    child: StreamBuilder<QuerySnapshot>(
                        stream: callhistory,
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? snapshot.data!.docs.isNotEmpty
                                  ? ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        User me = User(
                                            uid: userController
                                                .getCurrentUser.uid!
                                                .toLowerCase(),
                                            name: userController
                                                .getCurrentUser.displayName!,
                                            avatar: userController
                                                .getCurrentUser.avatarUrl);
                                        User recipient = snapshot.data!.docs[index]
                                                ["has_dialled"]
                                            ? User(
                                                uid: snapshot.data!
                                                    .docs[index]["receiver_id"]
                                                    .toString()
                                                    .toLowerCase(),
                                                name: snapshot.data!.docs[index]
                                                    ["receiver_name"],
                                                avatar: snapshot.data!.docs[index]
                                                    ["receiver_pic"])
                                            : User(
                                                uid: snapshot.data!.docs[index]["caller_id"]
                                                    .toString()
                                                    .toLowerCase(),
                                                name: snapshot.data!.docs[index]
                                                    ["caller_name"],
                                                avatar: snapshot.data!.docs[index]
                                                    ["caller_pic"]);
                                        return ListTile(
                                          onTap: () async {
                                            await Permissions
                                                    .cameraAndMicrophonePermissionsGranted()
                                                ? CallUtils.dialAudio(
                                                    from: me,
                                                    to: recipient,
                                                    context: context)
                                                : {};
                                          },
                                          leading: Container(
                                            width: 50,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xff6E01CE),
                                                    width: 3),
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: snapshot.data!
                                                                .docs[index]
                                                            ["has_dialled"]
                                                        ? NetworkImage(snapshot
                                                                .data!
                                                                .docs[index]
                                                            ["receiver_pic"])
                                                        : NetworkImage(snapshot
                                                                .data!
                                                                .docs[index]
                                                            ["caller_pic"]),
                                                    fit: BoxFit.cover)),
                                          ),
                                          title: snapshot.data!.docs[index]
                                                  ["has_dialled"]
                                              ? CustomText(
                                                  text:
                                                      "${snapshot.data!.docs[index]["receiver_name"]}")
                                              : CustomText(
                                                  text:
                                                      "${snapshot.data!.docs[index]["caller_name"]}"),
                                          subtitle: Row(
                                            children: [
                                              Icon(
                                                Icons.call,
                                                size: 15,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              CustomText(
                                                text: snapshot.data!.docs[index]
                                                            ["status"] ==
                                                        "0"
                                                    ? "Outgoing"
                                                    : "incoming",
                                                size: 14,
                                              )
                                            ],
                                          ),
                                          trailing: Builder(builder: (context) {
                                            DateTime dateTime = snapshot
                                                .data!.docs[index]["date"]
                                                .toDate();
                                            return Text(
                                                "${dateTime.day}/${dateTime.month}/${dateTime.year}");
                                          }),
                                        );
                                      })
                                  : Center(
                                      child: Text("No call history to show"))
                              : Center(child: CircularProgressIndicator());
                        })),
              )
            ],
          ),
        ],
      ),
    );
  }
}

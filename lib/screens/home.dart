import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/models/call.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/screens/callscreens/call_screen.dart';
import 'package:ant_pay/screens/callscreens/pickup/video_pickup_screen.dart';
import 'package:ant_pay/screens/callscreens/pickup/voice_pickup_screen.dart';
import 'package:ant_pay/screens/chat/chats_page.dart';
import 'package:ant_pay/services/call_history.dart';
import 'package:ant_pay/services/call_methods.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:boxicons/boxicons.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int pageIndex;
  late Widget _showPage;
  late CallScreen _call;
  late ChatsPage _chatsPage;

  //navbar
  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _call;
      case 1:
        return _chatsPage;

      default:
        return new Container(
            child: new Center(
          child: new Text(
            'No Page found by page thrower',
            style: new TextStyle(fontSize: 30),
          ),
        ));
    }
  }

  /* bg() async {
    await Future.delayed(Duration(seconds: 30), () async {
      await AppbackgroundService().startBg();
    });
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageIndex = 1;
    _call = CallScreen();
    _chatsPage = ChatsPage();
    _showPage = _pageChooser(pageIndex);
    UserController controller =
        Provider.of<UserController>(context, listen: false);
    if (controller.getCurrentUser.uid != null) {
      CallMethods()
          .callStream(uid: controller.getCurrentUser.uid!)
          .listen((snapshot) {
        if (snapshot.data() != null) {
          Call call = Call.fromMap(snapshot.data() as Map<String, dynamic>);
          if (!call.hasDialled!) {
            if (snapshot["fkey"] != "") {
              CallHistory().updateCall(call: call, fkey: snapshot["fkey"]);
            }
            if (call.type == "video") {
              Get.to(VideoPickupScreen(call: call));
            } else {
              Get.to(VoicePickupScreen(call: call));
            }
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _showPage,
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.call), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.solidComment,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.photo_camera), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.house), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.wallet), label: ""),
            ],
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: pageIndex,
            selectedItemColor: appColor,
            unselectedItemColor: gd1,
            onTap: (int tappedIndex) {
              setState(() {
                pageIndex = tappedIndex;
                _showPage = _pageChooser(pageIndex);
              });
            }),
      ),
    );
  }
}

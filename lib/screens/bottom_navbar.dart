import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/models/call.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/screens/call/call_screen.dart';
import 'package:ant_pay/screens/call/pickup/video_pickup_screen.dart';
import 'package:ant_pay/screens/call/pickup/voice_pickup_screen.dart';
import 'package:ant_pay/screens/chat/chats_page.dart';
import 'package:ant_pay/screens/merchant/merchant_categories.dart';
import 'package:ant_pay/screens/wallet/wallet.dart';
import 'package:ant_pay/services/call_history.dart';
import 'package:ant_pay/services/call_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BottomNavbar extends StatefulWidget {
  BottomNavbar({Key? key}) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  late int pageIndex;
  late Widget _showPage;
  late CallScreen _call;
  late ChatsPage _chatsPage;
  late MerchantCategories _merchantCategories;
  late Wallet _wallet;

  //navbar
  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _call;
      case 1:
        return _chatsPage;
      case 2:
        return _merchantCategories;
      case 3:
        return _wallet;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageIndex = 1;
    _call = CallScreen();
    _chatsPage = ChatsPage();
    _merchantCategories = MerchantCategories();
    _wallet = Wallet();
    _showPage = _pageChooser(pageIndex);
    UserController controller = Provider.of<UserController>(context, listen: false);
    if (controller.getCurrentUser.uid != null) {
      CallMethods().callStream(uid: controller.getCurrentUser.uid!).listen((snapshot) {
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
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(systemNavigationBarColor: gd3.withOpacity(0.9)),
      child: Scaffold(
        body: _showPage,
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: gd3.withOpacity(0.9),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.call), label: "Call"),
              BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.solidComment), label: "Chat"),
              /* BottomNavigationBarItem(icon: Icon(Icons.photo_camera), label: ""),*/
              BottomNavigationBarItem(icon: Icon(Icons.house), label: "Merchant"),
              BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Wallet"),
            ],
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: pageIndex,
            selectedItemColor: appColor,
            unselectedItemColor: appColor.withOpacity(0.5),
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

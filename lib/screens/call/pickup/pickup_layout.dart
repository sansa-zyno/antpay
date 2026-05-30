/*import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/services/call_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ant_pay/screens/callscreens/pickup/voice_pickup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ant_pay/models/call.dart';
import 'package:ant_pay/services/call_methods.dart';
import 'package:ant_pay/screens/callscreens/pickup/video_pickup_screen.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  PickupLayout({
    required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {
    //final UserProvider userProvider = Provider.of<UserProvider>(context);
    final UserController userController = Provider.of<UserController>(context);

    return (userController.getCurrentUser.uid != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream:
                callMethods.callStream(uid: userController.getCurrentUser.uid!),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                if (snapshot.data!.data() != null) {
                  Call call = Call.fromMap(
                      snapshot.data!.data() as Map<dynamic, dynamic>);
                  if (!call.hasDialled!) {
                    if (snapshot.data!["fkey"] != "") {
                      CallHistory()
                          .updateCall(call: call, fkey: snapshot.data!["fkey"]);
                    }
                    if (call.type == "video") {
                      return VideoPickupScreen(call: call);
                    } else {
                      return VoicePickupScreen(call: call);
                    }
                  }
                }
              }
              return scaffold;
            },
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}*/

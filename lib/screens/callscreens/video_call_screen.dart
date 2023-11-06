import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:ant_pay/constants/app_colors.dart';
import 'package:ant_pay/constants/app_images.dart';
import 'package:ant_pay/constants/app_strings.dart';
import 'package:ant_pay/providers/user_controller.dart';
import 'package:ant_pay/services/call_methods.dart';
import 'package:ant_pay/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:ant_pay/models/call.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
//import 'package:stop_watch_timer/stop_watch_timer.dart';

class VideoCallScreen extends StatefulWidget {
  final Call call;

  VideoCallScreen({
    required this.call,
  });

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final CallMethods callMethods = CallMethods();

  late UserController userController;
  StreamSubscription? callStreamSubscription;

  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  late RtcEngine _engine;
  int? _remoteUid;
  bool _localUserJoined = false;

  @override
  void initState() {
    super.initState();
    listen();
    initializeAgora();
  }

  Future<void> initializeAgora() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    print("In call screen token${widget.call.token}");
    print("In call screen token${widget.call.channelId}");

    await _initAgoraRtcEngine();
    //_addAgoraEventHandlers();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        userJoined: (int uid, int elapsed) {
          print("remote user $uid joined");
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
    //await _engine.enableWebSdkInteroperability(true);
    /*await _engine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');*/
    await _engine.joinChannel(
        widget.call.token, widget.call.channelId!, null, 0);
  }

  listen() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      userController = Provider.of<UserController>(context, listen: false);

      callStreamSubscription = callMethods
          .callStream(uid: userController.getCurrentUser.uid!.toLowerCase())
          .listen((DocumentSnapshot ds) {
        // defining the logic
        switch (ds.data()) {
          case null:
            // snapshot is null which means that call is hanged and documents are deleted
            Navigator.pop(context);
            break;

          default:
            break;
        }
      });
    });
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
  }

  /// Add agora event handlers
  /*void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        final info = 'onUserJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    };

    AgoraRtcEngine.onUpdatedUserInfo = (AgoraUserInfo userInfo, int i) {
      setState(() {
        final info = 'onUpdatedUserInfo: ${userInfo.toString()}';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onRejoinChannelSuccess = (String string, int a, int b) {
      setState(() {
        final info = 'onRejoinChannelSuccess: $string';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onUserOffline = (int a, int b) {
      callMethods.endCall(call: widget.call);
      setState(() {
        final info = 'onUserOffline: a: ${a.toString()}, b: ${b.toString()}';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onRegisteredLocalUser = (String s, int i) {
      setState(() {
        final info = 'onRegisteredLocalUser: string: s, i: ${i.toString()}';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onConnectionLost = () {
      setState(() {
        final info = 'onConnectionLost';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      // if call was picked

      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
  }*/

  /// Helper function to get list of native views
  /*List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true),

    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }*/

  /// Video view wrapper
  /* Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }*/

  /// Video view row wrapper
  /* Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }*/

  /// Video layout wrapper
  /* Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            height: MediaQuery.of(context).size.height * 1,
            child: Stack(
              children: [
                //full pic user
                Positioned(
                  bottom: 0,
                  child: Container(
                      height: MediaQuery.of(context).size.height * 1,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Column(
                        children: [
                          _videoView(views[0]),
                        ],
                      )),
                ),

                //black container
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 05,
                    // color: Colors.black.withOpacity(0.3),
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                              ),
                              // Adobe XD layer: 'Dr. Ngunyen' (text)
                              Text(
                                widget.call.hasDialled == true
                                    ? widget.call.receiverName!
                                    : widget.call.callerName!,
                                style: TextStyle(
                                  fontFamily: 'Noto Sans',
                                  fontSize: 24,
                                  color: const Color(0xe5ffffff),
                                  fontWeight: FontWeight.w600,
                                  height: 1.3333333333333333,
                                ),
                                textHeightBehavior: TextHeightBehavior(
                                    applyHeightToFirstAscent: false),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.015,
                              ),

                              //second user
                              Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Column(
                                    children: [
                                      _expandedVideoRow([views[1]]),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        // Adobe XD layer: '00:08:17' (text)
                        //end call time
                        /* Container(
                          padding: EdgeInsets.only(bottom: 120),
                          child: Column(
                            children: [
                              Text(
                                '00:08:17',
                                style: TextStyle(
                                  fontFamily: 'Noto Sans',
                                  fontSize: 24,
                                  color: const Color(0xe5ffffff),
                                  height: 1.3333333333333333,
                                ),
                                textHeightBehavior: TextHeightBehavior(
                                    applyHeightToFirstAscent: false),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.026,
                              ),
                            ],
                          ),
                        )*/
                      ],
                    ),
                  ),
                ),
              ],
            ));
      /*Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));*/
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }*/

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: appColor.withOpacity(0.3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic : Icons.mic_off,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(8.0),
            constraints: BoxConstraints(minWidth: 30, minHeight: 30),
          ),
          RawMaterialButton(
            onPressed: () => callMethods.endCall(
              call: widget.call,
            ),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(8.0),
            constraints: BoxConstraints(minWidth: 30, minHeight: 30),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(8.0),
            constraints: BoxConstraints(minWidth: 30, minHeight: 30),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    if (callStreamSubscription != null) {
      callStreamSubscription!.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _remoteUid == null
          ? BoxDecoration(
              image: DecorationImage(
                  image: widget.call.hasDialled!
                      ? NetworkImage(widget.call.receiverPic!)
                      : NetworkImage(widget.call.receiverPic!),
                  fit: BoxFit.cover,
                  opacity: 0.15),
            )
          : null,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // _viewRows(),
            // _panel(),
            Positioned(
                top: 0, left: 15, child: Image.asset(heart_red_2, width: 70)),
            _remoteUid == null
                ? Positioned(
                    top: 230,
                    left: 0,
                    child: Image.asset(
                      cards_on_hand,
                      width: 100,
                    ))
                : Container(),
            _remoteUid == null
                ? Positioned(
                    top: 90,
                    right: 0,
                    child: Image.asset(
                      dollar,
                      width: 50,
                    ))
                : Container(),
            _remoteUid == null
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    child: Image.asset(
                      car,
                      width: 70,
                    ))
                : Container(),
            _remoteUid == null
                ? Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset(
                      money_and_gold,
                      width: 70,
                    ))
                : Container(),
            _remoteUid == null
                ? widget.call.hasDialled!
                    ? widget.call.receiverPic != null
                        ? Positioned(
                            top: 120,
                            left: MediaQuery.of(context).size.width / 2.8,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(70),
                              child: Image.network(
                                widget.call.receiverPic!,
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Positioned(
                            top: 120,
                            left: 90,
                            child: CircleAvatar(
                              radius: 90,
                              child: Icon(
                                Icons.person,
                                size: 90,
                              ),
                              backgroundColor: Color(0xFF166138),
                            ))
                    : Container()
                : Container(),
            Positioned(
              top: _remoteUid == null ? 300 : 50,
              child: _remoteUid == null
                  ? Column(
                      children: [
                        CustomText(
                          text: "Calling ${widget.call.receiverName}",
                          color: Colors.white,
                          size: 16,
                          weight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomText(
                          text: "Ringing ...",
                          color: Colors.white,
                          size: 12,
                        )
                      ],
                    )
                  : Column(
                      children: [
                        CustomText(
                          text: "${widget.call.receiverName}",
                          color: Colors.white,
                          size: 16,
                          weight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomText(
                          text: "02:34",
                          color: Colors.white,
                          size: 12,
                        )
                      ],
                    ),
            ),
            Center(
              child: _remoteVideo(),
            ),
            Positioned(
              //alignment: Alignment.topLeft,
              bottom: 180,
              right: 15,
              child: Container(
                width: 80,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Center(
                    child: _localUserJoined
                        ? RtcLocalView.SurfaceView()
                        : CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
            Positioned(bottom: 50, child: _toolbar()),
          ],
        ),
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(
          uid: _remoteUid!, channelId: widget.call.channelId!);
    } else {
      return Text(
        '',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      );
    }
  }
}

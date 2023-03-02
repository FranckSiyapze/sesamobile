/* import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:felicity/ui/utils/colors.dart';
import 'package:felicity/ui/utils/storage.dart';
import 'package:felicity/ui/utils/themes/custom_app_theme.dart';
import 'package:flutter/material.dart';
//import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:felicity/core/models/call.dart';
import '../../../core/models/log.dart';
import '../../../resources/call_state_methods.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/utils.dart';

class CallScreen extends StatefulWidget {
  final Call call;
  CallScreen({
    required this.call,
  });
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallMethods callMethods = CallMethods();
  late StreamSubscription callStreamSubscription;
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool hasUserJoined = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addPostFrameCallback();
    initializeAgora();
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    callStreamSubscription.cancel();
    super.dispose();
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
    String agoraToken = await readStorage(value: "agoraToken");
    String uidToken = await readStorage(value: "uidToken");
    print("agoraUID $uidToken");
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.joinChannel(
        TOKEN, CHANNEL_NAME, null, 0);
    //print("await AgoraRtcEngine.joinChannel(TOKEN, CHANNEL_NAME, null, 0)");
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
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
        print("infos is : $info");
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        hasUserJoined = true;
        final info = 'onUserJoined: $uid';
        print('onUserJoined: $uid');
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
  }

  addPostFrameCallback() async {
    String uuid = await readStorage(value: "uid");
    callStreamSubscription =
        callMethods.callStream(uid: uuid).listen((DocumentSnapshot ds) {
      if (!ds.exists) {
        Navigator.pop(context);
      }
      /* switch (ds.data) {
        case null:
          // snapshot is null i.e. the call is hanged and document is deleted

          break;

        default:
          break;
      } */
    });
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          child: view,
        ),
      ),
    );
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Container(
        child: Row(
          children: wrappedViews,
        ),
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    print("videos view  " + views.length.toString());
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Stack(
          children: <Widget>[
            Center(
              child: _expandedVideoRow([views[1]]),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 30,
              left: MediaQuery.of(context).size.width / 35,
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.height / 3.9,
                  child: Center(
                    child: _expandedVideoRow([views[0]]),
                  ),
                ),
              ),
            ),
          ],
        ));
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
  }

  Widget bottomWidget() {
    return Center(
      child: Container(
        padding: Spacing.only(
          top: 10,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: CustomAppTheme.darkCustomAppTheme.kBackgroundColor
              .withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(90)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: Spacing.bottom(8),
              //padding: Spacing.all(10),

              child: RawMaterialButton(
                onPressed: _onToggleMute,
                child: Icon(
                  muted ? Icons.mic : Icons.mic_off,
                  color: muted ? Colors.white : Colors.blueAccent,
                  size: 20.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: muted ? Colors.blueAccent : Colors.white,
                padding: const EdgeInsets.all(12.0),
              ),
            ),
            Container(
              margin: Spacing.bottom(8),
              child: RawMaterialButton(
                onPressed: _onSwitchCamera,
                child: Icon(
                  Icons.switch_camera,
                  color: Colors.blueAccent,
                  size: 20.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(12.0),
              ),
            ),
            Container(
              margin: Spacing.bottom(0),
              child: RawMaterialButton(
                onPressed: () {
                  callMethods.endCall(
                    call: widget.call,
                  );

                  if (!hasUserJoined) {
                    Log log = Log(
                        callerName: widget.call.callerName,
                        callerPic: widget.call.callerPic,
                        receiverName: widget.call.receiverName,
                        receiverPic: widget.call.receiverPic,
                        timestamp: DateTime.now().toString(),
                        callStatus: CALL_STATUS_MISSED);

                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(widget.call.receiverId)
                        .collection("callLogs")
                        .doc(log.timestamp)
                        .set({
                      "callerName": log.callerName,
                      "callerPic": log.callerPic,
                      "receiverName": log.receiverName,
                      "receiverPic": log.receiverPic,
                      "timestamp": log.timestamp,
                      "callStatus": log.callStatus
                    });
                  }
                },
                child: Icon(
                  Icons.call_end,
                  color: Colors.white,
                  size: 20.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.redAccent,
                padding: const EdgeInsets.all(12.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
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
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () {
              callMethods.endCall(
                call: widget.call,
              );

              if (!hasUserJoined) {
                Log log = Log(
                    callerName: widget.call.callerName,
                    callerPic: widget.call.callerPic,
                    receiverName: widget.call.receiverName,
                    receiverPic: widget.call.receiverPic,
                    timestamp: DateTime.now().toString(),
                    callStatus: CALL_STATUS_MISSED);

                FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.call.receiverId)
                    .collection("callLogs")
                    .doc(log.timestamp)
                    .set({
                  "callerName": log.callerName,
                  "callerPic": log.callerPic,
                  "receiverName": log.receiverName,
                  "receiverPic": log.receiverPic,
                  "timestamp": log.timestamp,
                  "callStatus": log.callStatus
                });
              }
            },
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
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
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

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
                return Container();
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
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            //_viewRows(),
            // _panel(),
            Positioned(
              bottom: MediaQuery.of(context).size.height / 30,
              left: 0,
              right: MediaQuery.of(context).size.width / 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(),
                  //bottomWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 */
import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';

import '../../../core/models/call.dart';
import '../../../core/models/log.dart';
import '../../../resources/call_state_methods.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/storage.dart';
import '../../utils/themes/custom_app_theme.dart';
import '../../utils/utils.dart';

class CallScreen1 extends StatefulWidget {
  final Call call;
  CallScreen1({
    required this.call,
  });
  @override
  _CallScreen1State createState() => _CallScreen1State();
}

class _CallScreen1State extends State<CallScreen1> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
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
    initAgora();
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    callStreamSubscription.cancel();
    super.dispose();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();
    String agoraToken = await readStorage(value: "agoraToken");
    //create the engine
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
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
    await _engine.enableWebSdkInteroperability(true);
    await _engine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');

    await _engine.joinChannel(agoraToken, "1234", null, 0);
  }

  /* List<Widget> _getRenderViews() {
    final List<RenderView> list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  } */

  addPostFrameCallback() async {
    String uuid = await readStorage(value: "email");
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

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  Widget bottomWidget() {
    return Positioned(
      bottom: MediaQuery.of(context).size.height / 30,
      right: MediaQuery.of(context).size.width / 30,
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      /* appBar: AppBar(
        title: Text("Agora Video Call $_remoteUid"),
      ), */
      body: Container(
        margin: EdgeInsets.only(
          top: 10,
        ),
        child: Stack(
          children: [
            Center(
              child: _remoteVideo(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height / 3.9,
                child: Center(
                  child: _localUserJoined
                      ? RtcLocalView.SurfaceView()
                      : CircularProgressIndicator(),
                ),
              ),
            ),
            bottomWidget(),
          ],
        ),
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid!,
        channelId: "1234",
      );
    } else {
      return Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}

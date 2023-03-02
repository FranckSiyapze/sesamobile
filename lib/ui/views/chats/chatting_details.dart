import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/views/call_screens/pickup/pickup_layout.dart';
import 'package:sesa/ui/views/chats/components/chat_detail_page_appbar.dart';
import 'package:sesa/ui/views/chats/sticker_gif.dart';
import '../../../resources/notification_methods.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/enum/message_type.dart';
import '../../utils/progress_widget.dart';
import '../../utils/storage.dart';
import '../../utils/themes/custom_app_theme.dart';
import '../../utils/themes/theme_provider.dart';
import '../../utils/utils_firebase.dart';
import 'components/msg_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Chat extends StatelessWidget {
  final String receiverId;
  final String receiverAvatar;
  final String receiverName;

  final String currUserId;
  final String currUserAvatar;
  final String currUserName;

  Chat({
    Key? key,
    required this.receiverId,
    required this.receiverAvatar,
    required this.receiverName,
    required this.currUserId,
    required this.currUserAvatar,
    required this.currUserName,
  });
  late CustomAppTheme customAppTheme;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (((context, watch, child) {
      final themeProvider = watch(themeNotifierProvider);
      customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
      return PickupLayout(
        uid: currUserId,
        scaffold: Scaffold(
          backgroundColor: Color.fromARGB(255, 211, 209, 209),
          appBar: ChatDetailPageAppBar(
            receiverName: receiverName,
            receiverAvatar: receiverAvatar,
            receiverId: receiverId,
            currUserId: currUserId,
            currUserAvatar: currUserAvatar,
            currUserName: currUserName,
          ),
          body: ChatScreen(
            receiverAvatar: receiverAvatar,
            receiverId: receiverId,
            receiverName: receiverName,
            senderName: currUserName,
            senderAvatar: currUserAvatar,
          ),
        ),
      );
    })));
  }
}

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverAvatar;
  final String receiverName;
  final String senderName;
  final String senderAvatar;
  ChatScreen({
    Key? key,
    required this.receiverId,
    required this.receiverAvatar,
    required this.receiverName,
    required this.senderName,
    required this.senderAvatar,
  }) : super(key: key);

  @override
  State createState() => ChatScreenState(
      receiverId: receiverId,
      receiverAvatar: receiverAvatar,
      receiverName: receiverName,
      senderName: senderName,
      senderAvatar: senderAvatar);
}

class ChatScreenState extends State<ChatScreen> {
  final String receiverId;
  final String receiverAvatar;
  final String receiverName;
  final String senderName;
  final String senderAvatar;

  ChatScreenState({
    Key? key,
    required this.receiverId,
    required this.receiverAvatar,
    required this.receiverName,
    required this.senderName,
    required this.senderAvatar,
  });

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  late bool isDisplaySticker;
  late bool isLoading;

  File? imageFile;
  String? imageUrl;
  ImagePicker picker = ImagePicker();
  late String chatId;
  late String id = "";
  late String recieverFcmToken = "";
  var listMessage = [];
  GlobalKey gifBtnKey = GlobalKey();
  PopupMenu menu = PopupMenu();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(onFocusChange);
    isDisplaySticker = false;
    isLoading = false;
    chatId = "";
    readLocal();
    //String agoraToken = await readStorage(value: "agoraToken");
  }

  Future getGif() async {
    /* final gif =
        await GiphyPicker.pickGif(context: context, apiKey: GIPHY_API_KEY);

    if (gif != null) {
      onSendMessage(gif.images.original.url, MessageType.Gif);
      print(gif.images.original.url);
    } */
  }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isDisplaySticker = !isDisplaySticker;
    });
  }

  Future _openFileExplorer() async {
    //setState(() => isLoadingPath = true);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowCompression: true,
        allowedExtensions: ['jpg', 'png', 'pdf', "jpeg"],
      );
      setState(() {
        if (result != null) {
          imageFile = File(result.files.single.path!);
          isLoading = true;
        }
      });

      if (result != null) {
        if (result.files.single.size <= 2097152) {
          if (result.files.single.extension == "JPEG".toLowerCase() ||
              result.files.single.extension == "JPG".toLowerCase() ||
              result.files.single.extension == "PNG".toLowerCase()) {
            print("The result :  $result");
            uploadImageFile();
          } else if (result.files.single.extension == "PDF".toLowerCase()) {
            print("Is Not and Image");
            /* setState(() {
              isLoading = false;
            }); */
            uploadDocuement();
          } else {
            /* showSnackBar(
                context: context,
                message: "Error: I can't send this file ",
                isError: true); */
            setState(() {
              isLoading = false;
            });
          }
        } else {
          /* showSnackBar(
              context: context,
              message: "Error: I can't upload file that size is > 2Mb",
              isError: true); */
          setState(() {
            isLoading = false;
          });
        }
      }
      Navigator.pop(context);
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  Future getImage({bool? isGallery}) async {
    final XFile? pickedFile = await picker.pickImage(
        source: isGallery! ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        isLoading = true;
      }
    });

    if (pickedFile != null) {
      print("The pickedFile :  $pickedFile");
      uploadImageFile();
      Navigator.pop(context);
    }
  }

  late var _image;

  /* Future getImgCamera(ImgSource source) async {
    var image = await ImagePickerGC.pickImage(
        enableCloseButton: true,
        closeIcon: Icon(
          Icons.close,
          color: Colors.red,
          size: 12,
        ),
        context: context,
        source: source,
        barrierDismissible: true,
        cameraIcon: Icon(
          Icons.camera_alt,
          color: Colors.red,
        ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
        cameraText: Text(
          "From Camera",
          style: TextStyle(color: Colors.red),
        ),
        galleryText: Text(
          "From Gallery",
          style: TextStyle(color: Colors.blue),
        ));
    setState(() {
      _image = image;
      if (_image != null) {
        imageFile = File(_image.path);
        isLoading = true;
      }
    });
    if (_image != null) {
      print("The pickedFile :  $_image");
      uploadImageFile();
      Navigator.pop(context);
    }
  } */

  onFocusChange() {
    // Hide sticker whenever keypad appears
    if (focusNode.hasFocus) {
      setState(() {
        isDisplaySticker = false;
      });
    }
  }

  void stateChanged(bool isShow) {
    print('menu is ${isShow ? 'showing' : 'closed'}');
  }

  readLocal() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(receiverId)
        .get()
        .then((datasnapshot) {
      //print("ceci est un data"+datasnapshot.data().toString());
      print(datasnapshot.data()!);
      print(datasnapshot.data()!["fcmToken"]);
      if (!mounted) return;
      setState(() {
        recieverFcmToken = datasnapshot.data()!["fcmToken"];
      });
      print("recieverFcmToken $recieverFcmToken");
    });
    //preferences = await SharedPreferences.getInstance();
    id = await readStorage(value: "email");
    if (id.hashCode <= receiverId.hashCode) {
      chatId = '$id-$receiverId';
    } else {
      chatId = '$receiverId-$id';
    }
    print("THe id is : $id");
    print("THe receiverid  is : $receiverId");
    //readMessage(id);
    print("agoraToken : " + await readStorage(value: "agoraToken"));
    setState(() {});
  }

  /* void readMessage(userId) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("chatList")
        .doc(receiverId)
        .update({"new": true});

    FirebaseFirestore.instance
        .collection("users")
        .doc(receiverId)
        .collection("chatList")
        .doc(id)
        .update({"new": true});
  } */

  void onDismiss() {
    print('Menu is dismiss');
  }

  Future uploadDocuement() async {
    String uuid = await readStorage(value: "uid");
    String fileName =
        uuid + "-" + DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child("Chat PDF").child(fileName);
    TaskSnapshot storageUploadTask = await storageReference.putFile(imageFile!);
    storageUploadTask.ref.getDownloadURL().then((downloadUrl) {
      //print("storageUploadTask: " + downloadUrl);
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl!, MessageType.Pdf);
      });
    }, onError: (error) {
      setState(() {
        isLoading = false;
      });
      print("Error: " + error);
      //showSnackBar(context: context, message: "Error: " + error, isError: true);
      //Fluttertoast.showToast(msg: "Error: " + error);
    });
  }

  Future uploadVideoFile() async {
    String uuid = await readStorage(value: "uid");
    String fileName =
        uuid + "-" + DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child("Chat Videos").child(fileName);
    TaskSnapshot storageUploadTask = await storageReference.putFile(imageFile!);

    storageUploadTask.ref.getDownloadURL().then((downloadUrl) {
      //print("storageUploadTask: " + downloadUrl);
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl!, MessageType.Video);
      });
    }, onError: (error) {
      setState(() {
        isLoading = false;
      });
      print("Error: " + error);
      //showSnackBar(context: context, message: "Error: " + error, isError: true);
      //Fluttertoast.showToast(msg: "Error: " + error);
    });
  }

  Future uploadImageFile() async {
    String uuid = await readStorage(value: "email");
    String fileName =
        uuid + "-" + DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child("Chat Images").child(fileName);
    /* final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path}); */
    print("The uploadImageFile is : $imageFile ");
    TaskSnapshot storageUploadTask = await storageReference.putFile(imageFile!);
    print("storageUploadTask: " + await storageUploadTask.ref.getDownloadURL());
    storageUploadTask.ref.getDownloadURL().then((downloadUrl) {
      //print("storageUploadTask: " + downloadUrl);
      imageUrl = downloadUrl;
      if (!mounted) return;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl!, MessageType.Image);
      });
    }, onError: (error) {
      setState(() {
        isLoading = false;
      });
      print("Error: " + error);
      //showSnackBar(context: context, message: "Error: " + error, isError: true);
      //Fluttertoast.showToast(msg: "Error: " + error);
    });
  }

  Future<bool> onBackPress() {
    if (isDisplaySticker) {
      setState(() {
        isDisplaySticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  createLoading() {
    return Positioned(
      child: isLoading ? oldcircularprogress() : Container(),
    );
  }

  createListMessages() {
    return Flexible(
      child: chatId == ""
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(kPrimary)),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("messages")
                  .doc(chatId)
                  .collection(chatId)
                  .orderBy("timestamp", descending: true)
                  // .limit(20)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(kPrimary)),
                  );
                } else {
                  listMessage = snapshot.data!.docs;
                  return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      controller: listScrollController,
                      itemCount: snapshot.data!.docs.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return MessageItem(
                            index: index,
                            document: snapshot.data!.docs[index],
                            listMessage: listMessage,
                            currUserId: id,
                            receiverAvatar: receiverAvatar,
                            context: context,
                            onDeleteMsg: onDeleteMsg);
                      });
                }
              },
            ),
    );
  }

  onDeleteMsg(DocumentSnapshot document) {
    var docRef = FirebaseFirestore.instance
        .collection("messages")
        .doc(chatId)
        .collection(chatId)
        .doc(document['timestamp']);
    if (document['timestamp'] == listMessage[0]['timestamp']) {
      //check type of document if image delete from storage
      if (document['type'] == Utils.msgToNum(MessageType.Image)) {
        /*FirebaseStorage.instance
            .getReferenceFromUrl(document["content"])
            .then((res) {
          res.delete().then((value) => print("Deleted"));
        });*/
      }
      // 𝘛𝘩𝘪𝘴 𝘮𝘦𝘴𝘴𝘢𝘨𝘦 𝘸𝘢𝘴 𝘥𝘦𝘭𝘦𝘵𝘦𝘥
      docRef.update({
        "content": "🚫 𝘛𝘩𝘪𝘴 𝘮𝘴𝘨 𝘸𝘢𝘴 𝘥𝘦𝘭𝘦𝘵𝘦𝘥",
        "type": Utils.msgToNum(MessageType.Deleted)
      });
      //change content and type of document
      //change from chatlist as well on both sides
      FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .collection("chatList")
          .doc(receiverId)
          .update({
        "content": "🚫 𝘛𝘩𝘪𝘴 𝘮𝘴𝘨 𝘸𝘢𝘴 𝘥𝘦𝘭𝘦𝘵𝘦𝘥",
        "type": Utils.msgToNum(MessageType.Deleted),
      });

      FirebaseFirestore.instance
          .collection("users")
          .doc(receiverId)
          .collection("chatList")
          .doc(id)
          .update({
        "content": "🚫 𝘛𝘩𝘪𝘴 𝘮𝘴𝘨 𝘸𝘢𝘴 𝘥𝘦𝘭𝘦𝘵𝘦𝘥",
        "type": Utils.msgToNum(MessageType.Deleted),
      });
    } else {
      //else
      //check type of document if image delete from storage getref from imageurl
      //change content and type of document
      if (document['type'] == Utils.msgToNum(MessageType.Image)) {
        /* FirebaseStorage.instance
            .getReferenceFromUrl(document["content"])
            .then((res) {
          res.delete().then((value) => print("Deleted"));
        });*/
      }
      docRef.update({
        "content": "🚫 𝘛𝘩𝘪𝘴 𝘮𝘴𝘨 𝘸𝘢𝘴 𝘥𝘦𝘭𝘦𝘵𝘦𝘥",
        "type": Utils.msgToNum(MessageType.Deleted),
      });
    }
  }

  void onAttachmentClick() {
    menu.show(widgetKey: gifBtnKey);
  }

  late CustomAppTheme customAppTheme;

  createInput() {
    return Consumer(
      builder: ((context, watch, child) {
        final themeProvider = watch(themeNotifierProvider);
        customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
        return Container(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                child: IconButton(
                  key: gifBtnKey,
                  icon: Icon(Icons.attach_file),
                  color: customAppTheme.kVioletColor,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Ktransparent,
                      builder: (context) => Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: new BoxDecoration(
                          color: customAppTheme.kBackgroundColorFinal,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(25.0),
                            topRight: const Radius.circular(25.0),
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                        child: ListView(
                          children: [
                            Container(
                              margin: Spacing.fromLTRB(10, 16, 10, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: customAppTheme.colorTextFeed,
                                      size: 16,
                                    ),
                                  ),
                                  Text(
                                    "Filter".toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: customAppTheme.colorTextFeed,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        /*  selectedLocation = 0;
                                            selectedDate = 2;
                                            selectedSpeciality = 0; */
                                      });
                                    },
                                    child: Text(
                                      "Reset",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: customAppTheme.colorTextFeed,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: Spacing.fromLTRB(10, 24, 10, 0),
                              child: Text(
                                'Source',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: customAppTheme.colorTextFeed,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              margin: Spacing.fromLTRB(10, 12, 10, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _openFileExplorer();
                                      //getImage(isGallery: true);
                                      setState(() {
                                        isDisplaySticker = false;
                                      });
                                    },
                                    child: Chip(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      backgroundColor: kPrimary,
                                      avatar: Icon(
                                        Icons.image,
                                        size: 16,
                                        color: KWhite,
                                      ),
                                      label: Text(
                                        "Gallery",
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          color: KWhite,
                                          letterSpacing: 0,
                                          wordSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      padding: Spacing.fromLTRB(12, 6, 12, 6),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      getImage(isGallery: false);
                                      //getImgCamera(ImgSource.Camera);
                                      setState(() {
                                        isDisplaySticker = false;
                                      });
                                    },
                                    child: Chip(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      backgroundColor: kPrimary,
                                      avatar: Icon(
                                        Icons.camera,
                                        size: 16,
                                        color: KWhite,
                                      ),
                                      label: Text(
                                        "Camera",
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          color: KWhite,
                                          letterSpacing: 0,
                                          wordSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      padding: Spacing.fromLTRB(12, 6, 12, 6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  //onPressed: () {},
                ),
              ),
              Flexible(
                child: Container(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    style: TextStyle(
                      color: customAppTheme.colorTextFeed,
                      fontSize: 15.0,
                    ),
                    controller: textEditingController,
                    decoration: InputDecoration.collapsed(
                        hintText: "Type message...",
                        hintStyle: TextStyle(color: Colors.grey)),
                    focusNode: focusNode,
                  ),
                ),
              ),

              //SEND MESSAGE BUTTON
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  icon: Icon(Icons.send),
                  color: kPrimary,
                  onPressed: () => onSendMessage(
                      textEditingController.text, MessageType.Text),
                ),
              )
            ],
          ),
          width: double.infinity,
          height: 50.0,
          decoration: BoxDecoration(
            /* border: Border(
              top: BorderSide(color: Colors.grey, width: 0.5),
            ), */
            color: customAppTheme.kBackgroundColor,
          ),
        );
      }),
    );
  }

  createStickers() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              StickerGif(gifName: "mimi1", onSendMessage: onSendMessage),
              StickerGif(gifName: "mimi2", onSendMessage: onSendMessage),
              StickerGif(gifName: "mimi3", onSendMessage: onSendMessage),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),

          //ROW 2
          Row(
            children: [
              StickerGif(gifName: "mimi4", onSendMessage: onSendMessage),
              StickerGif(gifName: "mimi5", onSendMessage: onSendMessage),
              StickerGif(gifName: "mimi6", onSendMessage: onSendMessage),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),

          //ROW 3
          Row(
            children: [
              StickerGif(gifName: "mimi7", onSendMessage: onSendMessage),
              StickerGif(gifName: "mimi8", onSendMessage: onSendMessage),
              StickerGif(gifName: "mimi9", onSendMessage: onSendMessage),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  void onSendMessage(String contentMsg, MessageType type) async {
    setState(() {
      isDisplaySticker = false;
    });

    String currTime = DateTime.now().millisecondsSinceEpoch.toString();

    if (contentMsg != "" && contentMsg.isNotEmpty) {
      String body = type == MessageType.Text
          ? contentMsg
          : type == MessageType.Image
              ? "Image"
              : type == MessageType.Video
                  ? "Video"
                  : type == MessageType.Pdf
                      ? "Pdf"
                      : "Sticker";
      String image = type == MessageType.Image ? contentMsg : "";
      String nameUser = await readStorage(value: "name");
      sendPushNotification(
        nameUser,
        recieverFcmToken,
        body,
        image,
        id,
        senderName,
        receiverAvatar,
        receiverId,
        receiverName,
        receiverAvatar,
      );

      textEditingController.clear();
      print("The chalist is : $chatId");
      FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .collection("chatList")
          .doc(receiverId)
          .set({
        "id": receiverId,
        "receiverId": receiverId,
        "currentId": id,
        "receiverName": receiverName,
        "currUserName": senderName,
        "currImgUrl": senderAvatar,
        "receivImgUrl": receiverAvatar,
        "content": contentMsg,
        "type": Utils.msgToNum(type),
        "timestamp": currTime,
        "showCheck": true,
        /* "new": true, */
      });

      FirebaseFirestore.instance
          .collection("users")
          .doc(receiverId)
          .collection("chatList")
          .doc(id)
          .set({
        "id": id,
        "receiverId": id,
        "currentId": receiverId,
        "receiverName": senderName,
        "currUserName": receiverName,
        "currImgUrl": receiverAvatar,
        "receivImgUrl": senderAvatar,
        "content": contentMsg,
        "type": Utils.msgToNum(type),
        "timestamp": currTime,
        "showCheck": false,
        /* "new": true, */
      });

      var docRef = FirebaseFirestore.instance
          .collection("messages")
          .doc(chatId)
          .collection(chatId)
          .doc(currTime);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(
          docRef,
          {
            "idFrom": id,
            "nameFrom": senderName,
            "idTo": receiverId,
            "nameTo": receiverName,
            "timestamp": currTime,
            "content": contentMsg,
            "type": Utils.msgToNum(type)
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(microseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: "Empty message cannot be sent");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              createListMessages(),
              //show stickers
              //(isDisplaySticker ? createStickers() : Container()),
              Align(
                alignment: Alignment.bottomCenter,
                child: createInput(),
              ),
            ],
          ),
          createLoading(),
        ],
      ),
      onWillPop: onBackPress,
    );
  }
}

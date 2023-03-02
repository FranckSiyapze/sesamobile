import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesa/call_utilies.dart';
import 'package:sesa/ui/utils/permissions.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/status_indicator.dart';

import '../../../utils/themes/custom_app_theme.dart';
import '../../../utils/themes/theme_provider.dart';
import '../../../widgets/container/container.dart';

class ChatDetailPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String receiverAvatar;
  final String receiverName;
  final String receiverId;

  final String currUserId;
  final String currUserAvatar;
  final String currUserName;

  ChatDetailPageAppBar({
    Key? key,
    required this.receiverAvatar,
    required this.receiverName,
    required this.receiverId,
    required this.currUserAvatar,
    required this.currUserName,
    required this.currUserId,
  });
  late CustomAppTheme customAppTheme;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: ((context, watch, child) {
      final themeProvider = watch(themeNotifierProvider);
      customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
      return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: customAppTheme.kBackgroundColorFinal,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: customAppTheme.colorTextFeed,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                /* CircleAvatar(
                  backgroundImage: NetworkImage(receiverAvatar),
                  maxRadius: 20,
                ), */
                Container(
                  width: 40,
                  height: 40,
                  //color: customAppTheme.kBackgroundColor,
                  child: CachedNetworkImage(
                    imageUrl: receiverAvatar,
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, imageProvider) => ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      child: Image(
                        image: AssetImage("assets/images/sesabw.png"),
                        width: 40,
                        height: 40,
                      ),
                    ),
                    errorWidget: (context, url, error) => ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      child: Image(
                        image: AssetImage("assets/images/sesabw.png"),
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        receiverName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: customAppTheme.colorTextFeed,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          StatusIndicator(
                            uid: receiverId,
                            screen: "chatListScreen",
                          ),
                          FxSpacing.width(2),
                          StatusIndicator(
                            uid: receiverId,
                            screen: "chatDetailScreen",
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await Permissions.cameraAndMicrophonePermissionsGranted()
                        ? CallUtils.dial(
                            currUserId: currUserId,
                            currUserName: currUserName,
                            currUserAvatar: currUserAvatar,
                            receiverId: receiverId,
                            receiverAvatar: receiverAvatar,
                            receiverName: receiverName,
                            context: context,
                          )
                        : {};
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: customAppTheme.kVioletColor,
                    ),
                    padding: EdgeInsets.all(7),
                    child: Icon(
                      Icons.videocam_rounded,
                      color: customAppTheme.kWhite,
                      size: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }));
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

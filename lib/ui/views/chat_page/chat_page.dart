import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sesa/ui/utils/colors.dart';
import 'package:sesa/ui/utils/spacing.dart';
import 'package:sesa/ui/utils/themes/custom_app_theme.dart';
import 'package:sesa/ui/utils/themes/text_style.dart';
import 'package:sesa/ui/utils/themes/theme_provider.dart';
import 'package:sesa/ui/views/home_page/models/chat.dart';
import 'package:sesa/ui/widgets/card/card.dart';
import 'package:sesa/ui/widgets/container/container.dart';
import 'package:sesa/ui/widgets/text/text.dart';
import 'package:sesa/ui/widgets/text_field/text_field.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;
  ChatPage({Key? key, required this.chat}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Chat chat;
  late CustomAppTheme customAppTheme;
  Widget _buildReceiveMessage({String? message, String? time}) {
    return Padding(
      padding: FxSpacing.horizontal(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: FxCard(
              color: customAppTheme.medicarePrimary.withAlpha(40),
              margin: FxSpacing.right(140),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FxText.caption(
                    message!,
                    color: customAppTheme.colorTextFeed,
                    xMuted: true,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FxText.overline(
                      time!,
                      color: customAppTheme.colorTextFeed,
                      xMuted: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendMessage({String? message, String? time}) {
    return Padding(
      padding: FxSpacing.horizontal(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: FxCard(
              color: AppTheme.customTheme.medicarePrimary,
              margin: FxSpacing.left(140),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FxText.caption(
                    message!,
                    color: AppTheme.customTheme.medicareOnPrimary,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FxText.overline(
                      time!,
                      color: AppTheme.customTheme.medicareOnPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chat = widget.chat;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final themeProvider = watch(themeNotifierProvider);
        customAppTheme = AppTheme.getCustomAppTheme(themeProvider.themeMode());
        return Scaffold(
          backgroundColor: customAppTheme.kBackgroundColorFinal,
          body: Padding(
            padding: FxSpacing.top(28),
            child: Column(
              children: [
                FxContainer(
                  color: customAppTheme.kBackgroundColorFinal,
                  child: Row(
                    children: [
                      InkWell(
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: customAppTheme.colorTextFeed,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      FxSpacing.width(8),
                      FxContainer.rounded(
                        paddingAll: 0,
                        child: Image(
                          width: 40,
                          height: 40,
                          image: AssetImage(chat.image),
                        ),
                      ),
                      FxSpacing.width(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FxText.b2(
                              chat.name,
                              fontWeight: 600,
                            ),
                            FxSpacing.height(2),
                            Row(
                              children: [
                                FxContainer.rounded(
                                  paddingAll: 3,
                                  color: AppTheme.customTheme.groceryPrimary,
                                  child: Container(),
                                ),
                                FxSpacing.width(4),
                                FxText.caption(
                                  'Online',
                                  color: customAppTheme.colorTextFeed,
                                  xMuted: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      FxSpacing.width(16),
                      FxContainer.rounded(
                          color: AppTheme.customTheme.medicarePrimary,
                          paddingAll: 8,
                          child: Icon(
                            Icons.videocam_rounded,
                            color: AppTheme.customTheme.medicareOnPrimary,
                            size: 16,
                          )),
                      FxSpacing.width(8),
                      /* FxContainer.rounded(
                        color: AppTheme.customTheme.medicarePrimary,
                        paddingAll: 8,
                        child: Icon(
                          Icons.call,
                          color: AppTheme.customTheme.medicareOnPrimary,
                          size: 16,
                        ),
                      ), */
                    ],
                  ),
                ),
                FxSpacing.height(16),
                FxContainer(
                  margin: FxSpacing.horizontal(40),
                  borderRadiusAll: 8,
                  color: AppTheme.customTheme.medicarePrimary.withAlpha(40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.watch_later,
                        color: AppTheme.customTheme.medicarePrimary,
                        size: 20,
                      ),
                      FxSpacing.width(8),
                      FxText.caption(
                        'Sun, Jan 19, 08:00am - 10:00am',
                        color: AppTheme.customTheme.medicarePrimary,
                      ),
                    ],
                  ),
                ),
                FxSpacing.height(16),
                Expanded(
                    child: ListView(
                  children: [
                    _buildReceiveMessage(
                        message: 'Yes, What help do you need?', time: '08:25'),
                    FxSpacing.height(16),
                    _buildSendMessage(
                        message: 'Should I come to hospital tomorrow?',
                        time: '08:30'),
                    FxSpacing.height(16),
                    _buildReceiveMessage(
                        message: 'Yes sure, you can come after 2:00 pm',
                        time: '08:35'),
                    FxSpacing.height(16),
                    _buildSendMessage(
                        message: 'Sure, Thank you!!', time: '08:40'),
                    FxSpacing.height(24),
                  ],
                )),
                FxContainer(
                  marginAll: 24,
                  paddingAll: 0,
                  color: Ktransparent,
                  child: FxTextField(
                    focusedBorderColor: AppTheme.customTheme.medicarePrimary,
                    cursorColor: AppTheme.customTheme.medicarePrimary,
                    textFieldStyle: FxTextFieldStyle.outlined,
                    labelText: 'Type Something ...',
                    labelStyle: FxTextStyle.caption(
                      color: customAppTheme.colorTextFeed,
                      xMuted: true,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: customAppTheme.kBackgroundColor,
                    suffixIcon: Icon(
                      MdiIcons.send,
                      color: AppTheme.customTheme.medicarePrimary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

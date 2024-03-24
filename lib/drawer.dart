import 'package:flutter/material.dart';

import 'package:shikshahive/const.dart';
import 'package:url_launcher/url_launcher.dart';



class DrawerComponent extends StatelessWidget {
  const DrawerComponent({
    super.key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _scaffoldKey = scaffoldKey;

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: _scaffoldKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // SafeArea(
                //   child: Container(
                //     decoration: BoxDecoration(color: primaryColor),
                //     height: 200,
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.end,
                //       children: [
                //         IconButton(
                //           onPressed: () {
                //             _scaffoldKey.currentState?.closeDrawer();
                //           },
                //           icon: Icon(
                //             Icons.menu,
                //             color: Colors.white,
                //             size: 25,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                DrawerHeader(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0,
                      color: Colors.transparent,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            60,
                            30,
                            60,
                            0,
                          ),
                          child: Image.asset(
                            "assets/app_logo.png",
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            _scaffoldKey.currentState?.closeDrawer();
                          },
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                DrawerListTileMenu(
                  Icons.star,
                  "Rate Us",
                  _scaffoldKey,
                  onClick: () {
                    launchUrl(
                      Uri.parse(
                          "https://play.google.com/store/apps/details?id=com.techhanger.shikshahive"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
                DrawerListTileMenu(
                    Icons.share_rounded, 'Share App', _scaffoldKey,
                    onClick: () {
                  // Get.to(() => const ShareApp());
                }),

                DrawerListTileMenu(
                    Icons.school_rounded, 'NEB Result', _scaffoldKey,
                    onClick: () {
                  // Utility().launchNebResultUrl(context);
                }),

                // DrawerListTileMenu(
                //   Icons.terminal_rounded,
                //   'About Developers',
                //   _scaffoldKey,
                //   onClick: () {
                //     Get.to(() => AboutApp());
                //   },
                // ),
                DrawerListTileMenu(
                  Icons.info_rounded,
                  'About App',
                  _scaffoldKey,
                  onClick: () {
                 
                  },
                ),
              
              ],
            ),
          ),
          Image.asset(
            "images/chat-bot.png",
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          // Text(loginController.appInfo.version)
        ],
      ),
    );
  }
}

class DrawerListTileMenu extends StatelessWidget {
  final IconData drawerIcon;
  final String drawerText;
  final Function onClick;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  const DrawerListTileMenu(
    this.drawerIcon,
    this.drawerText,
    this._scaffoldKey, {super.key, 
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(color: Colors.white),
      child: ListTile(
        // horizontalTitleGap: -5,
        leading: Icon(drawerIcon, color: PRIMATY_COLOR),
        title: Text(
          drawerText,
          style: const TextStyle(color: PRIMATY_COLOR),
        ),
        onTap: () {
          _scaffoldKey.currentState?.closeDrawer();
          Future.delayed(const Duration(milliseconds: 200), () {
            onClick();
          });
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:share_plus/share_plus.dart';

import 'config/const.dart';
import 'screens/image_viewer.dart';
import 'utils/utils.dart';

class CustomButtonSheet extends StatelessWidget {
  final String url;
  final InAppWebViewController controller;
  const CustomButtonSheet(this.url, this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _customListTile(
          icon: Icons.share_rounded,
          title: "Share Link",
          onTap: () {
            Navigator.pop(context);
            Share.share(url);
          },
        ),
        if (!url.startsWith("$PRIMARY_DOMAIN/assets/") && !(Utils.checkIfIsImageLink(url)))
          _customListTile(
            icon: Icons.remove_red_eye_rounded,
            title: "View on Browser",
            onTap: () {
              Navigator.pop(context);
              Utils.launchUrlToExternalApplication(url);
            },
          ),
        if (Utils.checkIfIsImageLink(url))
          _customListTile(
            icon: Icons.image,
            title: "View Image",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageViewer(
                      url,
                    ),
                  ));
            },
          ),
        if (!Utils.checkIfIsImageLink(url))
          _customListTile(
            icon: Icons.arrow_forward_ios_rounded,
            title: "Continue",
            onTap: () {
              Navigator.pop(context);
              controller.loadUrl(
                urlRequest: URLRequest(url: WebUri.uri(Uri.parse(url))),
              );
            },
          ),
      ],
    );
  }

  ListTile _customListTile(
      {required String title, required IconData icon, void Function()? onTap}) {
    return ListTile(
      splashColor: Colors.transparent,
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: Icon(icon),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shikshahive/config/const.dart';

class ErrorContainer extends StatelessWidget {
  const ErrorContainer({
    super.key,
    required this.webViewController,
  });

  final InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              webViewController!.reload();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMATY_COLOR,
              foregroundColor: Colors.white,
            ),
            child: const Text("reload"),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "error occured",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}

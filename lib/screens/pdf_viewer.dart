import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:url_launcher/url_launcher.dart';

class PdfViewer extends StatelessWidget {
  final String url;

  const PdfViewer(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0a6bc7),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              log("View pdf");
              // launchUrl(Uri.parse(url));
            },
            icon: const Icon(
              Icons.file_download_sharp,
            ),
          )
        ],
        title: const Text("View PDF File"),
      ),
      body: Container(
        // child: SfPdfViewer.network(
        //   url,
        // ),
      ),
    );
  }
}

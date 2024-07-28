import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../config/const.dart';
class ImageViewer extends StatelessWidget {
  final String src;

  const ImageViewer(this.src, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("Url from image viewer; $src");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMATY_COLOR,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("View Image"),
      ),
      body: SafeArea(
        child: PhotoView(
          imageProvider: Image.network(src).image,
          backgroundDecoration: const BoxDecoration(
            color: Colors.white,
          ),
        ),
      ),
    );
    return Scaffold(
      body: InteractiveViewer(
        child: SafeArea(
            child: Center(
          child: Image.network(
            src,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child; // Handle initial state
              final progress = loadingProgress.cumulativeBytesLoaded /
                  int.parse(
                    loadingProgress.expectedTotalBytes.toString(),
                  );

              return progress == 1.0
                  ? child // Show the image when fully loaded
                  : CircularProgressIndicator(
                      value: progress); // Show progress indicator otherwise
            },
            errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/error_image.jpg', // Display a default image on error
                errorBuilder: (context, error, stackTrace) =>
                    const Text('Something went wrong')),
            fit: BoxFit.cover,
            // Consider adding these as needed:
            // width: ...,
            // height: ...,
            // fit: BoxFit.cover, // Adjust image fit as desired
          ),
        )

            /* Center(
            child: FutureBuilder(
              future: precacheImage(NetworkImage(src), context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show loading indicator while the image is being loaded
                  return const CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  // Show the image once it's loaded
                  return Image.network(src);
                } else {
                  // Show an error message if the image fails to load
                  return Text('Failed to load image');
                }
              },
            ),*/

            ),
      ),
    );
  }
}

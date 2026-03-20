import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullScreenImageWidget extends StatelessWidget {
  final String? path;
  final String? url;

  const FullScreenImageWidget({super.key, this.path, this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          child: path != null
              ? Image.file(File(path!))
              : url != null
              ? CachedNetworkImage(imageUrl: url!)
              : SizedBox(),
        ),
      ),
    );
  }
}

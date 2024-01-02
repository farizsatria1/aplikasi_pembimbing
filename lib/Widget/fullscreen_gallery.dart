import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenPhotoView extends StatelessWidget {
  final List gambar;
  final int initialIndex;

  const FullScreenPhotoView(
      {Key? key, required this.gambar, required this.initialIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: PhotoViewGallery.builder(
        itemCount: gambar.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(gambar[index]['foto_dokumentasi']),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
            maxScale: PhotoViewComputedScale.covered * 1.1,
            heroAttributes: PhotoViewHeroAttributes(tag: index),
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        pageController: PageController(initialPage: initialIndex),
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
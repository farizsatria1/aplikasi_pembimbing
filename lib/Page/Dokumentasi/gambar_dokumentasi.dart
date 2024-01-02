import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../Widget/color.dart';
import '../../Widget/fullscreen_gallery.dart';
import '../../Widget/url.dart';

class GambarDokumentasi extends StatelessWidget {
  final List gambar;
  final Future dokumentasi;

  const GambarDokumentasi(
      {Key? key, required this.gambar, required this.dokumentasi})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Gambar",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: AppColor.biru1,
      ),
      body: FutureBuilder(
          future: dokumentasi,
          builder: (context, snapshoot) {
            if (snapshoot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColor.biru1,
                ),
              );
            } else {
              return MasonryGridView.builder(
                gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: gambar.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullScreenPhotoView(
                                  gambar: gambar, initialIndex: index)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Image.network(
                        ApiConstants.BASE_URL + gambar[index]['foto_dokumentasi'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}

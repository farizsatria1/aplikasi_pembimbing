import 'package:flutter/material.dart';
import 'package:pembimbing_magang/Page/Dokumentasi/gambar_dokumentasi.dart';
import 'package:pembimbing_magang/Widget/fullscreen_photo.dart';
import '../../Widget/color.dart';
import '../../Widget/url.dart';

class ListDokumentasi extends StatelessWidget {
  final List listDokumentasi;
  final String nama;
  final Future getDokumentasi;

  const ListDokumentasi(
      {Key? key, required this.listDokumentasi, required this.nama, required this.getDokumentasi})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "List Project",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: AppColor.biru1,
      ),
      body: FutureBuilder(
        future: getDokumentasi,
        builder: (context, snapshoot) {
          if(snapshoot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(
                color: AppColor.biru1,
              ),
            );
          } else {
            return listDokumentasi.isEmpty
            ? const Center(
              child: Text(
                'Tidak ada dokumentasi',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            )
            : ListView.builder(
              itemCount: listDokumentasi.length,
              itemBuilder: (context, index) {
                final dokumentasi = listDokumentasi[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 0.5, color: Colors.grey)),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dokumentasi['judul'] ?? 'Belum ada judul Project',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "by " + nama,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (dokumentasi['progress'].isEmpty)
                              const Text(
                                'Tidak ada dokumentasi',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic
                                ),
                              )
                            else
                              Row(
                                children: dokumentasi['progress']
                                    .take(4)
                                    .map<Widget>((progress) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Stack(
                                        children: <Widget>[
                                          if (progress['foto_dokumentasi'] != null)
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => GambarProgress(
                                                      gambar: ApiConstants.BASE_URL + progress['foto_dokumentasi'],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Image.network(ApiConstants.BASE_URL +
                                                  progress['foto_dokumentasi'],
                                                fit: BoxFit.cover,
                                                height: MediaQuery.of(context).size.height * 0.095,
                                                width: MediaQuery.of(context).size.width * 0.2,
                                              ),
                                            ),
                                          if (progress['foto_dokumentasi'] != null && dokumentasi['progress'].indexOf(progress) == 3 && dokumentasi['progress'].length > 4)
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                    GambarDokumentasi(
                                                      dokumentasi: getDokumentasi,
                                                      gambar: dokumentasi['progress'],
                                                    ),));
                                              },
                                              child: Container(
                                                height: MediaQuery.of(context).size.height * 0.095,
                                                width: MediaQuery.of(context).size.width * 0.2,
                                                alignment: Alignment.center,
                                                color: Colors.black38,
                                                child: Center(
                                                  child: Text(
                                                    '+${dokumentasi['progress'].length - 4}',
                                                    style: const TextStyle(color: Colors.white,fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },).toList(),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }
      ),
    );
  }
}

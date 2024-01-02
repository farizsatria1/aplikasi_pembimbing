import 'package:flutter/material.dart';
import 'package:pembimbing_magang/Page/Absensi/absensi_peserta.dart';
import 'package:pembimbing_magang/Page/Approve/progress_approve.dart';
import 'package:pembimbing_magang/Page/Progress/progress_peserta.dart';
import 'package:pembimbing_magang/Widget/color.dart';
import 'package:pembimbing_magang/Page/Status%20Peserta/status_peserta.dart';
import '../Api/api.dart';

class ListPeserta extends StatefulWidget {
  const ListPeserta({Key? key}) : super(key: key);

  @override
  State<ListPeserta> createState() => _ListPesertaState();
}

class _ListPesertaState extends State<ListPeserta> {
  String? name;
  List<dynamic> pesertaList = [];
  int currentPage = 1;
  int itemsPerPage = 5;

  bool hasMorePages() {
    int totalPages = (pesertaList.length / itemsPerPage).ceil();
    return currentPage < totalPages;
  }

  Future<void> getListPeserta() async {
    try {
      final data = await Api.getListPeserta();
      setState(() {
        pesertaList = data;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _refreshData() async {
    await getListPeserta();
  }

  @override
  void initState() {
    super.initState();
    getListPeserta();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> paginatedData = pesertaList
        .skip((currentPage - 1) * itemsPerPage)
        .take(itemsPerPage)
        .toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "List Peserta",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: AppColor.biru1,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => StatusPeserta(),));
            },
            icon: Icon(Icons.person_2_rounded),
          ),
        ],
      ),
      body: FutureBuilder(
          future: Api.getListPeserta(),
          builder: (context, snapshoot) {
            if (snapshoot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: AppColor.biru1),
              );
            } else if (snapshoot.hasData) {
              return SafeArea(
                child: RefreshIndicator(
                  onRefresh: _refreshData,
                  color: Colors.black,
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: paginatedData.length,
                      itemBuilder: (context, index) {
                        final dokumentasi = paginatedData[index];
                        if(dokumentasi['status'] == 'aktif'){
                          return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                useSafeArea: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                ),
                                backgroundColor: Colors.white,
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        height: MediaQuery.of(context).size.height * 0.4,
                                        child: Column(
                                          children: [
                                            Text(
                                              dokumentasi["nama"],
                                              // Menggunakan nilai nama dari widget
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                              ),
                                            ),
                                            SizedBox(height: 25),
                                            LihatPeserta(
                                              title: "Lihat Presensi",
                                              icon: Icon(Icons.timer),
                                              pesertaList: pesertaList,
                                              button: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AbsensiPage(
                                                          id: dokumentasi["id"],
                                                          nama: dokumentasi["nama"],
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                            SizedBox(height: 15),
                                            LihatPeserta(
                                              title: "Lihat Progress",
                                              icon: Icon(Icons.file_copy_sharp),
                                              pesertaList: paginatedData,
                                              button: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProgressPeserta(
                                                          id: dokumentasi["id"],
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                            SizedBox(height: 15),
                                            LihatPeserta(
                                              title: "Progress Approve",
                                              icon: Icon(Icons.check_box),
                                              pesertaList: pesertaList,
                                              button: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ApproveProgress(
                                                          id: dokumentasi["id"],
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                            SizedBox(height: 15),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Card(
                              margin: EdgeInsets.only(top: 20),
                              color: Colors.blue,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              shadowColor: Colors.black,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.blueGrey, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dokumentasi["nama"],
                                        // Menggunakan nilai nama dari widget
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        dokumentasi["asal_sekolah"],
                                        // Menggunakan nilai nama dari widget
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Tanggal Mulai :  " +
                                            dokumentasi["tgl_mulai"],
                                        // Menggunakan nilai nama dari widget
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }),
                ),
              );
            } else {
              return Center(
                child: Text('Tidak ada peserta'),
              );
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.navigate_before),
            label: 'Sebelumnya',
          ),
          BottomNavigationBarItem(
            icon: Text(currentPage.toString()),
            label: 'Halaman',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.navigate_next),
            label: 'Berikutnya',
          ),
        ],
        onTap: (index) {
          if (index == 0 && currentPage > 1) {
            setState(() {
              currentPage--;
            });
          } else if (index == 2 && hasMorePages()) {
            setState(() {
              currentPage++;
            });
          } else if (index == 1) {
            int totalPages = (pesertaList.length / itemsPerPage).ceil();

            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Add the title or heading here
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'List Halaman',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // List of pages
                        ...List.generate(totalPages, (index) {
                          int page = index + 1;
                          return ListTile(
                            title: Text('Halaman $page'),
                            onTap: () {
                              setState(() {
                                currentPage = page;
                              });
                              Navigator.pop(context); // Close the bottom sheet
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            );

          }
        },
        unselectedItemColor: hasMorePages() ? Colors.black : Colors.grey,
        selectedItemColor: Colors.black,
      ),
    );
  }
}

class LihatPeserta extends StatelessWidget {
  const LihatPeserta({
    Key? key,
    required this.pesertaList,
    required this.button,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final List pesertaList;
  final VoidCallback button;
  final Icon icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(
          color: Colors.black,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: button,
        leading: icon,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

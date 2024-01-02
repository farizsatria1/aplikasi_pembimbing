import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:pembimbing_magang/Api/api.dart';
import 'package:pembimbing_magang/Page/Dokumentasi/list_dokumentasi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widget/color.dart';

class Dokumentasi extends StatefulWidget {
  const Dokumentasi({Key? key}) : super(key: key);

  @override
  State<Dokumentasi> createState() => _DokumentasiState();
}

class _DokumentasiState extends State<Dokumentasi> {
  List<dynamic> listDokumentasi = [];
  bool isLoading = false;
  int currentPage = 1;
  int itemsPerPage = 5;

  bool hasMorePages() {
    int totalPages = (listDokumentasi.length / itemsPerPage).ceil();
    return currentPage < totalPages;
  }

  Future<void> getDokumentasi() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? idPembimbing = prefs.getInt('id');
    try {
      if (idPembimbing != null) {
        final data = await Api.getDokumentasi(idPembimbing);
        setState(() {
          listDokumentasi = data!;
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getDokumentasi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> paginatedData = listDokumentasi
        .reversed
        .skip((currentPage - 1) * itemsPerPage)
        .take(itemsPerPage)
        .toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Dokumentasi",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: AppColor.biru1,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColor.biru1,
              ),
            )
          : paginatedData.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada data',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 30),
                  itemCount: paginatedData.length,
                  itemBuilder: (context, index) {
                    final dokumentasi = paginatedData[index];
                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: AppColor.biru1,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dokumentasi["nama"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ListDokumentasi(
                                        listDokumentasi:
                                            dokumentasi['pekerjaan'],
                                        nama: dokumentasi['nama'],
                                        getDokumentasi: getDokumentasi(),
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                        ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Accordion(
                              headerBorderRadius: 0,
                              paddingListTop: 0,
                              paddingListBottom: 0,
                              headerBorderColor: AppColor.biru1,
                              headerBorderColorOpened: Colors.transparent,
                              headerBackgroundColorOpened: Colors.blue,
                              contentBackgroundColor: Colors.blue,
                              contentBorderColor: AppColor.biru1,
                              scaleWhenAnimating: true,
                              openAndCloseAnimation: true,
                              headerPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              children: [
                                AccordionSection(
                                  header: const Text(
                                    "List Pekerjaan",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  content: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: dokumentasi['pekerjaan'].isEmpty
                                        ? [
                                            const Text(
                                              'Belum ada judul Project',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.italic),
                                            )
                                          ]
                                        : dokumentasi['pekerjaan']
                                            .map<Widget>((pekerjaan) {
                                            return SizedBox(
                                              width: double.infinity,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 10),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(Icons.circle,
                                                        color: Colors.white,
                                                        size: 10),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      pekerjaan['judul'] ??
                                                          'Belum ada judul Project',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.navigate_before),
            label: 'Sebelumnya',
          ),
          BottomNavigationBarItem(
            icon: Text(currentPage.toString()),
            label: 'Halaman',
          ),
          const BottomNavigationBarItem(
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
            int totalPages = (listDokumentasi.length / itemsPerPage).ceil();

            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
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
                        const Padding(
                          padding: EdgeInsets.all(8.0),
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

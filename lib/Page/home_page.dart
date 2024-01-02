import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pembimbing_magang/Widget/piket.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Api/api.dart';
import '../Widget/color.dart';
import '../Widget/url.dart';
import '../login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? name;
  bool isLoading = false;
  List<dynamic> listAbsenMasuk = [];
  List<dynamic> listPiket = [];
  List<dynamic> listGambar = [];
  int _currentIndex = 0;
  String today = DateFormat('EEEE', 'id_ID').format(DateTime.now());

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade300,
          title: const Text('Konfirmasi Log Out',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Apakah Anda yakin ingin Log Out?'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                await prefs.remove('id');
                await prefs.remove('name');
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),(route) => false);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? "";
    });
  }

  Future<void> getListMasuk() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? idPembimbing = prefs.getInt('id');
    try {
      final response = await Api.getAllMasuk(idPembimbing!);
      setState(() {
        listAbsenMasuk = response.where((item) {
          DateTime jamMasuk = DateTime.parse(item['jam_masuk']);
          DateTime now = DateTime.now();
          return jamMasuk.year == now.year &&
              jamMasuk.month == now.month &&
              jamMasuk.day == now.day;
        }).toList();
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getPiket() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Api.getPiket();
      setState(() {
        listPiket = response;
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getGambar() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Api.getGambar();
      setState(() {
        listGambar = response;
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    loadData();
    getListMasuk();
    getPiket();
    getGambar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: RichText(
          text: TextSpan(
              text: "Halo, ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.biru4,
                  fontStyle: FontStyle.italic,
                  fontSize: 22),
              children: [
                TextSpan(
                    text: name ?? "",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic)),
              ]),
        ),
        backgroundColor: AppColor.biru1,
        actions: [
          TextButton.icon(
            onPressed: logout,
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      // body: Container(
      //   child: ListView.builder(
      //     itemCount: listAbsenMasuk.length,
      //     itemBuilder: (context, index) {
      //       DateTime jamMasuk =
      //       DateTime.parse(listAbsenMasuk[index]['jam_masuk']);
      //       DateTime batasWaktu =
      //       DateTime(jamMasuk.year, jamMasuk.month, jamMasuk.day, 8, 15);
      //       bool terlambat = jamMasuk.isAfter(batasWaktu);
      //
      //       return Wrap(
      //         direction: Axis.horizontal,
      //         children: List.generate(listAbsenMasuk.length, (index) => Text(listAbsenMasuk[index]['peserta']['nama_pgl'])).toList(),
      //       );
      //     },
      //   ),
      // ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                        enlargeCenterPage: false,
                        viewportFraction: 1.0,
                        autoPlay: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        }),
                    items: List.generate(
                        listGambar.length > 5 ? 5 : listGambar.length,
                        (index) => Container(
                              width: MediaQuery.of(context).size.width,
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade100),
                              child: Image.network(
                                  ApiConstants.BASE_URL + listGambar[index]['image'],
                                  fit: BoxFit.cover),
                            )).toList(),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: listGambar
                        .getRange(
                            0, listGambar.length > 5 ? 5 : listGambar.length)
                        .map((url) {
                      int index = listGambar.indexOf(url);
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? const Color.fromRGBO(0, 0, 0, 0.9)
                              : const Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),

                  //Piket Hari Ini
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Piket Hari ini",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ListPiket(),
                              ),
                            );
                          },
                          child: const Text("More"),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DateFormat('EEEE', 'id_ID').format(DateTime.now()) ==
                                "Sabtu" ||
                            DateFormat('EEEE', 'id_ID')
                                    .format(DateTime.now()) ==
                                "Minggu"
                        ? const Center(
                            child: Text(
                              "Sabtu dan Minggu tidak ada piket",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic),
                            ),
                          )
                        : listPiket.isEmpty
                            ? const Center(
                                child: Text(
                                  "Tidak ada piket hari ini",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              )
                            : Wrap(
                                children: [
                                  ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: listPiket.length,
                                    itemBuilder: (context, index) {
                                      // Membandingkan dengan listPiket[index]['hari']
                                      if (listPiket[index]['hari']
                                              .toLowerCase() ==
                                          today.toLowerCase()) {
                                        String nama = '';
                                        if (listPiket[index]['pembimbing'] !=
                                            null) {
                                          nama = listPiket[index]['pembimbing']
                                                  ['nama'] ??
                                              '';
                                        } else if (listPiket[index]
                                                ['peserta'] !=
                                            null) {
                                          nama = listPiket[index]['peserta']
                                                  ['nama'] ??
                                              '';
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.circle,
                                                    color: Colors.black54,
                                                    size: 10,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    nama,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                  if (listPiket.every((element) =>
                                      element['hari'].toLowerCase() !=
                                      today.toLowerCase()))
                                    const Center(
                                      child: Text(
                                        "Tidak ada piket hari ini",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                ],
                              ),
                  ),
                  const SizedBox(height: 15),

                  // Peserta Yang Masuk
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Peserta yang Masuk",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: listAbsenMasuk.isEmpty
                        ? const Center(
                            child: Text(
                              "Belum ada yang mengambil Absen",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        : Wrap(
                            direction: Axis.horizontal,
                            children:
                                List.generate(listAbsenMasuk.length, (index) {
                              if (listAbsenMasuk[index]['peserta']['status'] ==
                                  'aktif') {
                                return Container(
                                  margin: const EdgeInsetsDirectional.symmetric(
                                    horizontal: 3,
                                    vertical: 5,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColor.biru1,
                                  ),
                                  child: Text(
                                    listAbsenMasuk[index]['peserta']
                                        ['nama_pgl'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }).toList(),
                          ),
                  ),
                  const SizedBox(height: 15),

                  //Peserta Yang Terlambat
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("Peserta yang Terlambat",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: listAbsenMasuk.isEmpty ||
                            listAbsenMasuk.every((item) {
                              DateTime jamMasuk =
                                  DateTime.parse(item['jam_masuk']);
                              DateTime batasWaktu = DateTime(jamMasuk.year,
                                  jamMasuk.month, jamMasuk.day, 8, 15);
                              return jamMasuk.isBefore(batasWaktu);
                            })
                        ? const Center(
                            child: Text(
                            "Tidak ada peserta yang terlambat",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontStyle: FontStyle.italic),
                          ))
                        : Wrap(
                            direction: Axis.horizontal,
                            children:
                                List.generate(listAbsenMasuk.length, (index) {
                              DateTime jamMasuk = DateTime.parse(
                                  listAbsenMasuk[index]['jam_masuk']);
                              DateTime batasWaktu = DateTime(jamMasuk.year,
                                  jamMasuk.month, jamMasuk.day, 8, 15);
                              bool terlambat = jamMasuk.isAfter(batasWaktu);

                              if (terlambat &&
                                  listAbsenMasuk[index]['peserta']['status'] ==
                                      'aktif') {
                                return Container(
                                  margin: const EdgeInsetsDirectional.symmetric(
                                      horizontal: 3,
                                      vertical: 5,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColor.biru1),
                                  child: Text(
                                    listAbsenMasuk[index]['peserta']
                                        ['nama_pgl'],
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                );
                              } else {
                                return const Text("");
                              }
                            }).toList(),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}

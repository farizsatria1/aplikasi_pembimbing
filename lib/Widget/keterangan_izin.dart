import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Page/Absensi/absensi_peserta.dart';
import 'color.dart';

class KeteranganIzin extends StatelessWidget {
  const KeteranganIzin(
      {Key? key, required this.listKeterangan, required this.widget, required this.listMasuk})
      : super(key: key);

  final List listKeterangan;
  final List listMasuk;
  final AbsensiPage widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: AppColor.biru1,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        "Keterangan Izin",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Divider(
                      color: Colors.white,
                      thickness: 5,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CardKeterangan(
                          title: "Masuk",
                          subtitle: listMasuk.length.toString(),
                        ),
                        CardKeterangan(
                            title: "Izin",
                            //Menghitung Jumlah Keterangan Izin
                            subtitle: listKeterangan
                                .where((element) =>
                                    element["keterangan"] == "Izin")
                                .toList()
                                .length
                                .toString()),
                        CardKeterangan(
                          title: "Sakit",
                          //Menghitung Jumlah Keterangan Izin
                          subtitle: listKeterangan
                              .where(
                                  (element) => element["keterangan"] == "Sakit")
                              .toList()
                              .length
                              .toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listKeterangan.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 3),
                            color: AppColor.biru4),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          title: Text(
                            "Keterangan : " +
                                (listKeterangan[index]["keterangan"] ?? " - "),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  listKeterangan[index]["catatan"] ?? " - ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  DateFormat('dd MMMM yyyy').format(
                                      DateTime.parse(
                                          listKeterangan[index]["created_at"])),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CardKeterangan extends StatelessWidget {
  const CardKeterangan({
    Key? key, // Perbaiki penambahan parameter key yang hilang
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Text(
          subtitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

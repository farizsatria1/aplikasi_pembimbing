import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../Page/Absensi/absensi_peserta.dart';
import 'color.dart';

class AbsensiMasuk extends StatelessWidget {
  const AbsensiMasuk({
    Key? key,
    required this.listAbsenMasuk,
    required this.widget,
    required this.listAbsenPulang,
    required this.refresh,
  });

  final List listAbsenMasuk;
  final AbsensiPage widget;
  final List listAbsenPulang;
  final Function refresh;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id_ID', null);

    Map<String, List> groupedAbsen = {};

    listAbsenMasuk.forEach((element) {
      DateTime tglMasuk = DateTime.parse(element["tgl_masuk"]);
      String bulan = DateFormat('MMMM yyyy', 'id_ID').format(tglMasuk);
      if (groupedAbsen[bulan] == null) {
        groupedAbsen[bulan] = [];
      }
      groupedAbsen[bulan]!.add(element);
    });

    return FutureBuilder(
      future: refresh(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.biru1),
          );
        } else {
          if (groupedAbsen.isEmpty) {
            return Center(
              child: Text(
                "Data absensi tidak ada",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: groupedAbsen.length,
              itemBuilder: (context, index) {
                String bulan = groupedAbsen.keys.elementAt(index);
                List bulanAbsen = groupedAbsen[bulan]!;
                return ExpansionTile(
                  iconColor: Colors.black,
                  textColor: Colors.black,
                  leading: Icon(Icons.date_range),
                  title: Text(
                    bulan,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  children: bulanAbsen.map((element) {
                    DateTime tglMasuk = DateTime.parse(element["tgl_masuk"]);
                    String formattedDate =
                        DateFormat('dd MMMM yyyy', 'id_ID').format(tglMasuk);
                    String formattedDay =
                        DateFormat.EEEE('id_ID').format(tglMasuk);

                    String formatJamMasuk = DateFormat('HH:mm')
                        .format(DateTime.parse(element["jam_masuk"]));
                    String formatJamPulang = '';

                    if (listAbsenPulang.isNotEmpty) {
                      for (var i = 0; i < listAbsenPulang.length; i++) {
                        DateTime tglPulang =
                            DateTime.parse(listAbsenPulang[i]["tgl_pulang"]);
                        if (tglPulang.day == tglMasuk.day &&
                            tglPulang.month == tglMasuk.month &&
                            tglPulang.year == tglMasuk.year) {
                          formatJamPulang = DateFormat('HH:mm').format(
                              DateTime.parse(listAbsenPulang[i]["jam_pulang"]));
                          break;
                        }
                      }
                    }

                    if (formatJamPulang.isEmpty) {
                      formatJamPulang = "_:_";
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Colors.grey.shade300,
                                    title: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            formattedDate,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Divider(
                                          color: Colors.black,
                                          thickness: 3,
                                        ),
                                      ],
                                    ),
                                    content: Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              AlertJam(
                                                ket: "Masuk",
                                                jam: formatJamMasuk,
                                              ),
                                              AlertJam(
                                                ket: "Pulang",
                                                jam: formatJamPulang,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Divider(
                                            color: Colors.black,
                                            thickness: 3,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "Lokasi Absen Masuk : ",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            listAbsenMasuk[index]['alamat'],
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            "Lokasi Absen Pulang : ",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(formatJamPulang == "_:_" ?
                                          "--" : listAbsenPulang[index]['alamat'],
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            title: Text(
                              formattedDay,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(
                              formattedDate,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            trailing: formatJamPulang == "_:_"
                                ? Icon(
                                    CupertinoIcons.exclamationmark_circle,
                                    color: Colors.red,
                                    size: 30,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            );
          }
        }
      },
    );
  }
}

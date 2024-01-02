import 'package:flutter/material.dart';
import '../../../Api/api.dart';
import '../../../Widget/color.dart';

class StatusAktif extends StatelessWidget {
  final List status;

  const StatusAktif({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Api.getListPeserta(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.biru1),
          );
        } else if (snapshot.hasData) {

          final reversedList = status.reversed.toList();
          var dataProgress = reversedList.where((element) {
            return element['status'] == 'aktif';
          }).toList();

          if (dataProgress.isEmpty) {
            return const Center(child: Text('Tidak ada Peserta'));
          } else {
            return ListView.builder(
              itemCount: dataProgress.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    shadowColor: Colors.black,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: dataProgress[index]['status'] == "aktif"
                              ? Colors.green
                              : Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dataProgress[index]['nama'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                dataProgress[index]['asal_sekolah'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Text(
                                    "Status : ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    dataProgress[index]['status']
                                        .toString()
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                    ),
                  ),
                );
              },
            );
          }
        } else {
          return const Center(
            child: Text('Tidak ada peserta'),
          );
        }
      },
    );
  }
}

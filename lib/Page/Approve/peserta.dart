import 'package:flutter/material.dart';
import 'package:pembimbing_magang/Page/Approve/progress_approve.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Api/api.dart';
import '../../Widget/color.dart';

class Peserta extends StatefulWidget {
  const Peserta({super.key});

  @override
  State<Peserta> createState() => _PesertaState();
}

class _PesertaState extends State<Peserta> {
  List<dynamic> listProgressAll = [];
  late SharedPreferences prefs;
  Set<int> uniqueIds = Set<int>(); // Set to keep track of unique IDs

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> getAllProgress() async {
    try {
      final response = await Api.getAllProgress();
      setState(() {
        listProgressAll = response;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getAllProgress();
    initializeSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColor.biru1,
        title: Text("Approve",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: Api.getAllProgress(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.biru1),
            );
          } else if (snapshot.hasData) {
            int idPembimbing = prefs.getInt('id') ?? 0;
            var dataProgress = listProgressAll.where((element) {
              return element["trainer_pembimbing"] == idPembimbing &&
                  element['pekerjaan']['peserta']['status'] == "aktif" &&
                  element['pekerjaan']['peserta']['id_pembimbing'] != idPembimbing &&
                  uniqueIds.add(element['pekerjaan']['peserta']['id']);
            }).toList();

            if (dataProgress.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tidak ada list peserta yang di tangani',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColor.biru4),
                      child: Text(
                        'Jika anda sudah jadi trainer,pastikan peserta \n'
                            'yang anda tangani sudah input progress dengan \n'
                            'mencantumkan nama anda sebagai trainer.',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15),
                itemCount: dataProgress.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApproveProgress(
                            id: dataProgress[index]['pekerjaan']['peserta']
                            ['id'],
                          ),
                        )),
                    child: Card(
                      margin: EdgeInsets.only(top: 20),
                      color: Colors.blue,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          dataProgress[index]['pekerjaan']['peserta']['nama'],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          } else {
            return Center(
              child: Text(
                "Tidak ada progress",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

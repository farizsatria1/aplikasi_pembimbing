import 'package:flutter/material.dart';
import 'package:pembimbing_magang/Page/Status%20Peserta/widgets/aktif.dart';
import 'package:pembimbing_magang/Page/Status%20Peserta/widgets/non_aktif.dart';
import '../../Api/api.dart';
import '../../Widget/color.dart';

class StatusPeserta extends StatefulWidget {
  const StatusPeserta({super.key});

  @override
  State<StatusPeserta> createState() => _StatusPesertaState();
}

class _StatusPesertaState extends State<StatusPeserta> {
  List<dynamic> pesertaList = [];

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

  @override
  void initState() {
    super.initState();
    getListPeserta();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Status Peserta",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
          ),
          backgroundColor: AppColor.biru1,
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "Aktif"),
                  Tab(text: "Non-aktif"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    StatusAktif(
                      status: pesertaList,
                    ),
                    StatusNonAktif(
                      status: pesertaList,
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pembimbing_magang/Widget/recap.dart';
import '../../Api/api.dart';
import '../../Widget/color.dart';
import '../../Widget/hari_ini.dart';
import '../../Widget/kemarin.dart';

class ProgressPeserta extends StatefulWidget {
  final int id;

  const ProgressPeserta({Key? key, required this.id}) : super(key: key);

  @override
  State<ProgressPeserta> createState() => _ProgressPesertaState();
}

class _ProgressPesertaState extends State<ProgressPeserta> {
  List<dynamic> listProgressHariIni = [];
  List<dynamic> listProgressKemarin = [];
  List<dynamic> listProgressAll = [];

  Future<void> getProgress() async {
    List<dynamic> filteredList = await Api.getDataProgress(widget.id);
    if (filteredList.isNotEmpty) {
      String targetDate =
          filteredList.last["created_at"].toString().split('T')[0];
      filteredList = filteredList
          .where((element) =>
              element["created_at"].toString().split('T')[0] == targetDate)
          .toList();
    }
    setState(() {
      listProgressHariIni = filteredList;
    });
  }

  Future<void> getProgressKemarin() async {
    List<dynamic> filteredList = await Api.getDataProgress(widget.id);
    if (filteredList.isNotEmpty) {
      DateTime now = DateTime.now();
      DateTime yesterday =
          DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1));
      String yesterdayDate = yesterday.toIso8601String().split('T')[0];
      filteredList = filteredList
          .where((element) =>
              element["created_at"].toString().split('T')[0] == yesterdayDate)
          .toList();
    }
    setState(() {
      listProgressKemarin = filteredList;
    });
  }

  Future<void> getAllProgress() async {
    try {
      final response = await Api.getDataProgress(widget.id);
      setState(() {
        listProgressAll = response;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _refreshData() async {
    await getProgress();
    await getProgressKemarin();
    await getAllProgress();
  }

  @override
  void initState() {
    super.initState();
    getProgress();
    getProgressKemarin();
    getAllProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Pogress Peserta",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColor.biru1,
        elevation: 0,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: Colors.black,
          child: DefaultTabController(
            length: 3, // Jumlah tab
            child: Column(
              children: [
                const TabBar(
                  indicatorColor: Colors.black,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'Hari Ini'),
                    Tab(text: 'Kemarin'),
                    Tab(text: 'Recap'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Tampilan konten untuk tab 'Hari Ini'
                      HariIni(
                          listProgressHariIni: listProgressHariIni,
                          id: widget.id),
                      // Tampilan konten untuk tab 'Kemarin'
                      Kemarin(
                          listProgressKemarin: listProgressKemarin,
                          id: widget.id),
                      // Tampilan konten untuk tab 'Recap'
                      AllProgress(
                          listProgressAll: listProgressAll, id: widget.id),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

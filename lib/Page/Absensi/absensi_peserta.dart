import 'package:flutter/material.dart';
import 'package:pembimbing_magang/Widget/keterangan_izin.dart';
import '../../Api/api.dart';
import '../../Widget/absensi.dart';
import '../../Widget/color.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Widget/url.dart';

class AbsensiPage extends StatefulWidget {
  final int id;
  final String nama;

  const AbsensiPage({Key? key, required this.id, required this.nama})
      : super(key: key);

  @override
  State<AbsensiPage> createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage> {
  List<dynamic> listAbsenMasuk = [];
  List<dynamic> listAbsenPulang = [];
  List<dynamic> listKeterangan = [];
  late Uri websiteUri;


  Future<void> getListMasuk() async {
    try {
      final response = await Api.getMasuk(widget.id);
      setState(() {
        listAbsenMasuk = response;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getListPulang() async {
    try {
      final response = await Api.getPulang(widget.id);
      setState(() {
        listAbsenPulang = response;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getListKeterangan() async {
    try {
      final response = await Api.getListKeterangan(widget.id);
      setState(() {
        listKeterangan = response;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> url() async {
    setState(() {
      websiteUri = Uri.parse(ApiConstants.cetakAbsen + "${widget.id}");
    });
  }

  @override
  void initState() {
    url();
    getListMasuk();
    getListPulang();
    getListKeterangan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.nama,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColor.biru1,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              launchUrl(
                websiteUri,
                mode: LaunchMode.externalApplication,
              );
            },
            icon: const Icon(Icons.print,color: Colors.white),
          )
        ],
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'Absensi'),
                  Tab(text: 'Recap'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Tampilan konten untuk tab 'Absensi'
                    AbsensiMasuk(
                      listAbsenMasuk: listAbsenMasuk,
                      widget: widget,
                      listAbsenPulang: listAbsenPulang,
                      refresh: () async {
                        await Future.delayed(const Duration(seconds: 1));
                      },
                    ),

                    // Tampilan konten untuk tab 'Recap'
                    KeteranganIzin(
                      listMasuk: listAbsenMasuk,
                      listKeterangan: listKeterangan,
                      widget: widget,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlertJam extends StatelessWidget {
  final String ket;
  final String jam;

  const AlertJam({
    Key? key,
    required this.jam,
    required this.ket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          ket,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          jam != null ? jam : '_:_',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

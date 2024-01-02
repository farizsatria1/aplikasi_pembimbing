import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import '../Api/api.dart';
import 'color.dart';

class ListPiket extends StatefulWidget {
  const ListPiket({Key? key}) : super(key: key);

  @override
  State<ListPiket> createState() => _ListPiketState();
}

class _ListPiketState extends State<ListPiket> {
  late List<dynamic> listPiket;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getPiket();
  }

  Future<void> getPiket() async {
    setState(() {
      isLoading = true; // Set isLoading to false on error as well
    });

    try {
      final response = await Api.getPiket();
      setState(() {
        listPiket = response;
        isLoading = false; // Set isLoading to false after data is loaded
      });
    } catch (e) {
      print(e);
      // Handle the error, e.g., show an error message
      setState(() {
        isLoading = false; // Set isLoading to false on error as well
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.biru1,
        centerTitle: true,
        title: Text(
          "Jadwal Piket",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Image.asset(
              "images/lauwba.png",
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              "Berikut Daftar Piket \n "
                  "PT.Lauwba Techno Indonesia",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15),
            Accordion(
              paddingBetweenOpenSections: 20,
              headerBorderRadius: 10,
              paddingListTop: 30,
              paddingListBottom: 0,
              headerBackgroundColor: AppColor.biru1,
              headerBorderColor: AppColor.biru1,
              headerBorderColorOpened: Colors.transparent,
              headerBackgroundColorOpened: AppColor.biru1,
              contentBackgroundColor: Colors.blue,
              contentBorderColor: AppColor.biru1,
              scaleWhenAnimating: true,
              openAndCloseAnimation: true,
              headerPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              children: List.generate(5, (index) {
                String currentDay = getDayName(index);

                return AccordionSection(
                  header: Text(
                    currentDay,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  content: (listPiket
                      .where((item) =>
                  item['hari'].toLowerCase() ==
                      currentDay.toLowerCase())
                      .isEmpty)
                      ? Text(
                    "Tidak ada data piket",
                    style: TextStyle(color: Colors.white),
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: listPiket
                        .where((item) =>
                    item['hari'].toLowerCase() ==
                        currentDay.toLowerCase())
                        .map<Widget>((hari) {
                      String nama = hari['peserta'] != null
                          ? hari['peserta']['nama']
                          : hari['pembimbing']['nama'];

                      return SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle,
                                  color: Colors.white, size: 10),
                              SizedBox(width: 5),
                              Text(
                                nama,
                                style: TextStyle(
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
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  String getDayName(int index) {
    switch (index) {
      case 0:
        return 'Senin';
      case 1:
        return 'Selasa';
      case 2:
        return 'Rabu';
      case 3:
        return 'Kamis';
      case 4:
        return 'Jumat';
      default:
        return '';
    }
  }
}

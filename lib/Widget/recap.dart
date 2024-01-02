import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pembimbing_magang/Widget/url.dart';
import '../Api/api.dart';
import 'color.dart';
import 'fullscreen_photo.dart';

class AllProgress extends StatefulWidget {
  const AllProgress({
    Key? key,
    required this.listProgressAll,
    required this.id,
  }) : super(key: key);

  final int id;
  final List listProgressAll;

  @override
  _AllProgressState createState() => _AllProgressState();
}

class _AllProgressState extends State<AllProgress> {
  String selectedMonth = 'All'; // Set 'All' as the default option

  List<DropdownMenuItem<String>> getDropdownItems() {
    List<String> months = widget.listProgressAll
        .map((progress) =>
        DateFormat('MMMM yyyy','id_ID').format(DateTime.parse(progress["created_at"])))
        .toSet()
        .toList();

    // Include 'All' as the first option in the dropdown
    months.insert(0, 'All');

    return months.map((String month) {
      return DropdownMenuItem<String>(
        value: month,
        child: Text(month),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id_ID', null);

    // Filter data based on selected month
    List filteredList = selectedMonth == 'All'
        ? widget.listProgressAll
        : widget.listProgressAll.where((progress) {
      String month = DateFormat('MMMM yyyy','id_ID').format(
        DateTime.parse(progress["created_at"]),
      );
      return month == selectedMonth;
    }).toList();

    return Column(
      children: [
        // Dropdown for selecting month
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(20)
          ),
          child: DropdownButton<String>(
            borderRadius: BorderRadius.circular(20),
            padding: EdgeInsets.symmetric(horizontal: 20),
            underline: SizedBox(),
            value: selectedMonth,
            onChanged: (String? newValue) {
              setState(() {
                selectedMonth = newValue!;
              });
            },
            items: getDropdownItems(),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: Api.getDataProgress(widget.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: AppColor.biru1),
                );
              } else {
                if (filteredList.isEmpty) {
                  return Center(
                    child: Text(
                      "Tidak ada progress",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  );
                } else {
                  final reversedList = filteredList.reversed.toList();
                  return ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    itemCount: reversedList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border:
                            Border.all(color: Colors.grey, width: 0.5),
                          ),
                          child: ListTile(
                            onTap: () {
                              showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20))),
                                useSafeArea: true,
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                context: context,
                                builder: (context) {
                                  return Container(
                                    constraints: BoxConstraints(
                                        maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.75),
                                    padding: EdgeInsets.all(15),
                                    child: ListView(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      GambarProgress(
                                                        gambar: ApiConstants.BASE_URL +
                                                            reversedList[
                                                            index][
                                                            "foto_dokumentasi"] ??
                                                            "",
                                                      )),
                                            );
                                          },
                                          child: Image.network(
                                            ApiConstants.BASE_URL +
                                                reversedList[index]
                                                ["foto_dokumentasi"] ??
                                                "",
                                            height: 250,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Center(
                                                child: Icon(
                                                  CupertinoIcons.photo_fill,
                                                  size: 100,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          reversedList[index]["pekerjaan"]
                                          ["judul"],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        reversedList[index]["pembimbing"] ==
                                            null
                                            ? Text(
                                          "Trainer : " +
                                              (reversedList[index]
                                              ["peserta"]["nama"]),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        )
                                            : Text(
                                          "Trainer : " +
                                              (reversedList[index]
                                              ["pembimbing"]["nama"]),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('dd MMMM yyyy', 'id_ID')
                                              .format(DateTime.parse(
                                              reversedList[index]
                                              ["created_at"])),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          reversedList[index]["catatan"],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reversedList[index]["pekerjaan"]["judul"],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  DateFormat('dd MMMM yyyy','id_ID').format(
                                      DateTime.parse(reversedList[index]["created_at"])),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                            subtitle: Text(
                              reversedList[index]["catatan"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(ApiConstants.BASE_URL +
                                    reversedList[index]["foto_dokumentasi"] ?? "",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      CupertinoIcons.photo_fill,
                                      size: 30,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }
            },
          ),
        ),
      ],
    );
  }
}

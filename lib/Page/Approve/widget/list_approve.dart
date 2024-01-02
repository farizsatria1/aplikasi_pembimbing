import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Api/api.dart';
import '../../../Widget/color.dart';
import '../../../Widget/fullscreen_photo.dart';
import '../../../Widget/url.dart';

class ListApprove extends StatefulWidget {
  final int id;
  final List listProgress;

  const ListApprove(
      {super.key, required this.listProgress,required this.id});

  @override
  State<ListApprove> createState() => _ListApproveState();
}

class _ListApproveState extends State<ListApprove> {
  late SharedPreferences prefs;

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    initializeSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Api.getDataProgress(widget.id),
      builder: (context, snapshoot) {
        if (snapshoot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.biru1),
          );
        } else {
          if (widget.listProgress.isEmpty) {
            return Center(
              child: Text(
                "Tidak ada progress",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          } else {
            int idPembimbing = prefs.getInt('id') ?? 0;
            var dataProgress = widget.listProgress.where((element) {
              return element["status"] == "1" &&
              element["trainer_pembimbing"] == idPembimbing;
            }).toList();

            if(dataProgress.isEmpty){
              return Center(child: Text('Tidak ada data'));
            } else {
              return ListView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: dataProgress.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey, width: 0.5)),
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
                                                        dataProgress[index][
                                                        "foto_dokumentasi"] ??
                                                        "",
                                                  )),
                                        );
                                      },
                                      child: Image.network(
                                        ApiConstants.BASE_URL +
                                            dataProgress[index]
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
                                      dataProgress[index]["pekerjaan"]["judul"],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    dataProgress[index]["pembimbing"] == null
                                        ? Text(
                                      "Trainer : " +
                                          (dataProgress[index]["peserta"]
                                          ["nama"]),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    )
                                        : Text(
                                      "Trainer : " +
                                          (dataProgress[index]["pembimbing"]
                                          ["nama"]),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('dd MMMM yyyy', 'id_ID').format(
                                          DateTime.parse(
                                              dataProgress[index]["created_at"])),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      dataProgress[index]["catatan"],
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
                              dataProgress[index]["pekerjaan"]["judul"],
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              DateFormat('dd MMMM yyyy', 'id_ID').format(
                                  DateTime.parse(
                                      dataProgress[index]["created_at"])),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                        subtitle: Text(
                          dataProgress[index]["catatan"],
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
                            child: Image.network(
                              ApiConstants.BASE_URL +
                                  dataProgress[index]["foto_dokumentasi"] ??
                                  "",
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
        }
      },
    );
  }
}

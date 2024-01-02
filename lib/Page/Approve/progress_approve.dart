import 'package:flutter/material.dart';
import 'package:pembimbing_magang/Page/Approve/widget/list_approve.dart';
import 'package:pembimbing_magang/Page/Approve/widget/list_progress.dart';
import 'package:pembimbing_magang/Page/Approve/widget/list_tolak.dart';
import 'package:pembimbing_magang/Widget/color.dart';
import '../../Api/api.dart';

class ApproveProgress extends StatefulWidget {
  final int id;
  const ApproveProgress({super.key, required this.id});

  @override
  State<ApproveProgress> createState() => _ApproveProgressState();
}

class _ApproveProgressState extends State<ApproveProgress> {
  List<dynamic> listProgressAll = [];

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


  @override
  void initState() {
    getAllProgress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColor.biru1,
        title: Text("Pogress Approve",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        elevation: 0,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: "Progress"),
                Tab(text: "Approve"),
                Tab(text: "Tolak"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListProgress(
                    id: widget.id,
                    listProgress: listProgressAll,
                  ),
                  ListApprove(
                    id: widget.id,
                    listProgress: listProgressAll,
                  ),
                  ListTolak(
                    id: widget.id,
                    listProgress: listProgressAll,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pembimbing_magang/Page/dokumentasi.dart';
import 'package:pembimbing_magang/Page/list_peserta.dart';
import 'Page/Approve/peserta.dart';
import 'Page/home_page.dart';
import 'Widget/color.dart';

class NavBar extends StatefulWidget {
  final int selectedIndex;
  NavBar({required this.selectedIndex});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int selected = 0;

  final List<Widget> pages = [
    const HomePage(),
    const ListPeserta(),
    const Peserta(),
    const Dokumentasi()
  ];

  @override
  void initState() {
    super.initState();
    selected = widget.selectedIndex; // Gunakan selectedIndex dari widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[selected], // Tampilkan halaman yang sesuai berdasarkan indeks terpilih
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home_filled),label: "Home"),
            const BottomNavigationBarItem(icon: Icon(CupertinoIcons.list_bullet),label: "Peserta"),
            const BottomNavigationBarItem(icon: Icon(CupertinoIcons.check_mark_circled_solid),label: "Approve"),
            const BottomNavigationBarItem(icon: Icon(Icons.image),label: "Dokumentasi"),
          ],
          currentIndex: selected,
          backgroundColor: AppColor.biru1,
          selectedItemColor: Colors.white,
          unselectedItemColor: AppColor.biru4,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          onTap: (value) {
            setState(() {
              selected = value;
            });
          },
        )
    );
  }
}
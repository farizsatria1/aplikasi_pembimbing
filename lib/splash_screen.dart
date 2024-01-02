import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pembimbing_magang/Widget/color.dart';
import 'package:pembimbing_magang/login_page.dart';
import 'package:pembimbing_magang/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  splashScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  prefs.getInt('id') != null ? NavBar(selectedIndex: 0) : LoginPage(),
            ));
      },
    );
  }

  @override
  void initState() {
    splashScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/lauwba.png',
                width: 150, height: 150, fit: BoxFit.cover),
            SizedBox(height: 50),
            Text(
              "PEMBIMBING",
              style: TextStyle(
                  color: AppColor.biru1,
                  decoration: TextDecoration.underline,
                  fontStyle: FontStyle.italic,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

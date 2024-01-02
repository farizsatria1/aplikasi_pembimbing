import 'package:flutter/material.dart';
import 'package:pembimbing_magang/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home:  SplashScreen(),
    );
  }
}

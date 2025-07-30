import 'package:flutter/material.dart';

import 'pages/add_update_page.dart';
import 'pages/details_page.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoe Store',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFEFEFEF),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/details': (context) => const DetailsPage(),
        '/search': (context) => const SearchPage(),
        '/add': (context) => const AddUpdatePage(),
      },
    );
  }
}

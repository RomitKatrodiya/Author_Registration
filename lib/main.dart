import 'package:author_registration_app/screens/details_page.dart';
import 'package:author_registration_app/screens/edit_add_author_page.dart';
import 'package:author_registration_app/screens/home_page.dart';
import 'package:author_registration_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "splash_screen",
      routes: {
        "splash_screen": (context) => const SplashScreen(),
        "/": (context) => const HomePage(),
        "edit_add_author_page": (context) => const EditAddAuthorPage(),
        "details_page": (context) => const DetailPage(),
      },
    ),
  );
}

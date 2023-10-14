// ignore_for_file: prefer_const_constructors, unused_import, camel_case_types

import 'package:contact/add_contact.dart';
import 'package:contact/controller/auth_service.dart';
import 'package:contact/homepage.dart';
import 'package:contact/loginpage.dart';
import 'package:contact/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.loraTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(134, 58, 228, 1)),
        useMaterial3: true,
      ),
      routes: {
        "/home": (context) => home(),
        "/": (context) => checkuser(),
        "/signup": (context) => signuppage(),
        "/login": (context) => loginpage(),
        "/add": (context) => addcontact(),
        
      },
      
      // home: contact(),
    );
  }
}
class checkuser extends StatefulWidget {
  const checkuser({super.key});

  @override
  State<checkuser> createState() => _checkuserState();
}

class _checkuserState extends State<checkuser> {

  @override
  void initState() {
    AuthService().isLoogedIn().then((value) {
      if(value){
        Navigator.pushReplacementNamed(context, '/home');
      }
      else{
        Navigator.pushReplacementNamed(context, '/login');

      }

    });
    // 
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child:CircularProgressIndicator() ,
    );
  }
}



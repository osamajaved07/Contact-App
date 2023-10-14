// ignore_for_file: camel_case_types, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:contact/main.dart';
import 'package:flutter/material.dart';


class splashcreen extends StatelessWidget {
  const splashcreen({Key? key});

  @override
  Widget build(BuildContext context) {
    // Add a delay of 2 seconds (2000 milliseconds)
    Future.delayed(Duration(seconds: 4), () {
      // Navigate to the "notes" screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => checkuser()));
    });

    return Scaffold(
      backgroundColor:Colors.purple[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/sp.png', width: 200,height: 200,),
            SizedBox(height: 24,),
            Text(
              'CONTACT',
              style: TextStyle(
                color: Colors.purple[900],
                fontSize: 36,
                fontWeight: FontWeight.w700,
              
              ),
            ),
            Text(
              'Welcome to contact app',
              style: TextStyle(
                color: Colors.deepPurple[300],
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            // Image.asset('images/sp.jpg', width: 100,height: 100,),
          ],
        ),
      ),
    );
  }
}
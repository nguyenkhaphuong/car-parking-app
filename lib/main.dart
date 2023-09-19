import 'dart:io';

import 'package:car_parking_system/pages/pages.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<int> _inputList = [];
  final List<File?> _images = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Parking System',
      debugShowCheckedModeBanner: false,
      home: CheckInScreen(
        inputList: _inputList,
        images: _images,
      ),
    );
  }
}

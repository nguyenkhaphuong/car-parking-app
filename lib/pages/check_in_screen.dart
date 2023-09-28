import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

//Import components
import '../components/components.dart';

//Import pages/screens
import '../pages/pages.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({
    Key? key,
    required this.inputList,
    required this.images,
  }) : super(key: key);

  final List<int> inputList;
  final List<File?> images;

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final TextEditingController _checkInController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final faceDetector = GoogleMlKit.vision.faceDetector();

  // Function to display an alert dialog
  Future<void> _showDialog(String title, String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to add number input and image captured from camera to a list view
  Future<void> _addData() async {
    if (!_validateInput()) return;

    final bool isGranted = await _requestPermission();
    if (!isGranted) return;

    final XFile? image = await _pickImage();
    if (image == null) return;

    int number = int.parse(_checkInController.text);

    final String capturedImage = image.path;
    final File capturedImageFile = File(capturedImage);

    final inputImage = InputImage.fromFilePath(capturedImage);

    final List<Face> newFaces = await faceDetector.processImage(inputImage);

    if (newFaces.isEmpty) {
      _showDialog(
        "No face detected",
        "No face was detected. Please try again!",
      );
      return;
    }

    // Compare the new image with all existing images
    for (var existingImage in widget.images) {
      final existingInputImage = InputImage.fromFilePath(existingImage!.path);
      final List<Face> existingFaces =
          await faceDetector.processImage(existingInputImage);

      if (_isFaceDuplicate(newFaces[0], existingFaces)) {
        _showDialog(
          "Duplicate Found",
          "A person with a similar face already exists. Try again.",
        );

        break;
      }
    }

    setState(() {
      widget.inputList.add(number);
      widget.images.add(capturedImageFile);
      _checkInController.clear();
    });
  }

  Future<XFile?> _pickImage() async {
    return await _picker.pickImage(source: ImageSource.camera);
  }

  // Request permission to access the device's camera.
  Future<bool> _requestPermission() async {
    Map<Permission, PermissionStatus> result =
        await [Permission.storage, Permission.camera].request();
    if (result[Permission.storage] == PermissionStatus.granted &&
        result[Permission.camera] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  // Boolean function to check for input validation
  bool _validateInput() {
    int? number = int.tryParse(_checkInController.text);

    if (number == null || number <= 0 || number > 100) {
      _showDialog(
        "Invalid Input",
        "Please enter a valid number between 1 and 100.",
      );
      _checkInController.clear();
      return false;
    }

    if (widget.inputList.contains(number)) {
      _showDialog(
        "Duplicated Number",
        "The number already exists. Please enter a new number.",
      );
      _checkInController.clear();
      return false;
    }

    return true;
  }

  bool _isFaceDuplicate(Face newFace, List<Face> existingFaces) {
    for (var existingFace in existingFaces) {
      if (_isSimilar(newFace.landmarks, existingFace.landmarks)) {
        return true;
      }
    }
    return false;
  }

  bool _isSimilar(
    Map<FaceLandmarkType, FaceLandmark?> newLandmarks,
    Map<FaceLandmarkType, FaceLandmark?> existingLandmarks,
  ) {
    double totalDistance = 0;
    int count = 0;

    for (var type in FaceLandmarkType.values) {
      if (newLandmarks.containsKey(type) &&
          existingLandmarks.containsKey(type)) {
        final newLandmark = newLandmarks[type];
        final existingLandmark = existingLandmarks[type];

        if (newLandmark != null && existingLandmark != null) {
          debugPrint(
              'New landmark type: $type, position: ${newLandmark.position}');
          debugPrint(
              'Existing landmark type: $type, position: ${existingLandmark.position}');

          final dx = newLandmark.position.x - existingLandmark.position.x;
          final dy = newLandmark.position.y - existingLandmark.position.y;

          debugPrint('dx: $dx');
          debugPrint('dy: $dy');

          final distance = sqrt(dx * dx + dy * dy);
          totalDistance += distance;
          count++;
        }
      }
    }

    if (count == 0) return false; // No common landmarks

    final averageDistance = totalDistance / count;
    return averageDistance < 50;
  }

  // Function to navigate to Check Out Screen when the 'Check Out' button is clicked
  void navigateToCheckOut() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CheckOutScreen(
          inputList: widget.inputList,
          images: widget.images,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _checkInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: "Check In"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0,
            vertical: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Number Text Field
              NumberTextField(
                controller: _checkInController,
                hintText: 'Enter your number',
              ),
              const SizedBox(height: 20),

              //Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                    label: 'Check In',
                    onPressed: _addData,
                    color: Colors.green,
                    icon: const Icon(Icons.login),
                  ),
                  const SizedBox(width: 10),
                  MyButton(
                    label: 'Check Out',
                    onPressed: navigateToCheckOut,
                    color: Colors.orange[800],
                    icon: const Icon(Icons.logout),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              //List View
              Expanded(
                child: NumberListView(
                  item: widget.inputList,
                  images: widget.images,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_face_api/face_api.dart';

import 'dart:io';
// import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

//Import components
import '../components/components.dart';

//Import pages/screens
import '../pages/pages.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({
    Key? key,
    required this.inputList,
    required this.images,
  }) : super(key: key);

  final List<int> inputList;
  final List<File?> images;

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final TextEditingController _checkOutController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

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

  // Function to check if the user is valid, and the picked image matches with the captured image
  void _checkData() async {
    if (!_validateInput()) return;

    final XFile? image = await _pickImage();
    if (image == null) return;

    int number = int.parse(_checkOutController.text);
    int index = widget.inputList.indexOf(number);

    final capturedImage = File(image.path);

    // Convert File to MatchFacesImage object
    MatchFacesImage convertFileToMatchFacesImage(File file) {
      List<int> imageBytes = file.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);

      var image = MatchFacesImage();
      image.bitmap = base64Image;

      return image;
    }

    // Compare the new image with all existing images
    var request = MatchFacesRequest();
    request.images = [
      convertFileToMatchFacesImage(capturedImage),
      convertFileToMatchFacesImage(widget.images[index]!),
    ];

    var response = await FaceSDK.matchFaces(jsonEncode([request]));
    var split = MatchFacesSimilarityThresholdSplit.fromJson(
        json.decode(response.results));

    if (split!.matchedFaces.isEmpty) {
      _showDialog(
        "No Match Found",
        "The entered data does not match. Try again!",
      );
      return;
    }

    setState(() {
      widget.inputList.removeAt(index);
      widget.images.removeAt(index);
      _checkOutController.clear();
    });

    _showDialog(
      "Match Found",
      "The entered data matches. Have a good day!",
    );
  }

  Future<XFile?> _pickImage() async {
    return await _picker.pickImage(source: ImageSource.camera);
  }

  // Boolean function to check for input validation
  bool _validateInput() {
    int? number = int.tryParse(_checkOutController.text);

    if (widget.inputList.isEmpty) {
      _showDialog(
        "All Clear",
        "Yay! No more guests. All Clear!",
      );
      _checkOutController.clear();
      return false;
    }

    if (number == null || number <= 0 || number > 100) {
      _showDialog(
        "Invalid Input",
        "Please enter a valid number between 1 and 100.",
      );
      _checkOutController.clear();
      return false;
    }

    if (!widget.inputList.contains(number)) {
      _showDialog(
        "Not Found",
        "The number you entered does not exist.",
      );
      _checkOutController.clear();
      return false;
    }

    return true;
  }

  // Function to navigate to Check In Screen when the 'Check In' button is clicked
  void navigateToCheckIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CheckInScreen(
          inputList: widget.inputList,
          images: widget.images,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _checkOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: "Check Out"),
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
                controller: _checkOutController,
                hintText: "Enter your number again",
              ),
              const SizedBox(height: 20),

              //Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                    onPressed: _checkData,
                    label: "Check Out",
                    color: Colors.orange[800],
                    icon: const Icon(Icons.logout),
                  ),
                  const SizedBox(width: 10),
                  MyButton(
                    onPressed: navigateToCheckIn,
                    label: "Check In",
                    color: Colors.green,
                    icon: const Icon(Icons.login),
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

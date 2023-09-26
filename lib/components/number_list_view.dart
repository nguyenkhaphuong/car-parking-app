import 'package:flutter/material.dart';
import 'dart:io';

class NumberListView extends StatefulWidget {
  const NumberListView({
    super.key,
    required this.item,
    required this.images,
  });

  final List<int> item;
  final List<File?> images;

  @override
  State<NumberListView> createState() => _NumberListViewState();
}

class _NumberListViewState extends State<NumberListView> {
  late List<int> items;
  late List<File?> images;

  @override
  void initState() {
    super.initState();
    items = widget.item;
    images = widget.images;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.item.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black38,
              width: 2,
            ),
            color: Colors.amber[400],
          ),
          child: ListTile(
            title: Text(
              'Your Check In Number: ${items[index].toString()}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            leading: CircleAvatar(
              backgroundImage: FileImage(images[index]!),
            ),
            onTap: () {
              _showDialog(context, index);
            },
          ),
        );
      },
    );
  }

  Future<dynamic> _showDialog(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Your Check In Number: ${items[index].toString()}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: FileImage(images[index]!),
                maxRadius: 120,
              ),
              const SizedBox(height: 20),
              Text('Your Check In Number: ${items[index].toString()}'),
            ],
          ),
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
}

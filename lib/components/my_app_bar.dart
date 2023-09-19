import 'package:car_parking_system/pages/pages.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    //Navigate to Info Screen
    void navigateToInfo() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const InfoScreen(),
        ),
      );
    }

    return AppBar(
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.directions_car_sharp,
            size: 30,
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 25,
            ),
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.info,
          size: 30,
        ),
        onPressed: navigateToInfo,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

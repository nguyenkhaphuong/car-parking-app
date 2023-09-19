import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  final String info =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In in massa ut enim commodo efficitur. Aenean eros enim, volutpat vitae sollicitudin ut, lacinia id ligula. Aliquam non erat lectus. Suspendisse at magna rutrum, pretium mi sit amet, placerat enim. Nullam ut rutrum neque, vel condimentum sem.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const InfoAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0,
            vertical: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.info,
                size: 145,
              ),
              const SizedBox(height: 10),
              Text(
                info,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const InfoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info,
            size: 30,
          ),
          SizedBox(width: 6),
          Text("Information"),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

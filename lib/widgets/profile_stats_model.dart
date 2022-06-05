import 'package:flutter/material.dart';

class StatsModel extends StatelessWidget {
  final String title, value;
  const StatsModel({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Rounded_Elegance'),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Rounded_Elegance'),
            ),
          ],
        ),
      );
  }
}

import 'package:flutter/material.dart';
import 'package:scribbles/classes/notificationservice.dart';
class TestWidget extends StatelessWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () async {
              await NotificationService().initNotification();
              // NotificationService().showNotification(1, 'test title', 'test body');
            },
            child: const Text(
              'show notification'
            ),
          ),
        )
      ),
    );
  }
}


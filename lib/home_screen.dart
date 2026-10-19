import 'package:flutter/material.dart';
import 'notification_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
            onTap: () => NotificationService.showNotification(
                  title: "This is the Title of the notification",
                  body: "This is the Body of the notification",
                ),
            child: const Text('Send Notification')),
      ),
    );
  }
}

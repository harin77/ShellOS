import 'package:flutter/material.dart';
import '../../app_launcher.dart';

/// A simple placeholder mock page representing an application.
/// Used when launching desktop apps or as internal demo pages.
class MockAppPage extends StatelessWidget {
  final dynamic app; // Can be DesktopApp or simple internal app

  const MockAppPage({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    final String title;
    final IconData icon;

    if (app is DesktopApp) {
      title = app.name;
      icon = Icons.apps;
    } else {
      title = app.toString();
      icon = Icons.android;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(children: [
          Icon(icon, size: 22),
          const SizedBox(width: 10),
          Text(title),
        ]),
      ),
      body: Center(
        child: Text(
          "This is $title",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}

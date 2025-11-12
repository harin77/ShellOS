import 'package:flutter/material.dart';
import '../linux_notifications.dart';
import '../app_launcher.dart';

/// Represents an internal Flutter app icon for the OS shell
class AppIcon {
  final String name;
  final IconData icon;

  AppIcon(this.name, this.icon);
}

/// AppModel: central state for the OS Shell.
class AppModel {
  // =====================================================
  // SYSTEM STATUS
  // =====================================================

  int battery = 0;
  bool wifi = true;
  bool mobile = false;
  bool bt = false;
  bool dnd = false;
  bool rotate = true;
  double brightness = 0.7;
  double volume = 0.5;
  int signal = 4;
  bool hotspot = false;

  // =====================================================
  // INTERNAL FLUTTER OS APPS (AppGrid)
  // =====================================================

  List<AppIcon> installed = [
    AppIcon('Phone', Icons.call),
    AppIcon('Messages', Icons.message),
    AppIcon('Camera', Icons.camera_alt),
    AppIcon('Gallery', Icons.photo),
    AppIcon('Files', Icons.folder),
    AppIcon('Browser', Icons.public),
    AppIcon('Clock', Icons.access_time),
    AppIcon('Settings', Icons.settings),
    AppIcon('Music', Icons.music_note),
    AppIcon('Notes', Icons.notes),
    AppIcon('Calendar', Icons.calendar_month),
  ];

  // =====================================================
  // DESKTOP LINUX APPS (from /usr/share/applications)
  // =====================================================

  List<DesktopApp> desktopApps = [];

  // =====================================================
  // RECENT APPS STACK
  // =====================================================

  final List<dynamic> recent = [];

  void pushRecent(dynamic app) {
    if (!recent.contains(app)) {
      recent.add(app);
    }
  }

  void popRecent() {
    if (recent.isNotEmpty) {
      recent.removeLast();
    }
  }

  void closeApp(dynamic app) {
    recent.remove(app);
  }

  // =====================================================
  // NOTIFICATIONS
  // =====================================================

  final List<IncomingNotification> notifications = [];

  void addNotification(IncomingNotification n) {
    notifications.insert(0, n);
    if (notifications.length > 20) {
      notifications.removeLast();
    }
  }

  void seedNotifications() {
    notifications.add(
      IncomingNotification(
        id: 1,
        appName: 'System',
        summary: 'Welcome',
        body: 'Mobile OS Shell started',
      ),
    );
  }
}
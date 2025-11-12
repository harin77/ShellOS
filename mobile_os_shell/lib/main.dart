import 'dart:io';
import 'package:flutter/material.dart';
import 'linux_bridge.dart';
import 'linux_notifications.dart';
import 'app_launcher.dart';
import 'models/app_model.dart';
import 'ui/lock/lock_screen.dart';
import 'ui/home/home_screen.dart';
import 'ui/notifications/notification_shade.dart';
import 'ui/quick_settings/quick_settings_panel.dart';
import 'ui/recents/recents_overlay.dart';
import 'ui/gestures/gesture_bar.dart';
import 'ui/status_bar/status_bar.dart';
import 'ui/apps/mock_app_page.dart';

void main() {
  runApp(const MobileOS());
}

class MobileOS extends StatelessWidget {
  const MobileOS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const BootGate(),
    );
  }
}

class BootGate extends StatefulWidget {
  const BootGate({super.key});

  @override
  State<BootGate> createState() => _BootGateState();
}

class _BootGateState extends State<BootGate> {
  bool unlocked = false;

  @override
  Widget build(BuildContext context) {
    return unlocked
        ? const Shell()
        : LockScreen(onUnlock: () => setState(() => unlocked = true));
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> with TickerProviderStateMixin {
  final AppModel model = AppModel();

  late AnimationController notifCtrl;
  late AnimationController qsCtrl;
  late AnimationController recentCtrl;

  NotificationServer server = NotificationServer();

  @override
  void initState() {
    super.initState();

    notifCtrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    qsCtrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    recentCtrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    _initSystem();
  }

  Future<void> _initSystem() async {
    // Start DBus notification server
    await server.start((note) {
      setState(() => model.addNotification(note));
    });

    // Load Linux desktop apps
    model.desktopApps = await AppLauncher.I.listApps();

    // Poll battery every 20 sec
    _pollBattery();
  }

  void _pollBattery() async {
    while (mounted) {
      final pct = await LinuxBridge.I.getBatteryPercent();
      setState(() => model.battery = pct);
      await Future.delayed(const Duration(seconds: 20));
    }
  }

  // -------------------------------------------------
  // openApp()
  // -------------------------------------------------
  Future<void> openApp(dynamic app) async {
    model.pushRecent(app);

    // Desktop Linux app
    if (app is DesktopApp) {
      await LinuxBridge.I.launchDesktopApp(app.exec);
      return;
    }

    // Internal Flutter mock app
    if (app is AppIcon) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MockAppPage(app: app)),
      );

      model.popRecent();
      return;
    }

    debugPrint("Unknown app type: $app");
  }

  void toggle(AnimationController c) =>
      c.isDismissed ? c.forward() : c.reverse();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          HomeScreen(
            model: model,
            onOpenApp: openApp,
            onOpenDrawer: () {},
          ),

          // ---- STATUS BAR ----
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: StatusBar(
              model: model,
              onNotif: () => toggle(notifCtrl),
              onQS: () => toggle(qsCtrl),

              // NEW callbacks for icons
              onWifi: () => toggle(qsCtrl),
              onMobile: () => toggle(qsCtrl),
              onBattery: () => toggle(qsCtrl),
            ),
          ),
          NotificationShade(controller: notifCtrl, model: model),
          QuickSettingsPanel(controller: qsCtrl, model: model),
          RecentAppsOverlay(
            controller: recentCtrl,
            model: model,
            onSelect: openApp,
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: GestureBar(
              onBack: () => Navigator.maybePop(context),
              onHome: () => Navigator.popUntil(context, (r) => r.isFirst),
              onRecents: () => toggle(recentCtrl),
            ),
          ),
        ],
      ),
    );
  }
}
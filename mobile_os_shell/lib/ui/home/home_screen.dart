import 'package:flutter/material.dart';
import '../../models/app_model.dart';
import '../home/widget_strip.dart';
import '../home/desktop_app_grid.dart';
import '../home/app_grid.dart';

class HomeScreen extends StatefulWidget {
  final AppModel model;
  final void Function(dynamic app) onOpenApp;
  final VoidCallback onOpenDrawer;

  const HomeScreen({
    super.key,
    required this.model,
    required this.onOpenApp,
    required this.onOpenDrawer,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding.top;

    // FILTER APPS
    final desktopFiltered = widget.model.desktopApps
        .where((a) => a.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    final internalApps = ['Phone', 'Messages', 'Camera'];
    final internalFiltered = internalApps
        .where((a) => a.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Stack(
      children: [
        // -----------------------------------
        // WALLPAPER
        // -----------------------------------
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/wallpaper.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(color: Colors.black.withOpacity(0.18)),
          ),
        ),

        // -----------------------------------
        // WIDGET STRIP
        // -----------------------------------
        Positioned(
          top: padding + 40,
          left: 16,
          right: 16,
          child: const WidgetStrip(),
        ),

        // -----------------------------------
        // SEARCH BAR
        // -----------------------------------
        Positioned(
          top: padding + 125,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white30),
            ),
            child: TextField(
              onChanged: (v) => setState(() => query = v),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                icon: Icon(Icons.search, color: Colors.white70),
                hintText: "Search apps...",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
          ),
        ),

        // -----------------------------------
        // APP GRID — FULL HEIGHT
        // -----------------------------------
        Positioned(
          top: padding + 175,
          left: 0,
          right: 0,
          bottom: 0, // FULL SCREEN → no extra space
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: desktopFiltered.isNotEmpty
                ? DesktopAppGrid(
                    apps: desktopFiltered,
                    onOpen: (a) => widget.onOpenApp(a),
                  )
                : AppGrid(
                    apps: internalFiltered,
                    onOpen: (a) => widget.onOpenApp(a),
                  ),
          ),
        ),

        // -----------------------------------
        // BOTTOM DRAWER HANDLE
        // -----------------------------------
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
                 child: GestureDetector(
              onTap: widget.onOpenDrawer,
              child: Container(
                width: 90,
                height: 7,
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import '../../app_launcher.dart';

/// Very compact Android-style App Grid
class AppGrid extends StatelessWidget {
  final List<dynamic> apps;
  final void Function(dynamic app) onOpen;

  const AppGrid({
    super.key,
    required this.apps,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),

      physics: const BouncingScrollPhysics(),

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 10,        // 👈 10 apps per row
        childAspectRatio: 0.62,    // 👈 tighter vertical spacing
        crossAxisSpacing: 4,       // 👈 closer icons horizontally
        mainAxisSpacing: 2,        // 👈 minimal vertical space between rows
      ),

      itemCount: apps.length,

      itemBuilder: (_, i) => _GridIcon(
        app: apps[i],
        onOpen: () => onOpen(apps[i]),
      ),
    );
  }
}

class _GridIcon extends StatefulWidget {
  final dynamic app;
  final VoidCallback onOpen;

  const _GridIcon({
    required this.app,
    required this.onOpen,
  });

  @override
  State<_GridIcon> createState() => _GridIconState();
}

class _GridIconState extends State<_GridIcon> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final String name =
        widget.app is DesktopApp ? widget.app.name : widget.app.toString();

    return Column(
      mainAxisSize: MainAxisSize.min,   // 👈 removes unwanted vertical gaps
      children: [
        // ----------- ICON -----------
        GestureDetector(
          onTapDown: (_) => setState(() => _scale = 0.92),
          onTapCancel: () => setState(() => _scale = 1.0),
          onTapUp: (_) {
            setState(() => _scale = 1.0);
            widget.onOpen();
          },
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 90),
            curve: Curves.easeOut,
            child: Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.18),
                  width: 0.8,
                ),
              ),
              child: const Icon(
                Icons.apps,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),

        const SizedBox(height: 2), // 👈 tiny label padding

        // ----------- LABEL -----------
        SizedBox(
          width: 46,
          child: Text(
            name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
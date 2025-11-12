import 'dart:io';
import 'package:flutter/material.dart';
import '../../app_launcher.dart';

class DesktopAppGrid extends StatelessWidget {
  final List<DesktopApp> apps;
  final void Function(DesktopApp app) onOpen;

  const DesktopAppGrid({
    super.key,
    required this.apps,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    if (apps.isEmpty) {
      return const Center(
        child: Text(
          'No desktop apps found',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,          // more apps per row
        childAspectRatio: 0.80,
        crossAxisSpacing: 8,
        mainAxisSpacing: 10,
      ),
      itemCount: apps.length,
      itemBuilder: (_, i) => _DesktopAppIcon(
        app: apps[i],
        onOpen: () => onOpen(apps[i]),
      ),
    );
  }
}

class _DesktopAppIcon extends StatefulWidget {
  final DesktopApp app;
  final VoidCallback onOpen;

  const _DesktopAppIcon({
    required this.app,
    required this.onOpen,
  });

  @override
  State<_DesktopAppIcon> createState() => _DesktopAppIconState();
}

class _DesktopAppIconState extends State<_DesktopAppIcon> {
  double _scale = 1.0;

  bool _isValidBitmap(String? path) {
  if (path == null || path.isEmpty) return false;

  final file = File(path);
  if (!file.existsSync()) return false;
  if (file.lengthSync() < 200) return false; // avoid invalid images

  final lower = path.toLowerCase();
  return lower.endsWith('.png') ||
         lower.endsWith('.jpg') ||
         lower.endsWith('.jpeg');
}

  @override
  Widget build(BuildContext context) {
    final String name = widget.app.name;
    final String? iconPath = widget.app.iconPath;

    final bool showImage = _isValidBitmap(iconPath);

    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _scale = 0.88),
          onTapCancel: () => setState(() => _scale = 1.0),
          onTapUp: (_) {
            setState(() => _scale = 1.0);
            widget.onOpen();
          },
          child: AnimatedScale(
            scale: _scale,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 140),
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.10),
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 1.2,
                ),
              ),
              child: showImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        File(iconPath!),
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.apps,
                      color: Colors.white,
                      size: 26,
                    ),
            ),
          ),
        ),

        const SizedBox(height: 4),

        SizedBox(
          width: 70,
          child: Text(
            name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 11.5,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
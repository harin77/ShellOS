import 'dart:io';
import 'package:path/path.dart' as p;

/// Represents a Linux desktop application parsed from a .desktop file.
class DesktopApp {
  final String id;
  final String name;
  final String exec;
  final String path;
  final String? iconPath; // resolved icon path

  DesktopApp({
    required this.id,
    required this.name,
    required this.exec,
    required this.path,
    required this.iconPath,
  });
}

class AppLauncher {
  AppLauncher._();
  static final AppLauncher I = AppLauncher._();

  final List<String> _dirs = const [
    '/usr/share/applications',
    '/usr/local/share/applications',
    '/var/lib/flatpak/exports/share/applications',
    '/home/mobileos/.local/share/applications',
  ];

  /// Where Linux icons usually live
  final List<String> _iconDirs = const [
    '/usr/share/pixmaps',
    '/usr/share/icons/hicolor',
    '/usr/share/icons/Adwaita',
    '/usr/share/icons/Papirus',
    '/usr/share/icons/breeze',
  ];

  final List<String> _sizes = const [
    '32x32',
    '48x48',
    '64x64',
    '128x128',
    '256x256',
    '512x512',
    'scalable',
  ];

  final List<String> _extensions = const [
    'png',
    'svg',
    'xpm',
  ];

  // ----------------------------------------------------------------------
  // Load all .desktop applications
  // ----------------------------------------------------------------------
  Future<List<DesktopApp>> listApps() async {
    final apps = <DesktopApp>[];

    for (final dir in _dirs) {
      final d = Directory(dir);
      if (!await d.exists()) continue;

      await for (final f in d.list()) {
        if (f is! File || !f.path.endsWith('.desktop')) continue;

        final data = await _parseDesktop(f);
        if (data == null) continue;

        // Skip hidden apps
        if ((data['NoDisplay'] ?? '').toLowerCase() == 'true') continue;

        final id = p.basename(f.path);
        final name = data['Name'] ?? id;
        final exec = data['Exec'] ?? '';
        final iconName = data['Icon'];

        final iconPath = await _resolveIcon(iconName);

        apps.add(
          DesktopApp(
            id: id,
            name: name,
            exec: exec,
            path: f.path,
            iconPath: iconPath,
          ),
        );
      }
    }

    // Sort alphabetically
    apps.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return apps;
  }

  // ----------------------------------------------------------------------
  // Parse .desktop file
  // ----------------------------------------------------------------------
  Future<Map<String, String>?> _parseDesktop(File file) async {
    try {
      final lines = await file.readAsLines();
      final map = <String, String>{};
      bool inMain = false;

      for (final raw in lines) {
        final line = raw.trim();

        if (line.startsWith('[')) {
          inMain = line.toLowerCase() == '[desktop entry]';
          continue;
        }

        if (!inMain || line.isEmpty || line.startsWith('#')) continue;

        final idx = line.indexOf('=');
        if (idx <= 0) continue;

        final key = line.substring(0, idx).trim();
        final val = line.substring(idx + 1).trim();
        map[key] = val;
      }

      return map.isEmpty ? null : map;
    } catch (_) {
      return null;
    }
  }

  // ----------------------------------------------------------------------
  // Resolve REAL icon path from Linux icon themes
  // ----------------------------------------------------------------------
  Future<String?> _resolveIcon(String? iconName) async {
    if (iconName == null || iconName.isEmpty) return null;

    // If already a valid absolute path
    if (iconName.contains('/') && await File(iconName).exists()) {
      return iconName;
    }

    // Try all icon theme directories
    for (final dir in _iconDirs) {
      for (final size in _sizes) {
        for (final ext in _extensions) {
          final full = '$dir/$size/apps/$iconName.$ext';
          if (await File(full).exists()) return full;
        }
      }
      // Some icons are stored directly at root of theme
      for (final ext in _extensions) {
        final full = '$dir/apps/$iconName.$ext';
        if (await File(full).exists()) return full;
      }

      for (final ext in _extensions) {
        final full = '$dir/$iconName.$ext';
        if (await File(full).exists()) return full;
      }
    }

    return null; // fallback: icon not found
  }

  // ----------------------------------------------------------------------
  // Launch app (gtk-launch → gio → Exec fallback)
  // ----------------------------------------------------------------------
  Future<bool> launch(DesktopApp app) async {
    // Try gtk-launch
    final r1 = await Process.run('gtk-launch', [app.id]);
    if (r1.exitCode == 0) return true;

    // Try gio
    final r2 = await Process.run('gio', ['launch', app.path]);
    if (r2.exitCode == 0) return true;

    // Fallback Exec= command
    final cleaned = app.exec.split(' ')
      ..removeWhere((s) => s.contains('%'));

    if (cleaned.isNotEmpty) {
      final r3 = await Process.run(cleaned.first, cleaned.sublist(1));
      return r3.exitCode == 0;
    }

    return false;
  }
}
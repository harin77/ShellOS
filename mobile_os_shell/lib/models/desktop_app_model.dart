/// Simple model representing a desktop application discovered from .desktop files.
class DesktopAppModel {
  final String id;      // e.g. org.gnome.Nautilus.desktop
  final String name;    // Display name
  final String exec;    // Exec command
  final String path;    // Full path of .desktop file

  DesktopAppModel({
    required this.id,
    required this.name,
    required this.exec,
    required this.path,
  });
}

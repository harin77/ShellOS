/// Model for internal notifications displayed inside the OS shell.
/// This is separate from IncomingNotification which comes from DBus.

class NotifModel {
  final int id;
  final String title;
  final String body;
  final String time; // formatted time string

  NotifModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
  });
}

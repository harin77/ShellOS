import 'package:flutter/material.dart';
import '../../linux_notifications.dart';

/// ComposeNotification: UI to send a test notification
/// using the built‑in DBus notification daemon.
class ComposeNotification extends StatefulWidget {
  final void Function(IncomingNotification) onSend;

  const ComposeNotification({super.key, required this.onSend});

  @override
  State<ComposeNotification> createState() => _ComposeNotificationState();
}

class _ComposeNotificationState extends State<ComposeNotification> {
  final TextEditingController _titleC = TextEditingController();
  final TextEditingController _bodyC = TextEditingController();

  void _send() {
    final title = _titleC.text.trim();
    final body = _bodyC.text.trim();
    if (title.isEmpty && body.isEmpty) return;

    final n = IncomingNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      appName: 'User',
      summary: title.isEmpty ? 'Notification' : title,
      body: body.isEmpty ? ' ' : body,
    );

    widget.onSend(n);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Notification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleC,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bodyC,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _send,
              child: const Text('Send'),
            )
          ],
        ),
      ),
    );
  }
}

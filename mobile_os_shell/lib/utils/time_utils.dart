import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Returns current time HH:mm formatted (e.g. 09:41)
String formattedTime() {
  final now = DateTime.now();
  final df = DateFormat('HH:mm');
  return df.format(now);
}

/// Returns relative time: "5m", "12m", "1h", etc.
String relativeTime(DateTime time) {
  final now = DateTime.now();
  final diff = now.difference(time);

  if (diff.inMinutes < 1) return 'now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m';
  if (diff.inHours < 24) return '${diff.inHours}h';
  return '${diff.inDays}d';
}

import 'package:flutter/material.dart';

/// WidgetStrip: small widget row on HomeScreen
/// Contains 2 info cards: Weather + Calendar (placeholder)
class WidgetStrip extends StatelessWidget {
  const WidgetStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        children: const [
          Expanded(
            child: _InfoCard(
              title: 'Weather',
              content: '29°C • Cloudy',
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _InfoCard(
              title: 'Calendar',
              content: '2 events today',
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const _InfoCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const Spacer(),
          Text(
            content,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

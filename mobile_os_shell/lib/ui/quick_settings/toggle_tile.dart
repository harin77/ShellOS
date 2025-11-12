import 'package:flutter/material.dart';

/// Basic toggle tile used for Mobile, BT, DND, Rotation, etc.
class ToggleTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ToggleTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<ToggleTile> createState() => _ToggleTileState();
}

class _ToggleTileState extends State<ToggleTile> {
  late bool _v = widget.value;

  @override
  Widget build(BuildContext context) {
    final bool active = _v;

    return GestureDetector(
      onTap: () {
        setState(() => _v = !_v);
        widget.onChanged(_v);
      },
      child: Container(
        width: 110,
        height: 74,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active ? Colors.white24 : Colors.white10,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(widget.icon, size: 22),
            const Spacer(),
            Text(widget.label),
          ],
        ),
      ),
    );
  }
}

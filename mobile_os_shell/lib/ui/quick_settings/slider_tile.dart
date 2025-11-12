import 'package:flutter/material.dart';

/// Slider tile used for brightness and volume controls.
class SliderTile extends StatefulWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const SliderTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<SliderTile> createState() => _SliderTileState();
}

class _SliderTileState extends State<SliderTile> {
  late double _v = widget.value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              widget.label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Slider(
              value: _v,
              onChanged: (x) {
                setState(() => _v = x);
                widget.onChanged(x);
              },
            ),
          ),
        ],
      ),
    );
  }
}

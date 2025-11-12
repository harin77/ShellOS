import 'package:flutter/material.dart';

/// iOS Style Numeric Keypad (Lock Screen)
class Keypad extends StatelessWidget {
  final void Function(String) onKey;

  const Keypad({super.key, required this.onKey});

  @override
  Widget build(BuildContext context) {
    final keys = [
      '1','2','3',
      '4','5','6',
      '7','8','9',
      '', '0', '⌫',
    ];

    return SizedBox(
      width: 300,
      child: GridView.builder(
        itemCount: keys.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
          childAspectRatio: 1,
        ),
        itemBuilder: (_, i) {
          final key = keys[i];

          // Empty placeholder (iOS spacing)
          if (key.isEmpty) return const SizedBox.shrink();

          return GestureDetector(
            onTap: () => onKey(key),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.10), // light translucent
                border: Border.all(
                  color: Colors.white.withOpacity(0.22),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                key == '⌫' ? '⌫' : key,
                style: TextStyle(
                  fontSize: key == '⌫' ? 26 : 28,
                  color: Colors.white,
                  fontWeight: FontWeight.w300, // iOS thin style
                  letterSpacing: 1.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
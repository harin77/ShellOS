import 'package:flutter/material.dart';

/// Bottom gesture navigation bar
/// - Back
/// - Home
/// - Recents
class GestureBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onHome;
  final VoidCallback onRecents;

  const GestureBar({
    super.key,
    required this.onBack,
    required this.onHome,
    required this.onRecents,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavButton(icon: Icons.arrow_back, onTap: onBack),

            // Home Pill
            Container(
              width: 120,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            _NavButton(icon: Icons.apps, onTap: onRecents),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, size: 22),
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'keypad.dart';

/// Beautiful Lock Screen with blurred wallpaper + modern design.
class LockScreen extends StatefulWidget {
  final VoidCallback onUnlock;

  const LockScreen({super.key, required this.onUnlock});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  static const String _pin = '1234';
  String _input = '';
  String _hint = 'Enter PIN';

  void _press(String key) {
    if (key == '⌫') {
      if (_input.isNotEmpty) {
        setState(() => _input = _input.substring(0, _input.length - 1));
      }
      return;
    }

    if (_input.length >= 4) return;

    setState(() => _input += key);

    if (_input.length == 4) {
      Future.delayed(const Duration(milliseconds: 140), () {
        if (_input == _pin) {
          widget.onUnlock();
        } else {
          setState(() {
            _hint = 'Wrong PIN';
            _input = '';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // -------- Wallpaper background --------
        Positioned.fill(
          child: Image.asset(
            "assets/wallpaper.jpg",
            fit: BoxFit.cover,
          ),
        ),

        // -------- Blur effect --------
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              color: Colors.black.withOpacity(0.35),
            ),
          ),
        ),

        // -------- Lock screen content --------
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20),

              Column(
                children: [
                  // Time
                  Text(
                    _getTime(),
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                      letterSpacing: -2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Hint text
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      _hint,
                      key: ValueKey(_hint),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // PIN dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (i) {
                      bool filled = i < _input.length;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: filled
                              ? Colors.white
                              : Colors.white.withOpacity(0.25),
                        ),
                      );
                    }),
                  ),
                ],
              ),

              // -------- Keypad panel with blur ------
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: ClipRRect(borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 1.2,
                        ),
                      ),
                      child: Keypad(onKey: _press),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Returns formatted time like "09:41"
  String _getTime() {
    final t = TimeOfDay.now();
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }
}
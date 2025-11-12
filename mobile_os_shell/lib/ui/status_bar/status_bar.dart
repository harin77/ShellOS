import 'package:flutter/material.dart';
import '../../models/app_model.dart';
import '../../utils/time_utils.dart';

class StatusBar extends StatelessWidget {
  final AppModel model;

  final VoidCallback onNotif;      // opens notification panel
  final VoidCallback onQS;         // opens quick settings panel

  // NEW callbacks
  final VoidCallback onWifi;
  final VoidCallback onMobile;
  final VoidCallback onBattery;

  const StatusBar({
    super.key,
    required this.model,
    required this.onNotif,
    required this.onQS,

    required this.onWifi,
    required this.onMobile,
    required this.onBattery,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // drag-down for notifications
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 4) onNotif();
      },

      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            // ---------------- TIME ----------------
            GestureDetector(
              onTap: onNotif,
              child: Text(
                formattedTime(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),

            // ---------------- RIGHT SIDE STATUS ICONS ----------------
            Row(
              children: [

                // -------- WiFi --------
                GestureDetector(
                  onTap: onWifi,
                  child: Icon(
                    model.wifi ? Icons.wifi : Icons.wifi_off,
                    size: 17,
                  ),
                ),
                const SizedBox(width: 8),

                // -------- Mobile Data --------
                GestureDetector(
                  onTap: onMobile,
                  child: const Icon(
                    Icons.signal_cellular_alt,
                    size: 17,
                  ),
                ),
                const SizedBox(width: 8),

                // -------- Battery --------
                GestureDetector(
                  onTap: onBattery,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.battery_std, size: 20),
                      Positioned(
                        right: 4,
                        child: Text(
                          "${model.battery}%",
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // -------- Quick Settings --------
                GestureDetector(
                  onTap: onQS,
                  child: const Icon(
                    Icons.settings_suggest,
                    size: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
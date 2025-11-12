import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models/app_model.dart';
import 'notif_tile.dart';

/// Android 14 Style Notification Shade (40% width, 85% height)
class NotificationShade extends StatefulWidget {
  final AnimationController controller;
  final AppModel model;

  const NotificationShade({
    super.key,
    required this.controller,
    required this.model,
  });

  @override
  State<NotificationShade> createState() => _NotificationShadeState();
}

class _NotificationShadeState extends State<NotificationShade> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double panelHeight = size.height * 0.85; // 85% height
    final double panelWidth = size.width * 0.40;   // 40% width

    return IgnorePointer(
      ignoring: widget.controller.value == 0,
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (_, __) {
          final double offsetY =
              -(panelHeight) + widget.controller.value * panelHeight;

          return Stack(
            children: [
              // ----------------------------------------------------------
              // 1) FULL-SCREEN TAP AREA BEHIND PANEL -> CLOSE ON TAP
              // ----------------------------------------------------------
              if (widget.controller.value > 0)
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => widget.controller.reverse(),
                  child: Container(
                    width: size.width,
                    height: size.height,
                    color: Colors.black.withOpacity(widget.controller.value * 0.45),
                  ),
                ),

              // ----------------------------------------------------------
              // 2) NOTIFICATION PANEL ITSELF (FLOATING CENTER)
              // ----------------------------------------------------------
              Transform.translate(
                offset: Offset(0, offsetY),
                child: Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,

                    // Drag up/down to open/close
                    onVerticalDragUpdate: (details) {
                      widget.controller.value +=
                          details.delta.dy / panelHeight;
                    },

                    onVerticalDragEnd: (details) {
                      if (widget.controller.value > 0.35) {
                        widget.controller.forward();
                      } else {
                        widget.controller.reverse();
                      }
                    },

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Container(
                        height: panelHeight,
                        width: panelWidth,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Colors.white24, width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.35),
                              blurRadius: 24,
                              spreadRadius: 2,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),

                        child: Column(
                          children: [
                            const SizedBox(height: 10),

                            // Handle
                            GestureDetector(
                              onTap: () => widget.controller.reverse(),
                              child: Container(
                                width: 50,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.white30,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            const Text(
                              "Notifications",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Expanded(
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                itemCount: widget.model.notifications.length,
                                separatorBuilder: (_, __) => const Divider(
                                  height: 1,
                                  color: Colors.white12,
                                ),
                                itemBuilder: (_, i) {
                                  return NotifTile(
                                    notif: widget.model.notifications[i],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
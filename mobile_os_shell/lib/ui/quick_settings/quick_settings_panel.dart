import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models/app_model.dart';
import '../../linux_bridge.dart';

// NETWORK PAGES
import '../network/network_info_page.dart';
import '../network/wifi_settings_page.dart';
import '../network/network_settings_home.dart';
import '../network/hotspot_page.dart';

class QuickSettingsPanel extends StatefulWidget {
  final AnimationController controller;
  final AppModel model;

  const QuickSettingsPanel({
    super.key,
    required this.controller,
    required this.model,
  });

  @override
  State<QuickSettingsPanel> createState() => _QuickSettingsPanelState();
}

class _QuickSettingsPanelState extends State<QuickSettingsPanel> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double panelHeight = size.height * 0.82;

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (_, __) {
        final offsetY = size.height - widget.controller.value * panelHeight;

        return Transform.translate(
          offset: Offset(0, offsetY),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                height: panelHeight,
                width: size.width,
                padding: const EdgeInsets.only(top: 14),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(32)),
                ),

                child: Column(
                  children: [
                    // Handle bar
                    Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // NETWORK Toggles
                    Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      children: [
                        // ---------------- WIFI TILE ----------------
                        _toggleTile(
                          icon: Icons.wifi,
                          label: "Wi-Fi",
                          value: widget.model.wifi,
                          onTap: () => setState(() =>
                              widget.model.wifi = !widget.model.wifi),
                          
                          // Long press → WiFi Settings Page
                          onLongPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WifiSettingsPage(),
                              ),
                            );
                          },
                        ),

                        // ---------------- MOBILE TILE ----------------
                        _toggleTile(
                          icon: Icons.network_cell,
                          label: "Mobile Data",
                          value: widget.model.mobile,
                          onTap: () => setState(
                              () => widget.model.mobile = !widget.model.mobile),

                          // Tap → Mobile Network Page
                          onLongPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NetworkSettingsHome(),
                              ),
                            );
                          },
                        ),
                        // ---------------- HOTSPOT TILE ----------------
                        _toggleTile(
                          icon: Icons.wifi_tethering,
                          label: "Hotspot",
                          value: widget.model.hotspot,
                          onTap: () {
                            setState(() =>
                                widget.model.hotspot = !widget.model.hotspot);
                          },

                          // Long press → Hotspot Settings
                          onLongPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HotspotPage(),
                              ),
                            );
                          },
                        ),

                        // ---------------- BLUETOOTH ----------------
                        _toggleTile(
                          icon: Icons.bluetooth,
                          label: "Bluetooth",
                          value: widget.model.bt,
                          onTap: () async {
                            final v = !widget.model.bt;
                            setState(() => widget.model.bt = v);
                            await LinuxBridge.I.powerBluetooth(v);
                          },
                        ),

                        // ---------------- DND ----------------
                        _toggleTile(
                          icon: Icons.do_not_disturb_on,
                          label: "DND",
                          value: widget.model.dnd,
                          onTap: () => setState(
                              () => widget.model.dnd = !widget.model.dnd),
                        ),

                        // ---------------- ROTATE ----------------
                        _toggleTile(
                          icon: Icons.screen_rotation,
                          label: "Rotate",
                          value: widget.model.rotate,
                          onTap: () => setState(
                              () => widget.model.rotate = !widget.model.rotate),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // SLIDERS
                    _glassSlider(
                      label: "Brightness",
                      value: widget.model.brightness,
                      onChanged: (v) async {
                        setState(() => widget.model.brightness = v);
                        await LinuxBridge.I.setBrightness01(v);
                      },
                    ),

                    _glassSlider(
                      label: "Volume",
                      value: widget.model.volume,
                      onChanged: (v) async {
                        setState(() => widget.model.volume = v);
                        await LinuxBridge.I.setVolume01(v);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ================================
  // Toggle Tile UI
  // ================================
  Widget _toggleTile({
    required IconData icon,
    required String label,
    required bool value,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: value
                ? [
                    Colors.white.withOpacity(0.40),
                    Colors.white.withOpacity(0.18),
                  ]
                : [
                    Colors.white.withOpacity(0.12),
                    Colors.white.withOpacity(0.06),
                  ],
          ),
          border: Border.all(
            color: Colors.white.withOpacity(value ? 0.35 : 0.20),
            width: 1.3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 33,
                color: value ? Colors.white : Colors.white70),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: value ? Colors.white : Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  // ================================
  // Glass Slider UI
  // ================================
  Widget _glassSlider({
    required String label,
    required double value,
    required Function(double) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Slider(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              inactiveColor: Colors.white24,
            ),
          ],
        ),
      ),
    );
  }
}
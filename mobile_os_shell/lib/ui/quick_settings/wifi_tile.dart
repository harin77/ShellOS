import 'package:flutter/material.dart';
import '../../models/app_model.dart';
import '../../linux_bridge.dart';
import 'wifi_sheet.dart';

class WifiTile extends StatefulWidget {
  final AppModel model;
  const WifiTile({super.key, required this.model});

  @override
  State<WifiTile> createState() => _WifiTileState();
}

class _WifiTileState extends State<WifiTile> {
  String? _activeSsid;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _refreshActive();
  }

  Future<void> _refreshActive() async {
    _activeSsid = await LinuxBridge.I.getActiveWifiSsid();
    if (mounted) setState(() {});
  }

  Future<void> _toggle() async {
    if (_busy) return;
    setState(() => _busy = true);
    final newVal = !(await LinuxBridge.I.getWifiEnabled());
    await LinuxBridge.I.setWifiEnabled(newVal);
    widget.model.wifi = newVal;
    await _refreshActive();
    setState(() => _busy = false);
  }

  Future<void> _openSheet() async {
    final changed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WifiSheet(onConnected: (ssid) {
        _activeSsid = ssid;
        widget.model.wifi = true;
      }),
    );
    if (changed == true) {
      await _refreshActive();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final on = widget.model.wifi;
    return GestureDetector(
      onTap: _toggle,
      onLongPress: _openSheet,
      child: Container(
        width: 180,
        height: 90,
        decoration: BoxDecoration(
          color: on ? Colors.white.withOpacity(0.30) : Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: Colors.white.withOpacity(0.20), width: 1.2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(on ? Icons.wifi : Icons.wifi_off, size: 32, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Wi-Fi', style: const TextStyle(color: Colors.white, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    _busy
                        ? '…'
                        : (on ? (_activeSsid ?? 'Connected') : 'Off'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
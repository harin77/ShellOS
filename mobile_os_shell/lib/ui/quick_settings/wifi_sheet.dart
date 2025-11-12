import 'package:flutter/material.dart';
import '../../linux_bridge.dart';

class WifiSheet extends StatefulWidget {
  final void Function(String ssid)? onConnected;
  const WifiSheet({super.key, this.onConnected});

  @override
  State<WifiSheet> createState() => _WifiSheetState();
}

class _WifiSheetState extends State<WifiSheet> {
  List<WifiNetwork> nets = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _scan();
  }

  Future<void> _scan() async {
    setState(() => loading = true);
    nets = await LinuxBridge.I.scanWifi();
    setState(() => loading = false);
  }

  Future<void> _connect(WifiNetwork w) async {
    String? pass;
    if (w.secure) {
      pass = await _askPassword(w.ssid);
      if (pass == null) return;
    }
    final ok = await LinuxBridge.I.connectWifi(w.ssid, pass);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'Connected to ${w.ssid}' : 'Failed to connect')),
    );
    if (ok) {
      widget.onConnected?.call(w.ssid);
      Navigator.pop(context, true);
    }
  }

  Future<String?> _askPassword(String ssid) async {
    final c = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Connect to $ssid'),
        content: TextField(
          controller: c,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, c.text), child: const Text('Connect')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = Colors.black.withOpacity(0.85);
    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: Colors.white10),
        ),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            Container(width: 48, height: 5, decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(12))),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Wi-Fi Networks', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const Spacer(),
                IconButton(onPressed: _scan, icon: const Icon(Icons.refresh)),
              ],
            ),
            const SizedBox(height: 6),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      itemCount: nets.length,
                      separatorBuilder: (_, __) => const Divider(color: Colors.white12),
                      itemBuilder: (_, i) {
                        final w = nets[i];
                        final bars = (w.signal / 25).clamp(0, 4).round(); // 0..4
                        return ListTile(
                          leading: Icon(
                            w.secure ? Icons.wifi_lock : Icons.wifi,
                            color: Colors.white,
                          ),
                          title: Text(w.ssid, overflow: TextOverflow.ellipsis),
                          subtitle: Text('Signal: ${w.signal}  •  ${w.secure ? 'Secure' : 'Open'}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(4, (b) => Icon(
                              b < bars ? Icons.signal_cellular_alt : Icons.signal_cellular_alt_2_bar,
                              size: 14,
                              color: b < bars ? Colors.white70 : Colors.white24,
                            )),
                          ),
                          onTap: () => _connect(w),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
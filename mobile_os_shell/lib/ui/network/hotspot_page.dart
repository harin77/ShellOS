import 'dart:io';
import 'package:flutter/material.dart';
import '../../linux_bridge.dart';

class HotspotPage extends StatefulWidget {
  const HotspotPage({super.key});

  @override
  State<HotspotPage> createState() => _HotspotPageState();
}

class _HotspotPageState extends State<HotspotPage> {
  bool loading = true;
  bool hotspotEnabled = false;

  String ssid = "MyHotspot";
  String password = "12345678";
  String band = "2.4GHz";

  List<Map<String, String>> clients = [];

  @override
  void initState() {
    super.initState();
    loadHotspotInfo();
    loadClients();
  }

  Future<void> loadHotspotInfo() async {
    setState(() => loading = true);

    final info = await LinuxBridge.I.getHotspotInfo();

    setState(() {
      hotspotEnabled = info["enabled"] == "true";
      ssid = info["ssid"] ?? "MyHotspot";
      password = info["password"] ?? "12345678";
      band = info["band"] ?? "2.4GHz";
      loading = false;
    });
  }

  Future<void> loadClients() async {
    final list = await LinuxBridge.I.getHotspotClients();
    setState(() => clients = list);
  }

  Future<void> toggleHotspot(bool enable) async {
    setState(() => loading = true);

    if (enable) {
      await LinuxBridge.I.enableHotspot(ssid, password, band);
    } else {
      await LinuxBridge.I.disableHotspot();
    }

    await loadHotspotInfo();
  }

  Future<void> changeSSID() async {
    final controller = TextEditingController(text: ssid);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hotspot Name (SSID)"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter hotspot name"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              setState(() => ssid = controller.text);
              await LinuxBridge.I.updateHotspot(ssid, password, band);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> changePassword() async {
    final controller = TextEditingController(text: password);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hotspot Password"),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(hintText: "Min 8 characters"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              if (controller.text.length < 8) return;
              setState(() => password = controller.text);
              await LinuxBridge.I.updateHotspot(ssid, password, band);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> changeBand() async {
    final bands = ["2.4GHz", "5GHz"];

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Band"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: bands.map((b) {
            return RadioListTile(
              title: Text(b),
              value: b,
              groupValue: band,
              onChanged: (v) async {
                setState(() => band = v.toString());
                await LinuxBridge.I.updateHotspot(ssid, password, band);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget clientTile(Map<String, String> c) {
    return ListTile(
      leading: const Icon(Icons.devices, color: Colors.white),
      title: Text(
        c["ip"] ?? "Unknown",
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        "MAC: ${c["mac"]}",
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Hotspot"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView(
              children: [
                SwitchListTile(
                  value: hotspotEnabled,
                  onChanged: toggleHotspot,
                  title: const Text("Hotspot", style: TextStyle(color: Colors.white)),
                  subtitle: Text(
                    hotspotEnabled ? "Enabled" : "Disabled",
                    style: const TextStyle(color: Colors.white54),
                  ),
                ),

                const Divider(color: Colors.white24),

                ListTile(
                  title: const Text("Hotspot Name", style: TextStyle(color: Colors.white)),
                  subtitle: Text(ssid, style: const TextStyle(color: Colors.white70)),
                  trailing: const Icon(Icons.edit, color: Colors.white),
                  onTap: changeSSID,
                ),

                ListTile(
                  title: const Text("Password", style: TextStyle(color: Colors.white)),
                  subtitle: Text(password, style: const TextStyle(color: Colors.white70)),
                  trailing: const Icon(Icons.lock, color: Colors.white),
                  onTap: changePassword,
                ),

                ListTile(
                  title: const Text("Band", style: TextStyle(color: Colors.white)),
                  subtitle: Text(band, style: const TextStyle(color: Colors.white70)),
                  trailing: const Icon(Icons.wifi, color: Colors.white),
                  onTap: changeBand,
                ),

                const Divider(color: Colors.white24),

                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text("Connected Devices",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),

                ...clients.map(clientTile),
              ],
            ),
    );
  }
}
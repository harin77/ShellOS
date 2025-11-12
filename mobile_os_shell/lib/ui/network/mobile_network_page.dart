import 'package:flutter/material.dart';
import '../../linux_bridge.dart';

class MobileNetworkPage extends StatefulWidget {
  const MobileNetworkPage({super.key});

  @override
  State<MobileNetworkPage> createState() => _MobileNetworkPageState();
}

class _MobileNetworkPageState extends State<MobileNetworkPage> {
  bool mobileEnabled = false;
  String operatorName = "Unknown";
  String signal = "--";
  String networkType = "Unknown";
  String simState = "Unknown";
  String apn = "Unknown";

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadMobileInfo();
  }

  // -------------------------------
  // Load SIM & mobile network info
  // -------------------------------
  Future<void> loadMobileInfo() async {
    setState(() => loading = true);

    final info = await LinuxBridge.I.getMobileNetworkInfo();

    setState(() {
      mobileEnabled = info["enabled"] == "true";
      operatorName = info["operator"] ?? "Unknown";
      signal = info["signal"] ?? "--";
      networkType = info["type"] ?? "Unknown";
      simState = info["sim"] ?? "Unknown";
      apn = info["apn"] ?? "Unknown";
      loading = false;
    });
  }

  // -------------------------------
  // Toggle mobile data ON/OFF
  // -------------------------------
  Future<void> toggleMobile(bool v) async {
    setState(() => mobileEnabled = v);
    await LinuxBridge.I.setMobileEnabled(v);
    await loadMobileInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Mobile Network"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadMobileInfo,
          )
        ],
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : ListView(
              children: [
                SwitchListTile(
                  value: mobileEnabled,
                  activeColor: Colors.greenAccent,
                  title: const Text("Mobile Data",
                      style: TextStyle(color: Colors.white)),
                  subtitle: Text(
                    mobileEnabled ? "Enabled" : "Disabled",
                    style: const TextStyle(color: Colors.white54),
                  ),
                  onChanged: toggleMobile,
                ),

                const Divider(color: Colors.white30),

                ListTile(
                  title: const Text("Operator", style: TextStyle(color: Colors.white)),
                  subtitle: Text(operatorName, style: const TextStyle(color: Colors.white54)),
                  leading: const Icon(Icons.network_cell, color: Colors.white),
                ),

                ListTile(
                  title: const Text("Signal Strength", style: TextStyle(color: Colors.white)),
                  subtitle: Text("$signal%", style: const TextStyle(color: Colors.white54)),
                  leading: const Icon(Icons.network_cell, color: Colors.white),
                ),

                ListTile(
                  title: const Text("Network Type", style: TextStyle(color: Colors.white)),
                  subtitle: Text(networkType, style: const TextStyle(color: Colors.white54)),
                  leading: const Icon(Icons.podcasts, color: Colors.white),
                ),

                ListTile(
                  title: const Text("SIM Status", style: TextStyle(color: Colors.white)),
                  subtitle: Text(simState, style: const TextStyle(color: Colors.white54)),
                  leading: const Icon(Icons.sim_card, color: Colors.white),
                ),

                const Divider(color: Colors.white30),
                ListTile(
                  title: const Text("APN", style: TextStyle(color: Colors.white)),
                  subtitle: Text(apn, style: const TextStyle(color: Colors.white54)),
                  leading: const Icon(Icons.settings_ethernet, color: Colors.white),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("APN editing coming soon")),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
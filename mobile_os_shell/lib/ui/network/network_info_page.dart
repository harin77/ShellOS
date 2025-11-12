import 'package:flutter/material.dart';
import '../../linux_bridge.dart';

class NetworkInfoPage extends StatefulWidget {
  const NetworkInfoPage({super.key});

  @override
  State<NetworkInfoPage> createState() => _NetworkInfoPageState();
}

class _NetworkInfoPageState extends State<NetworkInfoPage> {
  Map<String, String> basic = {};
  Map<String, String> wifi = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    setState(() => loading = true);

    final n1 = await LinuxBridge.I.getNetworkInfo();
    final n2 = await LinuxBridge.I.getWifiDeviceInfo();

    setState(() {
      basic = n1;
      wifi = n2;
      loading = false;
    });
  }

  Widget _tile(String title, String? value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white70,
              )),
          Text(value ?? "-",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1116),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Network Information"),
        actions: [
          IconButton(
            onPressed: _loadInfo,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : ListView(
              padding: const EdgeInsets.all(14),
              children: [
                // ---------------- WIFI SECTION ----------------
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Wi-Fi",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _tile("SSID", wifi["SSID"]),
                      _tile("Signal", wifi["SIGNAL"]),
                      _tile("Speed / Rate", wifi["RATE"]),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ---------------- NETWORK SECTION ----------------
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                           const Text(
                        "IP Configuration",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),

                      _tile("IP Address", basic["IP4.ADDRESS[1]"]),
                      _tile("Gateway", basic["IP4.GATEWAY"]),
                      _tile("DNS", basic["IP4.DNS[1]"]),
                      _tile("Device", basic["DEVICE"]),
                      _tile("Connection", basic["CONNECTION"]),
                      _tile("State", basic["STATE"]),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}           
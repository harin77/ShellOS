import 'package:flutter/material.dart';
import '../../linux_bridge.dart';

class WifiSettingsPage extends StatefulWidget {
  const WifiSettingsPage({super.key});

  @override
  State<WifiSettingsPage> createState() => _WifiSettingsPageState();
}

class _WifiSettingsPageState extends State<WifiSettingsPage> {
  bool loading = false;
  List<WifiNetwork> networks = [];
  String? connectedSSID;

  @override
  void initState() {
    super.initState();
    loadWifi();
  }

  Future<void> loadWifi() async {
    setState(() => loading = true);

    // Get active connected Wi-Fi
    connectedSSID = await LinuxBridge.I.getActiveWifiSsid();

    // Scan available networks
    networks = await LinuxBridge.I.scanWifi();

    setState(() => loading = false);
  }

  // Ask for password if needed
  Future<void> _connectToNetwork(WifiNetwork net) async {
    if (!net.secure) {
      // open connection instantly if open network
      await _connect(net, null);
      return;
    }

    final passwordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Connect to ${net.ssid}"),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "Wi-Fi Password",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Connect"),
            onPressed: () async {
              Navigator.pop(context);
              await _connect(net, passwordController.text.trim());
            },
          ),
        ],
      ),
    );
  }

  Future<void> _connect(WifiNetwork net, String? password) async {
    setState(() => loading = true);

    final ok = await LinuxBridge.I.connectWifi(net.ssid, password);

    if (ok) {
      connectedSSID = net.ssid;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connected to ${net.ssid} ✔")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to connect to ${net.ssid}")),
      );
    }

    await loadWifi(); // refresh list
  }

  Icon _signalIcon(int strength) {
    if (strength > 75) return const Icon(Icons.wifi, color: Colors.lightBlueAccent);
    if (strength > 50) return const Icon(Icons.wifi_2_bar, color: Colors.lightBlueAccent);
    if (strength > 25) return const Icon(Icons.wifi_1_bar, color: Colors.lightBlueAccent);
    return const Icon(Icons.wifi, color: Colors.lightBlueAccent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Wi-Fi"),
        elevation: 0,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadWifi,
          ),
        ],
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Available Networks",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                ...networks.map((net) {
                  final isConnected = connectedSSID == net.ssid;

                  return ListTile(
                    leading: _signalIcon(net.signal),
                    title: Text(
                      net.ssid,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      isConnected
                          ? "Connected"
                          : (net.secure ? "Secured network" : "Open network"),
                      style: const TextStyle(color: Colors.white54),
                    ),
                    trailing: isConnected
                        ? const Icon(Icons.check_circle, color: Colors.greenAccent)
                        : const Icon(Icons.chevron_right, color: Colors.white70),

                    onTap: () => _connectToNetwork(net),
                  );
                }),
              ],
            ),
    );
  }
}

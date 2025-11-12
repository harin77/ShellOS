import 'package:flutter/material.dart';
import '../../linux_bridge.dart';

class MobilePreferredNetworkPage extends StatefulWidget {
  const MobilePreferredNetworkPage({super.key});

  @override
  State<MobilePreferredNetworkPage> createState() =>
      _MobilePreferredNetworkPageState();
}

class _MobilePreferredNetworkPageState
    extends State<MobilePreferredNetworkPage> {
  String currentMode = "Unknown";

  final List<String> modes = [
    "2G",
    "3G",
    "4G",
    "5G",
    "2G/3G",
    "3G/4G",
    "4G/5G",
    "Auto"
  ];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadMode();
  }

  Future<void> loadMode() async {
    setState(() => loading = true);

    final mode = await LinuxBridge.I.getPreferredNetworkType();

    setState(() {
      currentMode = mode;
      loading = false;
    });
  }

  Future<void> changeMode(String mode) async {
    setState(() => loading = true);

    await LinuxBridge.I.setPreferredNetworkType(mode);

    await loadMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Preferred Network Type"),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : ListView(
              children: modes.map((m) {
                return RadioListTile(
                  value: m,
                  groupValue: currentMode,
                  activeColor: Colors.greenAccent,
                  title: Text(
                    m,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onChanged: (_) => changeMode(m),
                );
              }).toList(),
            ),
    );
  }
}
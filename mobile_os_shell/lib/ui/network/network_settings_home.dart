import 'package:flutter/material.dart';
import '../network/wifi_settings_page.dart';
import '../network/mobile_network_page.dart';
import '../network/hotspot_page.dart';
import '../network/vpn_page.dart';

class NetworkSettingsHome extends StatelessWidget {
  const NetworkSettingsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Network & Internet"),
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.only(top: 10),
        children: [

          // ------------------------------
          //  Wi-Fi
          // ------------------------------
          ListTile(
            leading: const Icon(Icons.wifi, color: Colors.lightBlueAccent),
            title: const Text("Wi-Fi", style: TextStyle(fontSize: 17)),
            subtitle: const Text("View networks, connect", style: TextStyle(color: Colors.white54)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WifiSettingsPage()),
              );
            },
          ),

          // Divider
          _divider(),

          // ------------------------------
          //  Mobile Network
          // ------------------------------
          ListTile(
            leading: const Icon(Icons.network_cell, color: Colors.greenAccent),
            title: const Text("Mobile Network"),
            subtitle: const Text("Data, SIM, APN, 2G/3G/4G/5G"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MobileNetworkPage()),
              );
            },
          ),

          _divider(),

          // ------------------------------
          //  Hotspot
          // ------------------------------
          ListTile(
            leading: const Icon(Icons.wifi_tethering, color: Colors.orangeAccent),
            title: const Text("Hotspot & Tethering"),
            subtitle: const Text("Wi-Fi hotspot, USB tethering"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HotspotPage()),
              );
            },
          ),

          _divider(),

          // ------------------------------
          //  VPN
          // ------------------------------
          ListTile(
            leading: const Icon(Icons.vpn_key, color: Colors.purpleAccent),
            title: const Text("VPN"),
            subtitle: const Text("Add VPN profiles"),
            onTap: () {
            //  Navigator.push(
              //  context,
             //   MaterialPageRoute(builder: (_) => const VPNPage()),
             // );
            },
          ),

          _divider(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 70, right: 16),
      child: Container(height: 0.6, color: Colors.white12),
    );
  }
}
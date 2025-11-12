import 'package:flutter/material.dart';
import '../../linux_bridge.dart';
import 'apn_edit_page.dart';

class APNListPage extends StatefulWidget {
  const APNListPage({super.key});

  @override
  State<APNListPage> createState() => _APNListPageState();
}

class _APNListPageState extends State<APNListPage> {
  bool loading = true;
  List<Map<String, String>> apns = [];
  String currentApn = "";

  @override
  void initState() {
    super.initState();
    loadAPNs();
  }

  Future<void> loadAPNs() async {
    setState(() => loading = true);

    final list = await LinuxBridge.I.listAPNs();
    final selected = await LinuxBridge.I.getCurrentAPN();

    setState(() {
      apns = list;
      currentApn = selected;
      loading = false;
    });
  }

  Future<void> selectAPN(String name) async {
    setState(() => loading = true);

    await LinuxBridge.I.setAPN(name);
    await loadAPNs();
  }

  Future<void> deleteAPN(String name) async {
    setState(() => loading = true);

    await LinuxBridge.I.deleteAPN(name);
    await loadAPNs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Access Point Names"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const APNEditPage()),
              );
              loadAPNs();
            },
          )
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView(
              children: apns.map((a) {
                final name = a["name"] ?? "Unknown";
                final apn = a["apn"] ?? "";

                return ListTile(
                  title: Text(name,
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text(apn,
                      style: const TextStyle(color: Colors.white70)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (currentApn == name)
                        const Icon(Icons.check, color: Colors.greenAccent),

                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => APNEditPage(
                                existing: a,
                              ),
                            ),
                          );
                          loadAPNs();
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => deleteAPN(name),
                      ),
                    ],
                  ),
                  onTap: () => selectAPN(name),
                );
              }).toList(),
            ),
    );
  }
}
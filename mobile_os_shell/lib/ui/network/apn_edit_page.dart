import 'package:flutter/material.dart';
import '../../linux_bridge.dart';

class APNEditPage extends StatefulWidget {
  final Map<String, String>? existing;

  const APNEditPage({super.key, this.existing});

  @override
  State<APNEditPage> createState() => _APNEditPageState();
}

class _APNEditPageState extends State<APNEditPage> {
  final nameCtrl = TextEditingController();
  final apnCtrl = TextEditingController();
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.existing != null) {
      nameCtrl.text = widget.existing!["name"] ?? "";
      apnCtrl.text = widget.existing!["apn"] ?? "";
      userCtrl.text = widget.existing!["user"] ?? "";
      passCtrl.text = widget.existing!["pass"] ?? "";
    }
  }

  Future<void> save() async {
    await LinuxBridge.I.saveAPN(
      nameCtrl.text,
      apnCtrl.text,
      userCtrl.text,
      passCtrl.text,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.existing == null ? "Add APN" : "Edit APN"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          field("Name", nameCtrl),
          field("APN", apnCtrl),
          field("Username", userCtrl),
          field("Password", passCtrl),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: save,
            child: const Text("Save APN"),
          )
        ],
      ),
    );
  }

  Widget field(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: c,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white38),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent),
          ),
        ),
      ),
    );
  }
}
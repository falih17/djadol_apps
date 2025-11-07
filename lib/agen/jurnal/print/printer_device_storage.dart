import 'dart:convert';

import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrinterDeviceStorage {
  PrinterDeviceStorage._();

  static const _keyPreferredPrinter = 'preferred_printer_device';

  static Future<void> save(BluetoothInfo device) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode({
      'name': device.name,
      'mac': device.macAdress,
    });
    await prefs.setString(_keyPreferredPrinter, payload);
  }

  static Future<BluetoothInfo?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = prefs.getString(_keyPreferredPrinter);
    if (payload == null) return null;
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final name = data['name'] as String? ?? '';
      final mac = data['mac'] as String? ?? '';
      if (mac.isEmpty) return null;
      return BluetoothInfo(name: name, macAdress: mac);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPreferredPrinter);
  }
}

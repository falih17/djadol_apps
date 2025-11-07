import 'package:djadol_mobile/agen/jurnal/print/journal_receipt_printer.dart';
import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrinterSettingsPage extends StatefulWidget {
  const PrinterSettingsPage({super.key});

  @override
  State<PrinterSettingsPage> createState() => _PrinterSettingsPageState();
}

class _PrinterSettingsPageState extends State<PrinterSettingsPage> {
  List<BluetoothInfo> _devices = [];
  BluetoothInfo? _connectedDevice;
  bool _isConnected = false;
  bool _isFetchingDevices = false;
  bool _isCheckingStatus = false;
  bool _isTestingPrint = false;
  String? _connectingAddress;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _refreshDevices(),
      _refreshConnectionStatus(),
    ]);
  }

  Future<void> _refreshDevices() async {
    setState(() {
      _isFetchingDevices = true;
    });
    final devices = await JournalReceiptPrinter.bondedDevices();
    if (!mounted) return;
    setState(() {
      _devices = devices;
      _isFetchingDevices = false;
    });
  }

  Future<void> _refreshConnectionStatus() async {
    final connected = await PrintBluetoothThermal.connectionStatus;
    if (!mounted) return;
    setState(() {
      _isConnected = connected;
      if (!connected) {
        _connectedDevice = null;
      }
    });
  }

  Future<void> _connectTo(BluetoothInfo device) async {
    setState(() {
      _connectingAddress = device.macAdress;
    });
    try {
      final success = await PrintBluetoothThermal.connect(
        macPrinterAddress: device.macAdress,
      );
      if (!success) throw Exception('Gagal menyambungkan');
      if (!mounted) return;
      setState(() {
        _connectedDevice = device;
        _isConnected = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terhubung ke ${device.name.isEmpty ? device.macAdress : device.name}'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyambungkan: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _connectingAddress = null;
        });
      }
    }
  }

  Future<void> _disconnect() async {
    try {
      await PrintBluetoothThermal.disconnect;
      await _refreshConnectionStatus();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Printer terputus')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memutus koneksi: $e')),
      );
    }
  }

  Future<void> _checkStatus() async {
    setState(() {
      _isCheckingStatus = true;
    });
    final connected = await PrintBluetoothThermal.connectionStatus;
    if (!mounted) return;
    setState(() {
      _isConnected = connected;
      _isCheckingStatus = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          connected ? 'Printer terhubung' : 'Printer belum terhubung',
        ),
      ),
    );
  }

  Future<void> _testPrint() async {
    if (!_isConnected || _connectedDevice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sambungkan printer terlebih dahulu')),
      );
      return;
    }
    setState(() {
      _isTestingPrint = true;
    });
    try {
      await JournalReceiptPrinter.printTestTicket(
        device: _connectedDevice,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perintah test print dikirim')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal test print: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isTestingPrint = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Printer'),
        actions: [
          IconButton(
            onPressed: _isFetchingDevices ? null : _refreshDevices,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDevices,
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _StatusCard(
              isConnected: _isConnected,
              connectedDevice: _connectedDevice,
              isChecking: _isCheckingStatus,
              isTesting: _isTestingPrint,
              onCheckStatus: _checkStatus,
              onTestPrint: _testPrint,
              onDisconnect: _isConnected ? _disconnect : null,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Printer Terpasang',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (_isFetchingDevices)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (_devices.isEmpty && !_isFetchingDevices)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Belum ada printer yang terpasang.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pastikan printer bluetooth sudah dipasangkan melalui pengaturan perangkat.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ..._devices.map(
              (device) {
                final isCurrent =
                    _connectedDevice?.macAdress == device.macAdress &&
                        _isConnected;
                final isConnecting = _connectingAddress == device.macAdress;
                return Card(
                  child: ListTile(
                    leading: Icon(
                      isCurrent ? Icons.print : Icons.bluetooth,
                      color: isCurrent ? Colors.green : Colors.blueGrey,
                    ),
                    title: Text(device.name.isEmpty ? 'Printer' : device.name),
                    subtitle: Text(device.macAdress),
                    trailing: isCurrent
                        ? const Chip(
                            label: Text('Terhubung'),
                            backgroundColor: Colors.greenAccent,
                          )
                        : FilledButton(
                            onPressed: isConnecting
                                ? null
                                : () => _connectTo(device),
                            child: isConnecting
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Hubungkan'),
                          ),
                  ),
                );
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final bool isConnected;
  final BluetoothInfo? connectedDevice;
  final bool isChecking;
  final bool isTesting;
  final VoidCallback? onCheckStatus;
  final VoidCallback? onTestPrint;
  final VoidCallback? onDisconnect;

  const _StatusCard({
    required this.isConnected,
    required this.connectedDevice,
    required this.isChecking,
    required this.isTesting,
    this.onCheckStatus,
    this.onTestPrint,
    this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isConnected ? Colors.green : Colors.redAccent;
    final statusText = isConnected ? 'Terhubung' : 'Tidak terhubung';
    final deviceName = connectedDevice?.name ?? 'Belum dipilih';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.circle, size: 14, color: statusColor),
                const SizedBox(width: 8),
                Text(
                  statusText,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Printer: $deviceName',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                OutlinedButton.icon(
                  onPressed: onCheckStatus,
                  icon: isChecking
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.bluetooth_searching),
                  label: const Text('Cek Status'),
                ),
                FilledButton.icon(
                  onPressed: isTesting ? null : onTestPrint,
                  icon: isTesting
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.print),
                  label: Text(isTesting ? 'Menguji...' : 'Test Print'),
                ),
                if (onDisconnect != null)
                  TextButton.icon(
                    onPressed: onDisconnect,
                    icon: const Icon(Icons.link_off),
                    label: const Text('Putuskan'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

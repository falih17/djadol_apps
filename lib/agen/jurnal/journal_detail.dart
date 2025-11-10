import 'package:djadol_mobile/agen/jurnal/jurnal.dart';
import 'package:djadol_mobile/agen/jurnal/print/journal_receipt_printer.dart';
import 'package:djadol_mobile/agen/jurnal/print/printer_device_storage.dart';
import 'package:djadol_mobile/agen/jurnal/print/printer_settings_page.dart';
import 'package:djadol_mobile/core/pages/async_value.dart';
import 'package:djadol_mobile/core/pages/empty_page.dart';
import 'package:djadol_mobile/core/utils/constans.dart';
import 'package:djadol_mobile/core/utils/ext_currency.dart';
import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../core/utils/api_service.dart';

class JurnalDetailPage extends StatefulWidget {
  final Jurnal item;
  const JurnalDetailPage({super.key, required this.item});

  @override
  State<JurnalDetailPage> createState() => _JurnalDetailPageState();
}

class _JurnalDetailPageState extends State<JurnalDetailPage> {
  late Future<AsyncValue<Jurnal>> _future;
  bool _isPrinting = false;
  bool _isPrinterConnected = false;
  BluetoothInfo? _preferredPrinter;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
    _refreshPrinterStatus();
  }

  Future<void> _refreshPrinterStatus() async {
    final device = await PrinterDeviceStorage.load();
    final isConnected = await PrintBluetoothThermal.connectionStatus;
    if (!mounted) return;
    setState(() {
      _preferredPrinter = device;
      _isPrinterConnected = device != null && isConnected;
    });
  }

  Future<AsyncValue<Jurnal>> fetchData() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      Map<String, dynamic> data = {
        'jurnal_id': widget.item.id,
      };
      List result = await ApiService().getList('/all/33', 0, 1000, data: data);
      widget.item.detail = result.map((i) => JurnalDetail.fromMap(i)).toList();
      return AsyncValue.success(widget.item);
    } catch (e) {
      debugPrint(e.toString());
      return AsyncValue.failure("Error Loading Data");
    }
  }

  Future<void> _printWithDevice(
    Jurnal jurnal,
    BluetoothInfo device,
  ) async {
    setState(() {
      _isPrinting = true;
    });
    try {
      await JournalReceiptPrinter.printJournal(jurnal, device: device);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Struk dikirim ke ${device.name.isEmpty ? 'printer' : device.name}'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mencetak: $e')),
      );
      await _openPrinterSettings();
    } finally {
      if (mounted) {
        setState(() {
          _isPrinting = false;
        });
      }
    }
  }

  Future<void> _handlePrint(Jurnal jurnal) async {
    if (!_isPrinterConnected || _preferredPrinter == null) {
      await _openPrinterSettings();
    }
    if (!_isPrinterConnected || _preferredPrinter == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan hubungkan printer terlebih dahulu')),
      );
      return;
    }
    await _printWithDevice(jurnal, _preferredPrinter!);
  }

  Future<void> _openPrinterSettings() async {
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PrinterSettingsPage(),
      ),
    );
    await _refreshPrinterStatus();
  }

  Widget _buildPrimaryButton(Jurnal jurnal) {
    final ready = _isPrinterConnected && _preferredPrinter != null;
    final bool isDetailEmpty = jurnal.detail.isEmpty;
    final bool disablePrint = _isPrinting || isDetailEmpty;

    final VoidCallback? onPressed = ready
        ? (disablePrint ? null : () => _handlePrint(jurnal))
        : (_isPrinting ? null : () => _openPrinterSettings());

    final Color backgroundColor = ready ? Colors.green : Colors.grey;
    final Widget icon = ready
        ? (_isPrinting
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.print))
        : const Icon(Icons.settings_bluetooth);
    final String label = ready
        ? (_isPrinting ? 'Mencetak...' : 'Print Thermal')
        : 'Hubungkan printer';

    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
      ),
      icon: icon,
      label: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
      ),
      body: ZPageFuture<Jurnal>(
        future: _future,
        success: (value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.item.retailIdName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: (value.detail.isEmpty)
                      ? const EmptyPage()
                      : ListView.builder(
                          itemCount: value.detail.length,
                          itemBuilder: (context, index) {
                            final detail = value.detail[index];
                            return Card(
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: detail.picture.isNotEmpty
                                          ? Image.network(
                                              detail.picture,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.image,
                                                color: Colors.grey,
                                                size: 32,
                                              ),
                                            ),
                                    ),
                                  ),
                                  Flexible(
                                    child: ListTile(
                                      title: Text(
                                        detail.productName,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '${detail.count} x ${detail.price.toString().toCurrency()}'),
                                          Text(
                                            (detail.subtotal * -1)
                                                .toString()
                                                .toCurrency(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Constants.mColorBlue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total: ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        value.total.toString().toCurrency(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: _buildPrimaryButton(value),
                  ),
                ),
                const SizedBox(
                  height: 8,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

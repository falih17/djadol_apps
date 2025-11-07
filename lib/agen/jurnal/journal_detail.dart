import 'package:djadol_mobile/agen/jurnal/jurnal.dart';
import 'package:djadol_mobile/agen/jurnal/print/journal_receipt_printer.dart';
import 'package:djadol_mobile/agen/jurnal/print/printer_device_storage.dart';
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
  BluetoothInfo? _preferredPrinter;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
    _loadPreferredPrinter();
  }

  Future<void> _loadPreferredPrinter() async {
    final device = await PrinterDeviceStorage.load();
    if (!mounted) return;
    setState(() {
      _preferredPrinter = device;
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

  Future<BluetoothInfo?> _selectPrinter() async {
    final devices = await JournalReceiptPrinter.bondedDevices();
    if (!mounted) return null;
    if (devices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada printer bluetooth terpasang'),
        ),
      );
      return null;
    }

    return showModalBottomSheet<BluetoothInfo>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: ListView(
            children: devices
                .map(
                  (device) => ListTile(
                        title: Text(device.name.isEmpty ? 'Printer' : device.name),
                        subtitle: Text(device.macAdress),
                        onTap: () => Navigator.of(ctx).pop(device),
                      ),
                )
                .toList(),
          ),
        );
      },
    );
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
    } finally {
      if (mounted) {
        setState(() {
          _isPrinting = false;
        });
      }
    }
  }

  Future<BluetoothInfo?> _selectAndSavePrinter() async {
    final device = await _selectPrinter();
    if (!mounted || device == null) return null;
    await PrinterDeviceStorage.save(device);
    setState(() {
      _preferredPrinter = device;
    });
    return device;
  }

  Future<void> _handlePrint(Jurnal jurnal) async {
    var device = _preferredPrinter;
    device ??= await _selectAndSavePrinter();
    if (!mounted || device == null) return;
    await _printWithDevice(jurnal, device);
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
                    child: FilledButton.icon(
                      onPressed: _isPrinting || value.detail.isEmpty
                          ? null
                          : () => _handlePrint(value),
                      icon: _isPrinting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.print),
                      label: Text(
                        _isPrinting ? 'Mencetak...' : 'Print Thermal',
                      ),
                    ),
                  ),
                ),
                if (_preferredPrinter != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Printer: ${_preferredPrinter!.name.isEmpty ? _preferredPrinter!.macAdress : _preferredPrinter!.name}',
                          textAlign: TextAlign.center,
                        ),
                        TextButton.icon(
                          onPressed: _isPrinting ? null : _selectAndSavePrinter,
                          icon: const Icon(Icons.edit),
                          label: const Text('Ganti Printer'),
                        ),
                      ],
                    ),
                  ),
                if (_preferredPrinter == null)
                  TextButton.icon(
                    onPressed: _isPrinting ? null : _selectAndSavePrinter,
                    icon: const Icon(Icons.print_outlined),
                    label: const Text('Pilih Printer'),
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

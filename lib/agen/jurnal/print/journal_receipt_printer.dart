import 'package:djadol_mobile/agen/jurnal/jurnal.dart';
import 'package:djadol_mobile/core/utils/ext_currency.dart';
import 'package:djadol_mobile/core/utils/store.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class JournalReceiptPrinter {
  JournalReceiptPrinter._();
  static const _logoPath = 'assets/images/djadol_bw.jpeg';
  static img.Image? _logoImage;

  static Future<List<BluetoothInfo>> bondedDevices() async {
    try {
      return await PrintBluetoothThermal.pairedBluetooths;
    } catch (e) {
      debugPrint('Failed to load bonded devices: $e');
      return [];
    }
  }

  static Future<void> printJournal(
    Jurnal jurnal, {
    required BluetoothInfo device,
  }) async {
    try {
      await _ensureConnection(device: device);
      final bytes = await _buildJournalBytes(jurnal);
      await PrintBluetoothThermal.writeBytes(bytes);
    } catch (e) {
      debugPrint('Failed to print journal: $e');
      rethrow;
    }
  }

  static Future<void> printTestTicket({BluetoothInfo? device}) async {
    try {
      await _ensureConnection(device: device);
      final bytes = await _buildTestBytes();
      await PrintBluetoothThermal.writeBytes(bytes);
    } catch (e) {
      debugPrint('Failed to print test ticket: $e');
      rethrow;
    }
  }

  static Future<void> _ensureConnection({BluetoothInfo? device}) async {
    final isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected) return;
    final mac = device?.macAdress;
    if (mac == null || mac.isEmpty) {
      throw Exception('Printer belum terhubung');
    }
    final success = await PrintBluetoothThermal.connect(
      macPrinterAddress: mac,
    );
    if (!success) {
      throw Exception('Gagal menghubungkan printer');
    }
  }

  static Future<List<int>> _buildJournalBytes(Jurnal jurnal) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    final bytes = <int>[];

    // await _appendLogo(bytes, generator);

    bytes.addAll(generator.text(
      "Djava",
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    ));
    bytes.addAll(generator.text(
      "Distributor Gresik",
      styles: const PosStyles(align: PosAlign.center, bold: true),
    ));
    bytes.addAll(generator.text(
      "Jl. Sedayu - Gresik",
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(generator.text(
      "0819-3803-8445",
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(generator.feed(1));

    bytes.addAll(generator.text(
      "Bukti Pembayaran",
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(generator.feed(1));

    bytes.addAll(generator.hr());
    bytes.addAll(generator.text(
      jurnal.retailIdName,
      styles: const PosStyles(align: PosAlign.center),
    ));

    bytes.addAll(generator.hr());

    int countItem = 0;

    for (final detail in jurnal.detail) {
      final subtotal = detail.price * detail.count;
      countItem += detail.count;
      bytes.addAll(generator.text(
        detail.productName,
        styles: const PosStyles(bold: true),
      ));
      bytes.addAll(
        generator.row(
          [
            PosColumn(
              text: '${detail.count} x ${detail.price.toString().toCurrency()}',
              width: 6,
            ),
            PosColumn(
              text: subtotal.toString().toCurrency(),
              width: 6,
              styles: const PosStyles(align: PosAlign.right),
            ),
          ],
        ),
      );

      bytes.addAll(generator.feed(1));
    }

    bytes.addAll(generator.hr(ch: '='));
    bytes.addAll(generator.row([
      PosColumn(
        text: 'TOTAL ($countItem qty)',
        width: 6,
        styles: const PosStyles(bold: true),
      ),
      PosColumn(
        text: jurnal.total.toString().toCurrency(),
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
          bold: true,
          height: PosTextSize.size2,
        ),
      ),
    ]));
    bytes.addAll(generator.feed(1));
    bytes.addAll(generator.text(
      'Tanggal: ${jurnal.createdAt}',
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(generator.text(
      'Sales : (${Store().userId}) ${Store().fullName}',
      styles: const PosStyles(align: PosAlign.center),
    ));

    bytes.addAll(generator.feed(1));
    bytes.addAll(generator.text(
      'Terima Kasih',
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(generator.feed(1));

    bytes.addAll(generator.feed(2));

    return bytes;
  }

  static Future<List<int>> _buildTestBytes() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    final bytes = <int>[];

    // await _appendLogo(bytes, generator);

    bytes.addAll(generator.text(
      'DJADOL MOBILE',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    ));
    bytes.addAll(generator.text(
      'Test Print Thermal',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    ));
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text('Jika teks ini terbaca jelas,'));
    bytes.addAll(generator.text('printer sudah terhubung dengan aplikasi.'));
    bytes.addAll(generator.feed(1));
    bytes.addAll(generator.text(
      'Terima kasih.',
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(generator.feed(2));

    return bytes;
  }

  static Future<void> _appendLogo(
    List<int> bytes,
    Generator generator,
  ) async {
    final logo = await _loadLogo();
    if (logo == null) return;
    bytes.addAll(
      generator.imageRaster(
        logo,
        align: PosAlign.center,
      ),
    );
    bytes.addAll(generator.feed(1));
  }

  static Future<img.Image?> _loadLogo() async {
    if (_logoImage != null) {
      return _logoImage;
    }
    try {
      final data = await rootBundle.load(_logoPath);
      final decoded = img.decodeImage(data.buffer.asUint8List());
      if (decoded == null) return null;
      final targetWidth = 192; // half of printable width
      final resized = decoded.width == targetWidth
          ? decoded
          : img.copyResize(
              decoded,
              width: targetWidth,
            );
      _logoImage = resized;
      return _logoImage;
    } catch (e) {
      debugPrint('Failed to load logo: $e');
      return null;
    }
  }
}

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:self_bill/features/home/models/product_model.dart';
import 'dart:typed_data';

class BluetoothPrintService {
  Future<void> printReceipt(List<Product> products, double total, String paymentMethod) async {
    // Request permissions
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();

    // Load printer capabilities
    const PaperSize paper = PaperSize.mm58;
    final profile = await CapabilityProfile.load();

    // Build the receipt bytes
    final bytes = await _buildReceipt(paper, profile, products, total, paymentMethod);
    final FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

    // TODO: Send `bytes` to your selected printer using esc_pos_bluetooth or any other method
     // Step 1: Get bonded (paired) devices
    List<BluetoothDevice> bondedDevices = await bluetooth.getBondedDevices();
    if (bondedDevices.isEmpty) {
      debugPrint('❌ No paired Bluetooth printers found.');
      return;
    }

    // Step 2: Let’s assume user selects the first paired printer for demo
    BluetoothDevice selectedPrinter = bondedDevices.first;
    debugPrint('🖨️ Connecting to: ${selectedPrinter.name} (${selectedPrinter.address})');

    // Step 3: Connect and print
    try {
      final connection = await BluetoothConnection.toAddress(selectedPrinter.address);
      debugPrint('✅ Connected to printer.');
      connection.output.add(Uint8List.fromList(bytes));
      await connection.output.allSent;
      debugPrint('🧾 Receipt sent successfully!');
      connection.finish(); // Close connection
    } catch (e) {
      debugPrint('❌ Failed to connect/print: $e');
    }



    debugPrint('✅ Receipt bytes generated: ${bytes.length}');
  }

  Future<List<int>> _buildReceipt(
    PaperSize paper,
    CapabilityProfile profile,
    List<Product> products,
    double total,
    String paymentMethod,
  ) async {
    final generator = Generator(paper, profile);
    List<int> bytes = [];

    bytes += generator.text(
      'INDIA GATE',
      styles: PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2),
    );
    bytes += generator.text(' 070-3563062', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text(' Hobbemaplein 50, 2526 JB, NL', styles: PosStyles(align: PosAlign.center));
    bytes += generator.hr();

    for (var item in products) {
      final qty = item.quantity;
      final name = item.name.toUpperCase();
      final price = item.price;
      final totalPrice = (qty * price).toStringAsFixed(2);

      bytes += generator.row([
        PosColumn(text: '${qty}x $name', width: 8),
        PosColumn(
          text: 'eur $totalPrice',
          width: 4,
          styles: PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(text: '$paymentMethod:', width: 8),
      PosColumn(
        text: 'eur ${total.toStringAsFixed(2)}',
        width: 4,
        styles: PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(text: 'TOTAL:', width: 8, styles: PosStyles(bold: true)),
      PosColumn(
        text: 'eur ${total.toStringAsFixed(2)}',
        width: 4,
        styles: PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    bytes += generator.text('PRODUCTS: ${products.length}');
    bytes += generator.text('RETURN eur 0');
    bytes += generator.feed(1);
    bytes += generator.text(
      'THANK YOU! VISIT AGAIN!',
      styles: PosStyles(align: PosAlign.center),
      
    );
    bytes += generator.text(
      'M POS AUCTECH',
      styles: PosStyles(align: PosAlign.center),
      
    );
    bytes += generator.feed(1);
    bytes += generator.cut();

    return bytes;
  }
}

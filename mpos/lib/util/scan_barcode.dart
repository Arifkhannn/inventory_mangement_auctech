import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Scanner {
  Future<String> scanBarcode() async {
    String scanBarCodeRes = '';
    try {
      scanBarCodeRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE,
      );
      print('barcodeValue: $scanBarCodeRes');
    } catch (e) {
      print('Barcode scan error: $e');
    }
    return scanBarCodeRes;
  }
}

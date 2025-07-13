import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:self_bill/features/bill/logic/printing_function.dart';
import 'package:self_bill/features/home/logic/home_bloc.dart';
import 'dart:math';

class ReceiptPreviewScreen extends StatelessWidget {
  final String paymentMethod;
  final double? return_Amount;

  ReceiptPreviewScreen({
    required this.paymentMethod,
    this.return_Amount,
    super.key,
  });

  BluetoothPrintService printService = BluetoothPrintService();
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final cartItems = context.read<ScanBloc>().cartItems;

    final total = cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Your Receipt")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text("INDIA GATE",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 4),
            const Center(child: Text("📞 070-3563062")),
            const Center(child: Text("🏪 Hobbemaplein 50, 2526 JB, NL")),
            const Divider(thickness: 1.5),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (_, index) {
                  final item = cartItems[index];
                  final qtyPrefix =
                      item.quantity > 1 ? "${item.quantity.toInt()}x " : "";
                  final name = item.name.toUpperCase();
                  final amount =
                      (item.quantity * item.price).toStringAsFixed(2);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text("$qtyPrefix$name",
                              style: const TextStyle(fontSize: 14)),
                        ),
                        Text("€ $amount", style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$paymentMethod:",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("€ ${total.toStringAsFixed(2)}"),
              ],
            ),
            const Divider(thickness: 1.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("TOTAL",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("€ ${total.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
            Text("PRODUCTS: ${cartItems.length}"),
            Text("Return:  €${(return_Amount ?? 0 as num)}"),
            const SizedBox(height: 12),
            const Center(child: Text("THANK YOU! VISIT AGAIN!")),
            Center(child: Text(DateFormat("M/d/y, h:mm:ss a").format(now))),
            Center(
                child: Text(
                    "GENERATED: ${DateFormat("dd/MM/yyyy, HH:mm:ss").format(now)}")),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton.icon(
                onPressed: () =>
                    printService.printReceipt(cartItems, total, paymentMethod),
                icon: const Icon(Icons.print),
                label: const Text('Print'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

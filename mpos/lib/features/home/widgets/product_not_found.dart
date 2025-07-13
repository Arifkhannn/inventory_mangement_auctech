import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_bill/features/home/logic/home_bloc.dart';
import 'package:self_bill/features/home/logic/home_events.dart';

import 'package:self_bill/features/home/models/product_model.dart';
import 'package:self_bill/util/colors.dart';

class ManualProductDialog extends StatefulWidget {
  final String barcode; // passed from BLoC when product not found

  const ManualProductDialog({super.key, required this.barcode});

  @override
  State<ManualProductDialog> createState() => _ManualProductDialogState();
}

class _ManualProductDialogState extends State<ManualProductDialog> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: appGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text(
              'Enter Product Details',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Barcode: ${widget.barcode}',
                  style: const TextStyle(color: Colors.yellowAccent, fontSize: 18),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            actions: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<ScanBloc>().add(ShowCartItemsEvent());
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255, 230, 234, 121),
                    Color.fromARGB(244, 250, 242, 10)
                  ]),
                ),
                child: TextButton(
                  onPressed: () {
                    final priceText = _priceController.text.replaceAll(',', '.');
                    final price = double.tryParse(priceText) ?? 0;
                    final quantity = int.tryParse(_quantityController.text) ?? 1;

                    final product = Product(
                      barCode: widget.barcode,
                      name: 'Other',
                      price: price,
                      quantity: quantity,
                    );

                    context.read<ScanBloc>().add(AddProductToCartEvent( product));
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(
                        color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showManualProductDialog({
  required BuildContext context,
  required String barcode,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return ManualProductDialog(barcode: barcode);
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}

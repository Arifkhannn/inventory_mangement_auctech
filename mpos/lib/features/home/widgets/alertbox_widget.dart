import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_bill/features/home/logic/home_bloc.dart';
import 'package:self_bill/features/home/logic/home_events.dart';
import 'package:self_bill/features/home/models/product_model.dart';
import 'package:self_bill/util/colors.dart';
import 'package:flutter/services.dart';

class ProductDialog extends StatefulWidget {
  final Product product;
  final void Function(int quantity) onAdd;

  const ProductDialog({super.key, required this.product, required this.onAdd});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  int quantity = 1;

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
            backgroundColor:
                Colors.transparent, // Make the dialog itself transparent
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              widget.product.name,
              style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  'https://www.shutterstock.com/image-photo/wide-aisles-supermarket-selective-focus-260nw-2318570191.jpg',
                  height: 140,
                  width: 700,
                ),
                const SizedBox(height: 8),
                Text(
                  'Price: € ${widget.product.price.toStringAsFixed(2)}',
                  style:
                      const TextStyle(color: Colors.yellowAccent, fontSize: 25),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: Colors.yellow,
                      ),
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      },
                    ),
                    Text(
                      '$quantity',
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.yellowAccent,
                      ),
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        setState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(16)),
                child: TextButton(
                  onPressed: () {
                    
                    Navigator.of(context).pop();
                    context.read<ScanBloc>().add(ShowCartItemsEvent());
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(255, 230, 234, 121),
                      Color.fromARGB(244, 250, 242, 10)
                    ])),
                child: TextButton(
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    widget.onAdd(quantity);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
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

void showAnimatedProductDialog({
  required BuildContext context,
  required Product product,
  required void Function(int quantity) onAdd,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return ProductDialog(
        product: product,
        onAdd: onAdd,
      );
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

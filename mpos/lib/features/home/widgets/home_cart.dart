// cart_item_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:self_bill/features/home/logic/home_bloc.dart';
import 'package:self_bill/features/home/logic/home_events.dart';
import 'package:self_bill/features/home/models/product_model.dart';

class CartItemWidget extends StatefulWidget {
  final Product product;
  final int index;

  const CartItemWidget({super.key, required this.product, required this.index});

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    final total = widget.product.quantity * widget.product.price;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [],
          ),
          child: Row(
            children: [
              Text('${widget.index}-', style: const TextStyle(color:Color.fromARGB(255, 243, 250, 117),fontSize: 20),),
              // const Icon(Icons.shopping_cart,
              //  size: 30, color: Color.fromARGB(255, 243, 250, 117)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.product.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color.fromARGB(255, 239, 245, 77))),
                    Text(
                      'Qty: ${widget.product.quantity}',
                      style: const TextStyle(color: Colors.yellow),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    ' € ${widget.product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    'Total: € ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 117,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(18),
                      border:
                          Border.all(color: const Color.fromARGB(255, 255, 234, 0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.remove,
                            size: 20,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            HapticFeedback.heavyImpact();
                            setState(() {
                              widget.product.quantity--;
                            });
                            context.read<ScanBloc>().add(
                                UpdateProductQuantityEvent(
                                    widget.product.barCode,
                                    widget.product.quantity));
                          },
                        ),
                        Text(
                          '${widget.product.quantity}',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.green),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.add,
                            size: 20,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            HapticFeedback.heavyImpact();
                            setState(() {
                              widget.product.quantity++;
                            });
                            context.read<ScanBloc>().add(
                                UpdateProductQuantityEvent(
                                    widget.product.barCode,
                                    widget.product.quantity));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Dashed line as separator BELOW the card
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Dash(
            direction: Axis.horizontal,
            length: 320,
            dashLength: 15,
            dashColor: Colors.white,
            dashThickness: 1.3,
          ),
        ),
      ],
    );
  }
}

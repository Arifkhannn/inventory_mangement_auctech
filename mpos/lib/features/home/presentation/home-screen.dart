import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_bill/features/home/logic/home_bloc.dart';
import 'package:self_bill/features/home/logic/home_events.dart';
import 'package:self_bill/features/home/logic/home_states.dart';
import 'package:self_bill/features/home/widgets/alertbox_widget.dart';
import 'package:self_bill/features/home/widgets/home_cart.dart';
import 'package:self_bill/features/home/widgets/home_container.dart';
import 'package:self_bill/features/home/widgets/home_widgets.dart';
import 'package:self_bill/features/home/widgets/product_not_found.dart';
import 'package:self_bill/util/colors.dart';
import 'package:self_bill/util/scan_barcode.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final TextEditingController searchController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          GradientBottomNavBar(currentIndex: 0, onTap: (int) {}),
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(62),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 210,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 8.0),
            child: Transform.scale(
              scale: 1.6, // adjust the scale factor as needed
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          actions: [
            Padding(
                padding: EdgeInsets.only(top: 14, right: 10),
                child: CircleAvatar(
                    radius: 20,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        :const AssetImage('assets/user_default.png')as ImageProvider)),
            SizedBox(width: 12),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchInputBar(
                onSubmitted: (st) {},
                controller: searchController,
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                ScanBarcode(
                  callback: () async {
                    Scanner scanner = Scanner();
                    final barcode = await scanner.scanBarcode();
        
                    if (barcode == -1) {
                      print('barcode not scanned');
                    } else {
                      context
                          .read<ScanBloc>()
                          .add(FetchProductByBarcodeEvent(barcode));
                      HapticFeedback.vibrate();
                    }
                  },
                ),
                BlocBuilder<ScanBloc, ScanState>(
                  builder: (context, state) {
                    if (state is ProductAddedToCart) {
                      return ShoppingCart(itemCount: state.cartItems.length);
                    } else {
                      return const ShoppingCart(
                          itemCount: 0); // default when no items
                    }
                  },
                )
              ]),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text('Added Poducts --',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
              ),
        
              //bloc listrner---
              BlocListener<ScanBloc, ScanState>(
                listener: (context, state) {
                  if (state is ProductLoaded) {
                    showAnimatedProductDialog(
                        context: context,
                        product: state.product,
                        onAdd: (quantity) {
                          final updatedProduct =
                              state.product.copyWith(quantity: quantity);
                          context
                              .read<ScanBloc>()
                              .add(AddProductToCartEvent(updatedProduct));
                        });
                  }
                  if (state is ProductNotFound) {
                    showManualProductDialog(
                        context: context, barcode: state.barcode);
                  }
                },
                child: Container(),
              ),
        
              const SizedBox(
                height: 20,
              ),
              GradientContainer(
                borderGradient: appGradient,
                backgroundGradient: appGradient,
                child: BlocBuilder<ScanBloc, ScanState>(
                  builder: (context, state) {
                    if (state is ProductAddedToCart) {
                      final products = state.cartItems;
        
                      return ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (_, index) {
                          final product = products[index];
                          return CartItemWidget(
                            product: product,
                            index: index + 1,
                          ); // Your custom widget
                        },
                      );
                    } else if (state is ScanLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return const Center(child: Text("No products yet."));
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

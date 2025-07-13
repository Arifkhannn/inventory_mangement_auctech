import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_bill/features/bill/presentation/select_payment.dart';
import 'package:self_bill/features/home/logic/home_bloc.dart';
import 'package:self_bill/features/home/logic/home_states.dart';
import 'package:self_bill/features/home/widgets/home_cart.dart';
import 'package:self_bill/util/animation_route.dart';
import 'package:self_bill/util/colors.dart';

class MainCartScreen extends StatelessWidget {
  const MainCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, // This allows the body to go behind the AppBar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        
        backgroundColor: Colors.transparent,
        elevation: 5, // Optional: removes shadow
        title: const Center(child: Text("Your Cart",style: TextStyle(color: Color.fromARGB(255, 240, 230, 44),fontWeight: FontWeight.bold),)),
         bottom: PreferredSize(
    preferredSize: const Size.fromHeight(1.0),
    child: Container(
      color: Colors.grey.shade300,
      height: 1.0,
      width: double.infinity,
    ),
  ),
      ),
      body: Stack(
        children: [
          // Gradient background behind everything
          Container(
            decoration: const BoxDecoration(
              gradient: appGradient,
            ),
          ),

          // Main content over the gradient
          BlocBuilder<ScanBloc, ScanState>(
            builder: (context, state) {
              if (state is ProductAddedToCart && state.cartItems.isNotEmpty) {
                final cartItems = state.cartItems;
                final total = cartItems.fold<double>(
                  0,
                  (sum, item) => sum + (item.price * item.quantity),
                );

                return Column(
                  children: [
                   
                    const SizedBox(
                        height: kToolbarHeight -45),
                         // Offset for AppBar
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final product = cartItems[index];
                          return CartItemWidget(product: product,index: index +1,);
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        //color: Colors.white,
                        border: Border(
                            top: BorderSide(color: Colors.grey.shade300)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                         // Text('tax',textAlign: TextAlign.right,),
                          Text(
                            "Total: €${total.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            
                            onPressed: () {
                              Navigator.of(context).push(createBookToFadeRoute(const SelectPayment()));
                            },
                            child: const Text("Generate Bill"),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text("Your cart is empty."),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

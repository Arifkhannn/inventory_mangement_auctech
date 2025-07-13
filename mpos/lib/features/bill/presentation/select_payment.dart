import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_bill/features/bill/presentation/bill_preview.dart';
import 'package:self_bill/features/bill/presentation/select_note.dart';
import 'package:self_bill/features/home/logic/home_bloc.dart';
import 'package:self_bill/util/colors.dart';



class SelectPayment extends StatelessWidget {
  const SelectPayment({super.key});

  @override
  Widget build(BuildContext context) {

    final cartItems = context.read<ScanBloc>().cartItems;

    final total = cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    return Container(
      decoration: const BoxDecoration(
        gradient: appGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Make Scaffold transparent so gradient shows
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(child: Text("Select Payment Method",style: TextStyle(color: Color.fromARGB(255, 234, 212, 15),fontWeight: FontWeight.bold),)),
          backgroundColor: const Color.fromARGB(0, 224, 199, 13),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPaymentOption(
                context,
                icon: Icons.credit_card,
                label: "Credit/Debit Card",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) =>  ReceiptPreviewScreen(paymentMethod: "Card"),
                  ));
                },
              ),
              const SizedBox(height: 16),
              _buildPaymentOption(
                context,
                icon: Icons.euro,
                label: "Cash",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => CashPaymentScreen(totalAmount:total ),
                  ));
                },
              ),
              const SizedBox(height: 16),
              _buildPaymentOption(
                context,
                icon: Icons.qr_code,
                label: "Online",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) =>  ReceiptPreviewScreen(paymentMethod: "Online"),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          
          color: Colors.grey.shade200.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(87, 90, 89, 81),
              blurRadius: 2,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 38, color: Colors.black87),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

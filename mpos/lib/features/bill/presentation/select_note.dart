import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_bill/features/bill/presentation/bill_preview.dart';
import 'package:self_bill/features/home/logic/home_bloc.dart';

class CashPaymentScreen extends StatefulWidget {
  final double totalAmount;

  CashPaymentScreen({required this.totalAmount});

  @override
  _CashPaymentScreenState createState() => _CashPaymentScreenState();
}

class _CashPaymentScreenState extends State<CashPaymentScreen> {
  Map<int, int> noteCount = {};
  final List<int> noteOptions = [5, 10, 20, 50, 100, 200];

  double get totalGiven => noteCount.entries
      .map((e) => e.key * e.value)
      .fold(0, (a, b) => a + b);

  double get returnAmount => totalGiven - widget.totalAmount;

  void addNote(int value) {
    setState(() {
      noteCount[value] = (noteCount[value] ?? 0) + 1;
    });
  }

  void removeNote(int value) {
    if (noteCount[value] != null && noteCount[value]! > 0) {
      setState(() {
        noteCount[value] = noteCount[value]! - 1;
        if (noteCount[value] == 0) noteCount.remove(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = context.read<ScanBloc>().cartItems;

    final total = cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    final Gradient appGradient = LinearGradient(
      colors: [Colors.purpleAccent, Colors.blueAccent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: appGradient),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Cash Payment",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: _cardBox(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tap the notes given by customer:",
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 40),
                     SizedBox(
  height: 250, // adjust based on button height
  child: GridView.count(
    crossAxisCount: 3,
    crossAxisSpacing: 20,
    mainAxisSpacing: 20,
    physics: NeverScrollableScrollPhysics(), // disables scrolling
    children: noteOptions.map((value) {
      return ElevatedButton(
        onPressed: () => addNote(value),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blueAccent,
          elevation: 4,
          minimumSize: Size(60, 120),
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Text(
          "€$value",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      );
    }).toList(),
  ),
)

                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: _cardBox(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Selected Notes:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      if (noteCount.isEmpty)
                        Text("No notes selected")
                      else
                        Wrap(
                          spacing: 8,
                          children: noteCount.entries.map((e) {
                            return Chip(
                              label: Text("€${e.key} x ${e.value}"),
                              deleteIcon: Icon(Icons.remove_circle),
                              onDeleted: () => removeNote(e.key),
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: _cardBox(),
                  child: Column(
                    children: [
                      _infoRow("Total Bill:", "€${widget.totalAmount}"),
                      _infoRow("Cash Given:", "€$totalGiven"),
                      _infoRow(
                        "Return Amount:",
                        returnAmount >= 0
                            ? "€$returnAmount"
                            : "Insufficient",
                        textColor:
                            returnAmount < 0 ? Colors.red : Colors.green,
                      ),
                    ],
                  ),
                ),
                Spacer(),
               SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: returnAmount >= 0
        ? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReceiptPreviewScreen(paymentMethod: 'Cash',return_Amount: returnAmount,),
              ),
            );
          }
        : null,
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 16),
      backgroundColor: Colors.white,
      foregroundColor: Colors.blueAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Text(
      "Confirm Payment",
      style: TextStyle(fontSize: 16),
    ),
  ),
),

              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardBox() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: textColor ?? Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

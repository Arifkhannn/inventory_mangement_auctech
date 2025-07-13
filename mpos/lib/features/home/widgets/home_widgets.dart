import 'package:flutter/material.dart';
import 'package:self_bill/features/cart/presentation/main_cart.dart';
import 'package:self_bill/util/animation_route.dart';
import 'package:self_bill/util/colors.dart';

// scan widget-----


class ScanBarcode extends StatelessWidget {
  final VoidCallback callback;

  const ScanBarcode({
    super.key,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 160,
        height: 130,
        decoration: BoxDecoration(
          gradient: appGradient, // Make sure `appGradient` is defined
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.qr_code_2,
                size: 50,
                color: Colors.white,
              ),
              onPressed: callback,
            ),
            const SizedBox(height: 8),
            const Text(
              'Scan Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// cart widget

class ShoppingCart extends StatelessWidget {
  final int itemCount;

  const ShoppingCart({
    super.key,
    required this.itemCount, // You can pass this from your BLoC
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 160,
        height: 130,
        decoration: BoxDecoration(
          gradient: appGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(createBookToFadeRoute(const MainCartScreen()));

                    print("QR code icon pressed");
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  'Cart',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (itemCount > 0)
              Positioned(
                top: 20,
                right: 50,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.green,
                  child: Text(
                    '$itemCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// serach bar widget

class SearchInputBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSubmitted;

  const SearchInputBar({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          gradient: appGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(6), // Border thickness
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Inner fill color
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.search,
            onSubmitted: onSubmitted,
            decoration: const InputDecoration(
              hintText: 'Search product...',
              hintStyle: TextStyle(),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.blue,
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
      ),
    );
  }
}

//bottom nav bar

class GradientBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GradientBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 81, // Set your desired height here
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          ),
      gradient: appGradient),
      child: Theme(
        data: Theme.of(context).copyWith(
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0), // Adjust padding as needed
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            iconSize: 20, // Adjust icon size
            selectedFontSize: 12, // Adjust label font size
            unselectedFontSize: 12,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
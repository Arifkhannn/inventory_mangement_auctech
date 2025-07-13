class OnboardingModel {
  final String image;
  final String title;
  final String description;
   String? description2;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
     this.description2
  });
}

List<OnboardingModel> onboardingPages = [
  OnboardingModel(
    image: 'assets/grocery_line.png',
    title: 'Welcome to India Gate',
    description: ' "No need to wait in line"',
    description2: 'Tired of standing in long billing queues? With our self-billing app, you can scan items as you shop and complete your checkout directly from your phone—no waiting, no hassle. Just scan, pay, and go....'
  ),
  OnboardingModel(
    image: 'assets/scaning_barcode.jpg',
    title: 'Scan Barcode ',
    description: ' "Use your camera to scan barcodes"',
    description2: '"Simply point your phone at any barcode and let the app do the rest. Our camera-based scanner quickly fetches product details and adds them to your cart—no manual entry needed."'
    
  ),
  OnboardingModel(
    image: 'assets/checkout.jpg',
    title: 'Quick Checkout',
    description: ' "View your bill and pay directly from your device".',
    description2: '"Review your purchases and pay on the go—straight from your mobile device. Skip the lines and enjoy a smooth, contactless checkout experience."'
  ),
];

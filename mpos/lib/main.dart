import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
 // IMPORTANT: Needed for BlocProvider & MultiBlocProvider
import 'package:self_bill/features/home/data/repository/product_scanned.dart';
import 'package:self_bill/features/home/logic/home_bloc.dart'; // Import your ScanBloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_bill/firebase_options.dart';
import 'package:self_bill/util/splash_screen.dart';




void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
   Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ProductRepository productRepository = ProductRepository();

  MyApp({super.key}); // Add key if you're using StatelessWidget

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ScanBloc>(
          create: (_) => ScanBloc(productRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Self Bill App',
        theme: ThemeData(primarySwatch: Colors.orange),
        home: const SplashScreen(),
      ),
    );
  }
}


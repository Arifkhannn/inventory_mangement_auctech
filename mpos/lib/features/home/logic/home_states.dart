import 'package:equatable/equatable.dart';
import 'package:self_bill/features/home/models/product_model.dart';


abstract class ScanState extends Equatable {
  const ScanState();

  @override
  List<Object?> get props => [];
}

class ScanInitial extends ScanState {}

class ScanLoading extends ScanState {}

class ProductLoaded extends ScanState {
  final Product product;

  const ProductLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductAddedToCart extends ScanState {
  final List<Product> cartItems;
  final DateTime updatedAt;

  ProductAddedToCart(this.cartItems) : updatedAt = DateTime.now();

  @override
  List<Object?> get props => [cartItems, updatedAt]; // Ensure updatedAt is part of props
}

class ProductNotFound extends ScanState {
  final String barcode;
  const ProductNotFound(this.barcode);
}

class ScanError extends ScanState {
  final String message;

  const ScanError(this.message);

  @override
  List<Object?> get props => [message];
}

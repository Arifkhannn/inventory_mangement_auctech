import 'package:equatable/equatable.dart';
import 'package:self_bill/features/home/models/product_model.dart';

abstract class ScanEvent extends Equatable {
  const ScanEvent();

  @override
  List<Object?> get props => [];
}

class ScanBarcodeEvent extends ScanEvent {}

class FetchProductByBarcodeEvent extends ScanEvent {
  final String barcode;
  //final String authCode;

  const FetchProductByBarcodeEvent(this.barcode);

  @override
  List<Object?> get props => [
        barcode,
      ];
}

class AddProductToCartEvent extends ScanEvent {
  final Product product;

  const AddProductToCartEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class UpdateProductQuantityEvent extends ScanEvent {
  final String barcode;
  final int quantity;

  const UpdateProductQuantityEvent(this.barcode, this.quantity);

  @override
  List<Object?> get props => [barcode, quantity];
}

class ShowCartItemsEvent extends ScanEvent {}


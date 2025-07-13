import 'package:bloc/bloc.dart';
import 'package:self_bill/features/home/data/repository/product_scanned.dart';
import 'package:self_bill/features/home/logic/home_events.dart';
import 'package:self_bill/features/home/logic/home_states.dart';
import 'package:self_bill/features/home/models/product_model.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final ProductRepository repository;
  final List<Product> _cartItems = [];
  List<Product> get cartItems => List.unmodifiable(_cartItems);

  ScanBloc(this.repository) : super(ScanInitial()) {
    on<ScanBarcodeEvent>(_onScanBarcode);
    on<FetchProductByBarcodeEvent>(_onFetchProductByBarcode);
    on<AddProductToCartEvent>(_onAddProductToCart);
    on<UpdateProductQuantityEvent>(_onUpdateProductQuantity);
    on<ShowCartItemsEvent>(_onShowCartItems);
  }

  Future<void> _onScanBarcode(
      ScanBarcodeEvent event, Emitter<ScanState> emit) async {
    // Barcode scanning UI is handled elsewhere and returns a string.
    // So this event could be removed or used for analytics/logging later.
  }

 Future<void> _onFetchProductByBarcode(
      FetchProductByBarcodeEvent event, Emitter<ScanState> emit) async {
    emit(ScanLoading());
    try {
      final product = await repository.fetchProductByBarcode(event.barcode);
      
      if (product == null) {
        // Emit ProductNotFound state to tell UI to show dialog
        emit(ProductNotFound(event.barcode));
      } else {
        emit(ProductLoaded(product));
      }

    } catch (e) {
      emit(ScanError(e.toString()));
    }
}


  void _onAddProductToCart(
      AddProductToCartEvent event, Emitter<ScanState> emit) {
    final existing = _cartItems
        .indexWhere((element) => element.barCode == event.product.barCode);

    if (existing >= 0) {
      // If already exists, update quantity
      _cartItems[existing].quantity += (event.product.quantity as num).toInt();
    } else {
      _cartItems.add(event.product);
    }

    emit(ProductAddedToCart(List.from(_cartItems)));
  }

  void _onUpdateProductQuantity(
      UpdateProductQuantityEvent event, Emitter<ScanState> emit) {
    final index =
        _cartItems.indexWhere((product) => product.barCode == event.barcode);
    if (index != -1) {
      _cartItems[index].quantity = event.quantity;
      emit(ProductAddedToCart(List.from(_cartItems)));

      if (_cartItems[index].quantity < 1) {
        _cartItems.removeAt(index);
        emit(ProductAddedToCart(List.from(_cartItems)));
      }
    } else {
      emit(const ScanError('Product not found in cart.'));
    }
  }

  void _onShowCartItems(ShowCartItemsEvent event, Emitter<ScanState> emit) {
    emit(ProductAddedToCart(List.from(_cartItems)));
  }
}

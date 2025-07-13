import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:self_bill/features/home/models/product_model.dart';

class ProductRepository {
  final String baseUrl = 'https://pos.dftech.in/pos';

  Future<Product?> fetchProductByBarcode(String barcode) async {
    final url = Uri.parse('$baseUrl/product-by-barcode/$barcode');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': '4c2yPE7r73z5',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == false || data['product'] == null) {
          return null;
        }
        final productData = data['product'];
        print(data);

        return Product.fromJson(productData);
      } else {
        print('Failed to load product: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }
}

import 'package:flutter_test/flutter_test.dart';
import '../../../../../features/product/data/models/product_model.dart';

void main() {
  final productJson = {
    'id': '1',
    'name': 'Sneakers',
    'description': 'Comfortable running shoes',
    'imageUrl': 'https://example.com/image.png',
    'price': 99.99,
  };

  final productModel = ProductModel(
    id: '1',
    name: 'Sneakers',
    description: 'Comfortable running shoes',
    imageUrl: 'https://example.com/image.png',
    price: 99.99,
  );

  test('fromJson should return a valid model', () {
    final result = ProductModel.fromJson(productJson);
    expect(result, isA<ProductModel>());
    expect(result.id, productModel.id);
  });

  test('toJson should return a valid JSON map', () {
    final result = productModel.toJson();
    expect(result, productJson);
  });
}

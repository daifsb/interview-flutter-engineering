import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter/features/products/data/models/product_model.dart';

void main() {
  group('ProductModel.fromJson', () {
    test('parses all fields from valid JSON', () {
      final ProductModel product = ProductModel.fromJson(const <String, dynamic>{
        'id': 1,
        'title': 'Essence Mascara',
        'description': 'Lash-lengthening mascara',
        'price': 49.99,
        'discountPercentage': 10,
        'rating': 4.5,
        'stock': 50,
        'brand': 'Essence',
        'category': 'beauty',
        'thumbnail': 'https://cdn.example.com/thumb.jpg',
        'images': [
          'https://cdn.example.com/1.jpg',
          'https://cdn.example.com/2.jpg',
        ],
      });

      expect(product.id, 1);
      expect(product.title, 'Essence Mascara');
      expect(product.price, 49.99);
      expect(product.discountPercentage, 10.0);
      expect(product.rating, 4.5);
      expect(product.stock, 50);
      expect(product.brand, 'Essence');
      expect(product.category, 'beauty');
      expect(product.images, hasLength(2));
    });

    test('defaults brand to Unknown when null', () {
      final ProductModel product = ProductModel.fromJson(const <String, dynamic>{
        'id': 2,
        'title': 'No-brand item',
        'description': '',
        'price': 10,
        'discountPercentage': 0,
        'rating': 3,
        'stock': 5,
        'brand': null,
        'category': 'misc',
        'thumbnail': '',
        'images': null,
      });

      expect(product.brand, 'Unknown');
      expect(product.images, isEmpty);
    });

    test('computes discountedPrice correctly', () {
      final ProductModel product = ProductModel.fromJson(const <String, dynamic>{
        'id': 3,
        'title': 'Discounted',
        'description': '',
        'price': 100,
        'discountPercentage': 25,
        'rating': 4,
        'stock': 10,
        'brand': 'B',
        'category': 'c',
        'thumbnail': '',
        'images': <dynamic>[],
      });

      expect(product.discountedPrice, 75.0);
    });
  });

  group('ProductListResponse.fromJson', () {
    test('parses paginated response with products', () {
      final ProductListResponse response = ProductListResponse.fromJson(
        <String, dynamic>{
          'products': <Map<String, dynamic>>[
            <String, dynamic>{
              'id': 1,
              'title': 'A',
              'description': '',
              'price': 10,
              'discountPercentage': 0,
              'rating': 4,
              'stock': 5,
              'brand': 'B',
              'category': 'c',
              'thumbnail': '',
              'images': <dynamic>[],
            },
            <String, dynamic>{
              'id': 2,
              'title': 'B',
              'description': '',
              'price': 20,
              'discountPercentage': 0,
              'rating': 3,
              'stock': 8,
              'brand': 'B',
              'category': 'c',
              'thumbnail': '',
              'images': <dynamic>[],
            },
          ],
          'total': 30,
          'skip': 0,
          'limit': 10,
        },
      );

      expect(response.products, hasLength(2));
      expect(response.total, 30);
      expect(response.skip, 0);
      expect(response.limit, 10);
      expect(response.products.first.title, 'A');
    });
  });
}

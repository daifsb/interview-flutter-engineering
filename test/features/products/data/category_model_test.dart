import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter/features/products/data/models/category_model.dart';

void main() {
  group('CategoryModel.fromJson', () {
    test('parses all fields from valid JSON', () {
      final CategoryModel category = CategoryModel.fromJson(
        const <String, dynamic>{
          'slug': 'smartphones',
          'name': 'Smartphones',
          'url': 'https://dummyjson.com/products/category/smartphones',
        },
      );

      expect(category.slug, 'smartphones');
      expect(category.name, 'Smartphones');
      expect(category.url,
          'https://dummyjson.com/products/category/smartphones');
    });

    test('defaults to empty strings when fields are null', () {
      final CategoryModel category = CategoryModel.fromJson(
        const <String, dynamic>{
          'slug': null,
          'name': null,
          'url': null,
        },
      );

      expect(category.slug, '');
      expect(category.name, '');
      expect(category.url, '');
    });
  });

  group('CategoryModel.fromValue', () {
    test('builds slug, name, and url from a single string', () {
      final CategoryModel category = CategoryModel.fromValue('electronics');

      expect(category.slug, 'electronics');
      expect(category.name, 'electronics');
      expect(category.url, '/products/category/electronics');
    });
  });

  group('CategoryModel equality', () {
    test('two instances with same fields are equal', () {
      const CategoryModel a = CategoryModel(
        slug: 'beauty',
        name: 'Beauty',
        url: '/products/category/beauty',
      );
      const CategoryModel b = CategoryModel(
        slug: 'beauty',
        name: 'Beauty',
        url: '/products/category/beauty',
      );

      expect(a, equals(b));
    });
  });
}

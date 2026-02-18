import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;

  double get discountedPrice => price * (1 - (discountPercentage / 100));

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      price: _numToDouble(json['price']),
      discountPercentage: _numToDouble(json['discountPercentage']),
      rating: _numToDouble(json['rating']),
      stock: json['stock'] as int,
      brand: (json['brand'] as String?) ?? 'Unknown',
      category: json['category'] as String,
      thumbnail: json['thumbnail'] as String,
      images: ((json['images'] as List<dynamic>?) ?? const <dynamic>[])
          .map((item) => item.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'brand': brand,
      'category': category,
      'thumbnail': thumbnail,
      'images': images,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        price,
        discountPercentage,
        rating,
        stock,
        brand,
        category,
        thumbnail,
        images,
      ];
}

class ProductListResponse extends Equatable {
  const ProductListResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      products: ((json['products'] as List<dynamic>?) ?? const <dynamic>[])
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as int?) ?? 0,
      skip: (json['skip'] as int?) ?? 0,
      limit: (json['limit'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'products': products.map((product) => product.toJson()).toList(),
      'total': total,
      'skip': skip,
      'limit': limit,
    };
  }

  @override
  List<Object?> get props => [products, total, skip, limit];
}

double _numToDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }
  return 0;
}

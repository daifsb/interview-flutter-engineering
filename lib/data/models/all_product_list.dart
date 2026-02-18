import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'all_product_list.g.dart';

@JsonSerializable()
class AllProductList extends Equatable {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  const AllProductList({required this.products, required this.total, required this.skip, required this.limit});

  @override
  List<Object?> get props => [products, total, skip, limit];

  factory AllProductList.fromJson(Map<String, dynamic> json) => _$AllProductListFromJson(json);

  Map<String, dynamic> toJson() => _$AllProductListToJson(this);
}

@JsonSerializable()
class Product extends Equatable {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String? brand;
  final String sku;
  final int weight;
  final Dimensions dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<Review> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final Meta meta;
  final String thumbnail;
  final List<String> images;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.meta,
    required this.thumbnail,
    required this.images,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    category,
    price,
    discountPercentage,
    rating,
    stock,
    tags,
    brand,
    sku,
    weight,
    dimensions,
    warrantyInformation,
    shippingInformation,
    availabilityStatus,
    reviews,
    returnPolicy,
    minimumOrderQuantity,
    meta,
    thumbnail,
    images,
  ];

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable()
class Dimensions extends Equatable {
  final double width;
  final double height;
  final double depth;

  const Dimensions({required this.width, required this.height, required this.depth});

  @override
  List<Object?> get props => [width, height, depth];

  factory Dimensions.fromJson(Map<String, dynamic> json) => _$DimensionsFromJson(json);

  Map<String, dynamic> toJson() => _$DimensionsToJson(this);
}

@JsonSerializable()
class Review extends Equatable {
  final int rating;
  final String comment;
  final DateTime date;
  final String reviewerName;
  final String reviewerEmail;

  const Review({required this.rating, required this.comment, required this.date, required this.reviewerName, required this.reviewerEmail});

  @override
  List<Object?> get props => [rating, comment, date, reviewerName, reviewerEmail];

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}

@JsonSerializable()
class Meta extends Equatable {
  final DateTime createdAt;
  final DateTime updatedAt;
  final String barcode;
  final String qrCode;

  const Meta({required this.createdAt, required this.updatedAt, required this.barcode, required this.qrCode});

  @override
  List<Object?> get props => [createdAt, updatedAt, barcode, qrCode];

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_category.g.dart';

@JsonSerializable()
class ProductCategory extends Equatable {
  final String slug;
  final String name;
  final String url;

  const ProductCategory({
    required this.slug,
    required this.name,
    required this.url,
  });

  @override
  List<Object?> get props => [slug, name, url];

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ProductCategoryToJson(this);
}

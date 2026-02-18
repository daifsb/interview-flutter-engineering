import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  const CategoryModel({
    required this.slug,
    required this.name,
    required this.url,
  });

  final String slug;
  final String name;
  final String url;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      slug: (json['slug'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      url: (json['url'] as String?) ?? '',
    );
  }

  factory CategoryModel.fromValue(String value) {
    return CategoryModel(
      slug: value,
      name: value,
      url: '/products/category/$value',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'slug': slug,
      'name': name,
      'url': url,
    };
  }

  @override
  List<Object?> get props => [slug, name, url];
}

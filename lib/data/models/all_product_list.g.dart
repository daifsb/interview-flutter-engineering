// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_product_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllProductList _$AllProductListFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AllProductList', json, ($checkedConvert) {
      final val = AllProductList(
        products: $checkedConvert(
          'products',
          (v) => (v as List<dynamic>)
              .map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        total: $checkedConvert('total', (v) => (v as num).toInt()),
        skip: $checkedConvert('skip', (v) => (v as num).toInt()),
        limit: $checkedConvert('limit', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$AllProductListToJson(AllProductList instance) =>
    <String, dynamic>{
      'products': instance.products.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'skip': instance.skip,
      'limit': instance.limit,
    };

Product _$ProductFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Product', json, ($checkedConvert) {
      final val = Product(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        title: $checkedConvert('title', (v) => v as String),
        description: $checkedConvert('description', (v) => v as String),
        category: $checkedConvert('category', (v) => v as String),
        price: $checkedConvert('price', (v) => (v as num).toDouble()),
        discountPercentage: $checkedConvert(
          'discountPercentage',
          (v) => (v as num).toDouble(),
        ),
        rating: $checkedConvert('rating', (v) => (v as num).toDouble()),
        stock: $checkedConvert('stock', (v) => (v as num).toInt()),
        tags: $checkedConvert(
          'tags',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        brand: $checkedConvert('brand', (v) => v as String?),
        sku: $checkedConvert('sku', (v) => v as String),
        weight: $checkedConvert('weight', (v) => (v as num).toInt()),
        dimensions: $checkedConvert(
          'dimensions',
          (v) => Dimensions.fromJson(v as Map<String, dynamic>),
        ),
        warrantyInformation: $checkedConvert(
          'warrantyInformation',
          (v) => v as String,
        ),
        shippingInformation: $checkedConvert(
          'shippingInformation',
          (v) => v as String,
        ),
        availabilityStatus: $checkedConvert(
          'availabilityStatus',
          (v) => v as String,
        ),
        reviews: $checkedConvert(
          'reviews',
          (v) => (v as List<dynamic>)
              .map((e) => Review.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        returnPolicy: $checkedConvert('returnPolicy', (v) => v as String),
        minimumOrderQuantity: $checkedConvert(
          'minimumOrderQuantity',
          (v) => (v as num).toInt(),
        ),
        meta: $checkedConvert(
          'meta',
          (v) => Meta.fromJson(v as Map<String, dynamic>),
        ),
        thumbnail: $checkedConvert('thumbnail', (v) => v as String),
        images: $checkedConvert(
          'images',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'category': instance.category,
  'price': instance.price,
  'discountPercentage': instance.discountPercentage,
  'rating': instance.rating,
  'stock': instance.stock,
  'tags': instance.tags,
  'brand': ?instance.brand,
  'sku': instance.sku,
  'weight': instance.weight,
  'dimensions': instance.dimensions.toJson(),
  'warrantyInformation': instance.warrantyInformation,
  'shippingInformation': instance.shippingInformation,
  'availabilityStatus': instance.availabilityStatus,
  'reviews': instance.reviews.map((e) => e.toJson()).toList(),
  'returnPolicy': instance.returnPolicy,
  'minimumOrderQuantity': instance.minimumOrderQuantity,
  'meta': instance.meta.toJson(),
  'thumbnail': instance.thumbnail,
  'images': instance.images,
};

Dimensions _$DimensionsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Dimensions', json, ($checkedConvert) {
      final val = Dimensions(
        width: $checkedConvert('width', (v) => (v as num).toDouble()),
        height: $checkedConvert('height', (v) => (v as num).toDouble()),
        depth: $checkedConvert('depth', (v) => (v as num).toDouble()),
      );
      return val;
    });

Map<String, dynamic> _$DimensionsToJson(Dimensions instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'depth': instance.depth,
    };

Review _$ReviewFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Review', json, ($checkedConvert) {
      final val = Review(
        rating: $checkedConvert('rating', (v) => (v as num).toInt()),
        comment: $checkedConvert('comment', (v) => v as String),
        date: $checkedConvert('date', (v) => DateTime.parse(v as String)),
        reviewerName: $checkedConvert('reviewerName', (v) => v as String),
        reviewerEmail: $checkedConvert('reviewerEmail', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
  'rating': instance.rating,
  'comment': instance.comment,
  'date': instance.date.toIso8601String(),
  'reviewerName': instance.reviewerName,
  'reviewerEmail': instance.reviewerEmail,
};

Meta _$MetaFromJson(Map<String, dynamic> json) => $checkedCreate('Meta', json, (
  $checkedConvert,
) {
  final val = Meta(
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    barcode: $checkedConvert('barcode', (v) => v as String),
    qrCode: $checkedConvert('qrCode', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'barcode': instance.barcode,
  'qrCode': instance.qrCode,
};

import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';

abstract class ProductRepository {
  Future<ProductListResponse> getProducts({
    required int limit,
    required int skip,
  });

  Future<ProductListResponse> searchProducts(
    String query, {
    required int limit,
    required int skip,
  });

  Future<List<CategoryModel>> getCategories();

  Future<ProductListResponse> getProductsByCategory(
    String category, {
    required int limit,
    required int skip,
  });

  Future<ProductModel> getProductById(int id);
}

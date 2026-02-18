import 'package:interview_flutter/data/models/all_product_list.dart';

class AppSession {
  AppSession._();
  static final AppSession _instance = AppSession._();
  static AppSession get instance => _instance;

  final List<Product> selectedProduct = [];

  void addSelectedProduct(Product product) {
    selectedProduct.add(product);
  }

  void removeSelectedProduct(Product product) {
    selectedProduct.remove(product);
  }

  void clearSelectedProduct() {
    selectedProduct.clear();
  }
}

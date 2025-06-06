import 'package:get/get.dart';
import '../models/product_model.dart';
import 'api_service.dart';

class ProductService extends ApiService {
  Future<Response> getProducts({bool activeOnly = true}) async {
    return await get('/products?active=$activeOnly');
  }

  Future<Response> getProductBySKU(String sku) async {
    return await get('/products/sku?sku=$sku');
  }

  Future<Response> getProductsByCategory(String categoryId) async {
    return await get('/categories/$categoryId/products');
  }

  Future<Response> createProduct(ProductModel product) async {
    return await post('/products', product.toJson());
  }

  Future<Response> updateProduct(String id, ProductModel product) async {
    return await put('/products/$id', product.toJson());
  }

  Future<Response> deleteProduct(String id) async {
    return await delete('/products/$id');
  }
}

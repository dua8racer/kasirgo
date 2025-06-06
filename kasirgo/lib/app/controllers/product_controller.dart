import 'package:get/get.dart';
import '../data/models/product_model.dart';
import '../data/models/category_model.dart';
import '../data/services/product_service.dart';
import 'cart_controller.dart';

class ProductController extends GetxController {
  final ProductService _productService = Get.put(ProductService());

  final isLoading = false.obs;
  final products = <ProductModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final selectedCategory = Rx<CategoryModel?>(null);
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    loadCategories();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    try {
      final response = await _productService.getProducts();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.body;
        products.value = data.map((e) => ProductModel.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat produk: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCategories() async {
    // TODO: Implement category loading
    // For now, create dummy categories from products
    final categoryMap = <String, CategoryModel>{};
    for (var product in products) {
      if (product.category != null) {
        categoryMap[product.category!.id!] = product.category!;
      }
    }
    categories.value = categoryMap.values.toList();
  }

  Future<void> searchProductBySKU(String sku) async {
    if (sku.isEmpty) return;

    isLoading.value = true;
    try {
      final response = await _productService.getProductBySKU(sku);
      if (response.statusCode == 200) {
        final product = ProductModel.fromJson(response.body);
        // Add to cart or highlight product
        Get.find<CartController>().addToCart(product);
      } else {
        Get.snackbar('Produk Tidak Ditemukan', 'SKU tidak valid');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mencari produk: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<ProductModel> get filteredProducts {
    var filtered = products.toList();

    // Filter by category
    if (selectedCategory.value != null) {
      filtered = filtered
          .where((p) => p.categoryId == selectedCategory.value!.id)
          .toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.name!.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              (p.sku?.toLowerCase().contains(searchQuery.value.toLowerCase()) ??
                  false))
          .toList();
    }

    return filtered;
  }

  void selectCategory(CategoryModel? category) {
    selectedCategory.value = category;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
}

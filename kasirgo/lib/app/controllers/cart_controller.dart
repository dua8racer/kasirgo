import 'package:get/get.dart';
import '../data/models/product_model.dart';
import '../data/models/cart_item_model.dart';

class CartController extends GetxController {
  final cartItems = <CartItemModel>[].obs;
  final customerName = ''.obs;
  final notes = ''.obs;

  double get subtotal {
    return cartItems.fold(0, (sum, item) => sum + item.subtotal);
  }

  double get tax {
    return subtotal * 0; //* 0.11; // 11% PPN
  }

  double get total {
    return subtotal + tax;
  }

  int get totalItems {
    return cartItems.fold(0, (sum, item) => sum + (item.quantity ?? 0));
  }

  void addToCart(ProductModel product, {List<SelectedModifier>? modifiers}) {
    final existingIndex = cartItems.indexWhere((item) =>
        item.productId == product.id &&
        _modifiersEqual(item.modifiers, modifiers));

    if (existingIndex != -1) {
      cartItems[existingIndex].quantity =
          cartItems[existingIndex].quantity! + 1;
      cartItems.refresh();
    } else {
      cartItems.add(CartItemModel(
        productId: product.id,
        productName: product.name,
        price: product.price,
        quantity: 1,
        image: product.image,
        modifiers: modifiers,
      ));
    }
  }

  void removeFromCart(int index) {
    cartItems.removeAt(index);
  }

  void updateQuantity(int index, int quantity) {
    if (quantity <= 0) {
      removeFromCart(index);
    } else {
      cartItems[index].quantity = quantity;
      cartItems.refresh();
    }
  }

  void updateItemNote(int index, String note) {
    cartItems[index].notes = note;
    cartItems.refresh();
  }

  void clearCart() {
    cartItems.clear();
    customerName.value = '';
    notes.value = '';
  }

  bool _modifiersEqual(
      List<SelectedModifier>? mod1, List<SelectedModifier>? mod2) {
    if (mod1 == null && mod2 == null) return true;
    if (mod1 == null || mod2 == null) return false;
    if (mod1.length != mod2.length) return false;

    for (int i = 0; i < mod1.length; i++) {
      if (mod1[i].name != mod2[i].name || mod1[i].price != mod2[i].price) {
        return false;
      }
    }
    return true;
  }
}

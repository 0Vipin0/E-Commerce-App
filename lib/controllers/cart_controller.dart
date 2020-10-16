import 'package:get/get.dart';

import '../models/cart_item_model.dart';

class CartController extends GetxController {
  Map<String, CartItemModel> _items = <String, CartItemModel>{};

  Map<String, CartItemModel> get items => <String, CartItemModel>{..._items};

  double get totalAmount {
    double total = 0.0;
    _items.forEach((String key, CartItemModel cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    update();
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (CartItemModel existingCartItem) => CartItemModel(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItemModel(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    update();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    update();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (CartItemModel existingCartItem) => CartItemModel(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity - 1,
              ));
    } else {
      _items.remove(productId);
    }
    update();
  }

  void clear() {
    _items = <String, CartItemModel>{};
    update();
  }
}

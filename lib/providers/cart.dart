import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String seller;
  final String imageUrl;
  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.seller,
    @required this.imageUrl,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String productId,
    double price,
    String title,
    String seller,
    String imageUrl,
  ) {
    if (_items.containsKey(productId)) {
      // change quantity...
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
          seller: existingCartItem.seller,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
          seller: seller,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void increase(
    String productId,
    double price,
    String title,
    String seller,
    String imageUrl,
  ) {
    if (_items.containsKey(productId)) {
      // change quantity...
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
          seller: existingCartItem.seller,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } 
    notifyListeners();
  }
void decrease(
    String productId,
    double price,
    String title,
    String seller,
    String imageUrl,
  ) {
    if (_items.containsKey(productId)) {
      // change quantity...
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
          seller: existingCartItem.seller,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } 
    notifyListeners();

  }  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId){
    if (!_items.containsKey(productId)){
      return ;
    }
    if (_items[productId].quantity > 1 ){
      _items.update(productId, (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
          seller: existingCartItem.seller,
          imageUrl: existingCartItem.imageUrl,
        ) );
    } else{
      removeItem(productId);
      notifyListeners();
    }
    
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}

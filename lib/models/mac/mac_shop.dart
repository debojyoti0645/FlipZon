import 'package:flutter/material.dart';

class MacBookShop extends ChangeNotifier {
  // List to store wishlist items
  final List<Map<String, dynamic>> _wishlist = [];

  // Getter for wishlist
  List<Map<String, dynamic>> get wishlist => _wishlist;

  // Add to wishlist
  void addToWishlist(Map<String, dynamic> macbook, Map<String, dynamic> variant, String model) {
    final productKey = '${model}_${variant['size']}';
    if (!isInWishlist(productKey)) {  // Check if not already in wishlist
      _wishlist.add({
        'productKey': productKey,
        'macbook': macbook,
        'variant': variant,
        'model': model,
      });
      notifyListeners();  // Notify listeners of the change
    }
  }

  // Remove from wishlist
  void removeFromWishlist(String productKey) {
    _wishlist.removeWhere((item) => item['productKey'] == productKey);
    notifyListeners();  // Notify listeners of the change
  }

  // Check if item is in wishlist
  bool isInWishlist(String productKey) {
    return _wishlist.any((item) => item['productKey'] == productKey);
  }
}
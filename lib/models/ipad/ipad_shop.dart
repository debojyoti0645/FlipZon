import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ipad_product.dart';

class IpadShop extends ChangeNotifier {
  List<IpadProduct> _ipads = [];
  List<String> _wishlist = [];

  List<IpadProduct> get ipads => _ipads;
  List<String> get wishlist => _wishlist;

  Future<void> loadProductsFromJson() async {
    final String response = await rootBundle.loadString('lib/device_data/ipadSeries.json');
    final List<dynamic> data = json.decode(response);
    _ipads = data.map((json) => IpadProduct.fromJson(json)).toList();
    notifyListeners();
  }

  void addToWishlist(String productModel) {
    _wishlist.add(productModel);
    notifyListeners();
  }

  void removeFromWishlist(String productModel) {
    _wishlist.remove(productModel);
    notifyListeners();
  }

  bool isInWishlist(String productModel) {
    return _wishlist.contains(productModel);
  }

  List<IpadProduct> getIpadsByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'ipad':
        return _ipads.where((ipad) => ipad.model.toLowerCase().startsWith('ipad ')).toList();
      case 'ipad air':
        return _ipads.where((ipad) => ipad.model.toLowerCase().startsWith('ipad air')).toList();
      case 'ipad mini':
        return _ipads.where((ipad) => ipad.model.toLowerCase().startsWith('ipad mini')).toList();
      case 'ipad pro':
        return _ipads.where((ipad) => ipad.model.toLowerCase().startsWith('ipad pro')).toList();
      default:
        return [];
    }
  }
}
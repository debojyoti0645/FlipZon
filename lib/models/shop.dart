import 'dart:convert';

import 'package:flipzon/models/product.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class Shop extends ChangeNotifier {
  final List<Product> _shop = [];
  List<Product> _cart = [];
  List<Product> _wishlist = [];

  List<Product> get shop => _shop;
  List<Product> get cart => _cart;
  List<Product> get wishlist => _wishlist;

  Future<void> loadProductsFromJson() async {
    try {
      // Load all iPhone series data
      final String iphone14Data = await rootBundle.loadString('lib/device_data/iphone14Series.json');
      final String iphone15Data = await rootBundle.loadString('lib/device_data/iphone15Series.json');
      final String iphone16Data = await rootBundle.loadString('lib/device_data/iphone16Series.json');
      
      final List<dynamic> allData = [
        ...json.decode(iphone14Data),
        ...json.decode(iphone15Data),
        ...json.decode(iphone16Data),
      ];
      
      _shop.clear();
      
      for (var phoneData in allData) {
        for (var color in phoneData['colors']) {
          final String baseImagePath = 'assets/${phoneData['model'].toLowerCase().replaceAll(' ', '-')}';
          
          // Create specifications object
          final specs = Specifications(
            display: Display(
              size: phoneData['specifications']['display']['size'],
              type: phoneData['specifications']['display']['type'],
              resolution: phoneData['specifications']['display']['resolution'],
              refreshRate: phoneData['specifications']['display']['refresh_rate'],
              brightness: Brightness(
                typical: phoneData['specifications']['display']['brightness']['typical'] ?? '',
                peak: phoneData['specifications']['display']['brightness']['peak'] ?? '',
              ),
            ),
            processor: phoneData['specifications']['processor'],
            memory: phoneData['specifications']['memory'],
            battery: Battery(
              type: phoneData['specifications']['battery']['type'],
              charging: Charging(
                wired: phoneData['specifications']['battery']['charging']['wired'],
                wireless: List<String>.from(phoneData['specifications']['battery']['charging']['wireless'] ?? []),
              ),
            ),
            camera: Camera(
              rear: (phoneData['specifications']['camera']['rear'] as List)
                  .map((lens) => CameraLens(
                        megapixels: lens['megapixels'],
                        aperture: lens['aperture'],
                        lens: lens['lens'],
                      ))
                  .toList(),
              front: CameraLens(
                megapixels: phoneData['specifications']['camera']['front']['megapixels'],
                aperture: phoneData['specifications']['camera']['front']['aperture'],
                lens: phoneData['specifications']['camera']['front']['lens'],
              ),
            ),
            dimensions: Dimensions(
              height: phoneData['specifications']['dimensions']['height'],
              width: phoneData['specifications']['dimensions']['width'],
              depth: phoneData['specifications']['dimensions']['depth'],
            ),
            weight: phoneData['specifications']['weight'],
          );

          // Create map of storage options to prices
          Map<String, String> prices = {};
          for (var storage in phoneData['storage_options']) {
            prices[storage] = phoneData['storage_prices'][storage];
          }
          
          _shop.add(
            Product(
              id: '${phoneData['model']}_${color}'.replaceAll(' ', ''),
              name: phoneData['model'],
              releaseDate: phoneData['release_date'],
              colors: List<String>.from(phoneData['colors']),
              storageOptions: List<String>.from(phoneData['storage_options']),
              prices: prices,
              description: color,
              image: '$baseImagePath-${color.toLowerCase()}.png',
              type: phoneData['model'],
              specifications: specs,
            ),
          );
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  void addToCart(Product item) {
    _cart.add(item);
    notifyListeners();
  }

  void removeItemFromCart(Product item) {
    _cart.remove(item);
    notifyListeners();
  }

  // Save wishlist to SharedPreferences
  Future<void> saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistData = _wishlist.map((product) => product.id).toList();
    await prefs.setStringList('wishlist', wishlistData);
  }

  // Load wishlist from SharedPreferences
  Future<void> loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistData = prefs.getStringList('wishlist') ?? [];
    
    _wishlist = _shop
        .where((product) => wishlistData.contains(product.id))
        .toList();
    notifyListeners();
  }

  // Modify existing wishlist methods to save changes
  void addToWishlist(Product item) {
    _wishlist.add(item);
    saveWishlist(); // Save after adding
    notifyListeners();
  }

  void removeItemFromWishlist(Product item) {
    _wishlist.remove(item);
    saveWishlist(); // Save after removing
    notifyListeners();
  }

  bool isInWishlist(Product product) {
    return _wishlist.any((item) => item.id == product.id);
  }
}
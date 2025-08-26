import 'dart:async';

import 'package:flipzon/components/my_product_tile.dart';
import 'package:flipzon/components/wishlist_icon.dart';
import 'package:flipzon/models/ad_helper.dart';
import 'package:flipzon/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class ShopPageIphone16Series extends StatefulWidget {
  const ShopPageIphone16Series({super.key});

  @override
  State<ShopPageIphone16Series> createState() => _ShopPageIphone16SeriesState();
}

class _ShopPageIphone16SeriesState extends State<ShopPageIphone16Series> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  Timer? _adRefreshTimer;
  // Add search controller
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    // Set up timer for ad refresh
    _adRefreshTimer = Timer.periodic(const Duration(seconds: 42), (timer) {
      _bannerAd?.dispose();
      _loadBannerAd();
    });
  }

  void _loadBannerAd() {
    setState(() {
      _isAdLoaded = false;
    });

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Banner Ad failed to load: $error');
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _adRefreshTimer?.cancel(); // Cancel the timer
    _searchController.dispose(); // Dispose search controller
    super.dispose();
  }

  // Add search filter method
  List<dynamic> _filterProducts(List<dynamic> products) {
    if (_searchQuery.isEmpty) {
      return products;
    }
    return products
        .where((product) =>
            product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<Shop>().shop;

    // Filter products by model and search query
    final iphone16Products = _filterProducts(
        products.where((product) => product.name == 'iPhone 16').toList());
    final iphone16PlusProducts = _filterProducts(
        products.where((product) => product.name == 'iPhone 16 Plus').toList());
    final iphone16ProProducts = _filterProducts(
        products.where((product) => product.name == 'iPhone 16 Pro').toList());
    final iphone16ProMaxProducts = _filterProducts(products
        .where((product) => product.name == 'iPhone 16 Pro Max')
        .toList());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('IPhone 16 Series',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: WishlistIcon(
              iconColor: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Add search bar before the banner ad
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search iPhone models...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),

              // Banner Ad (adjust top padding)
              if (_bannerAd != null && _isAdLoaded)
                Positioned(
                  top: 60, // Adjust this value to position below search bar
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.topCenter,
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),

              // Adjust the padding for the main content
              Padding(
                padding: const EdgeInsets.only(
                    top:
                        120.0), // Increased padding to accommodate search bar and ad
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // iPhone 16 Section
                    if (iphone16Products.isNotEmpty)
                      SizedBox(
                        height: 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "iPhone 16",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.all(7),
                                scrollDirection: Axis.horizontal,
                                itemCount: iphone16Products.length,
                                itemBuilder: (context, index) {
                                  return MyProductTile(
                                      product: iphone16Products[index]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                    // iPhone 16 Plus Section
                    if (iphone16PlusProducts.isNotEmpty)
                      SizedBox(
                        height: 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "iPhone 16 Plus",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.all(7),
                                scrollDirection: Axis.horizontal,
                                itemCount: iphone16PlusProducts.length,
                                itemBuilder: (context, index) {
                                  return MyProductTile(
                                      product: iphone16PlusProducts[index]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                    // iPhone 16 Pro Section
                    if (iphone16ProProducts.isNotEmpty)
                      SizedBox(
                        height: 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "iPhone 16 Pro",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.all(7),
                                scrollDirection: Axis.horizontal,
                                itemCount: iphone16ProProducts.length,
                                itemBuilder: (context, index) {
                                  return MyProductTile(
                                      product: iphone16ProProducts[index]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                    // iPhone 15 Pro Max Section
                    if (iphone16ProMaxProducts.isNotEmpty)
                      SizedBox(
                        height: 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "iPhone 16 Pro Max",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.all(7),
                                scrollDirection: Axis.horizontal,
                                itemCount: iphone16ProMaxProducts.length,
                                itemBuilder: (context, index) {
                                  return MyProductTile(
                                      product: iphone16ProMaxProducts[index]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flipzon/components/my_product_tile.dart';
import 'package:flipzon/components/wishlist_icon.dart';
import 'package:flipzon/models/ad_helper.dart';
import 'package:flipzon/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class ShopPageIphone15Series extends StatefulWidget {
  const ShopPageIphone15Series({super.key});

  @override
  State<ShopPageIphone15Series> createState() => _ShopPageIphone15SeriesState();
}

class _ShopPageIphone15SeriesState extends State<ShopPageIphone15Series> {
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
    final iphone15Products = _filterProducts(
        products.where((product) => product.type == 'iPhone 15').toList());
    final iphone15PlusProducts = _filterProducts(
        products.where((product) => product.type == 'iPhone 15 Plus').toList());
    final iphone15Proroducts = _filterProducts(
        products.where((product) => product.type == 'iPhone 15 Pro').toList());
    final iphone15ProMaxProducts = _filterProducts(products
        .where((product) => product.type == 'iPhone 15 Pro Max')
        .toList());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('iPhone 15 Series',
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
                    // iPhone 15 Section
                    if (iphone15Products.isNotEmpty)
                      SizedBox(
                        height: 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "iPhone 15",
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
                                itemCount: iphone15Products.length,
                                itemBuilder: (context, index) {
                                  return MyProductTile(
                                      product: iphone15Products[index]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                    // iPhone 15 Plus Section
                    if (iphone15PlusProducts.isNotEmpty)
                      SizedBox(
                        height: 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "iPhone 15 Plus",
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
                                itemCount: iphone15PlusProducts.length,
                                itemBuilder: (context, index) {
                                  return MyProductTile(
                                      product: iphone15PlusProducts[index]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                    // iPhone 15 Pro Section
                    if (iphone15Proroducts.isNotEmpty)
                      SizedBox(
                        height: 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "iPhone 15 Pro",
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
                                itemCount: iphone15Proroducts.length,
                                itemBuilder: (context, index) {
                                  return MyProductTile(
                                      product: iphone15Proroducts[index]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                    // iPhone 15 Pro Max Section
                    if (iphone15ProMaxProducts.isNotEmpty)
                      SizedBox(
                        height: 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "iPhone 15 Pro Max",
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
                                itemCount: iphone15ProMaxProducts.length,
                                itemBuilder: (context, index) {
                                  return MyProductTile(
                                      product: iphone15ProMaxProducts[index]);
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

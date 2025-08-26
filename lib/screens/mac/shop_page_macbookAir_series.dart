import 'dart:async';
import 'dart:convert';

import 'package:flipzon/components/mac/mac_details_page.dart';
import 'package:flipzon/components/wishlist_icon.dart';
import 'package:flipzon/models/ad_helper.dart';
import 'package:flipzon/models/mac/mac_shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class ShopPageMacBookAirSeries extends StatefulWidget {
  const ShopPageMacBookAirSeries({Key? key}) : super(key: key);

  @override
  State<ShopPageMacBookAirSeries> createState() =>
      _ShopPageMacBookAirSeriesState();
}

class _ShopPageMacBookAirSeriesState extends State<ShopPageMacBookAirSeries> {
  List<dynamic> macbooks = [];
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  Timer? _adRefreshTimer;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Map<String, bool> _likedProducts = {};

  @override
  void initState() {
    super.initState();
    loadMacBookData();
    _loadBannerAd();
    _adRefreshTimer = Timer.periodic(const Duration(seconds: 42), (timer) {
      _bannerAd?.dispose();
      _loadBannerAd();
    });
  }

  Future<void> loadMacBookData() async {
    final String response = await rootBundle
        .loadString('lib/device_data/mac/mabbookairSeries.json');
    setState(() {
      macbooks = json.decode(response);
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
    _adRefreshTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> _filterMacBooks(List<dynamic> macbooks) {
    if (_searchQuery.isEmpty) return macbooks;
    return macbooks
        .where((macbook) =>
            macbook['model'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Widget _buildMacBookSection(String model, List<dynamic> variants) {
    // First, find the macbook data from the macbooks list
    final macbook = macbooks.firstWhere((m) => m['model'] == model);

    return SizedBox(
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(7),
              scrollDirection: Axis.horizontal,
              itemCount: variants.length,
              itemBuilder: (context, index) {
                final variant = variants[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MacDetailsPage(
                          macbook: macbook, // Now macbook is properly defined
                          variant: variant,
                          model: model,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 300,
                    margin: const EdgeInsets.all(8),
                    child: Card(
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.asset(
                              'assets/macbook/${model.toLowerCase().replaceAll(' ', '-')}.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${variant['size']} MacBook Air',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        context.watch<MacBookShop>().isInWishlist(
                                                '${model}_${variant['size']}')
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: context
                                                .watch<MacBookShop>()
                                                .isInWishlist(
                                                    '${model}_${variant['size']}')
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        final macbookShop =
                                            context.read<MacBookShop>();
                                        final productKey =
                                            '${model}_${variant['size']}';

                                        if (macbookShop
                                            .isInWishlist(productKey)) {
                                          macbookShop
                                              .removeFromWishlist(productKey);
                                        } else {
                                          macbookShop.addToWishlist(
                                              macbook, variant, model);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Storage: ${variant['storage']} • Memory: ${variant['memory']}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '₹${variant['base_price_inr'].toString()}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
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
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredMacbooks = _filterMacBooks(macbooks);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'MacBook Air',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search MacBook models...',
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
              if (_bannerAd != null && _isAdLoaded)
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.topCenter,
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 120.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: filteredMacbooks.map((macbook) {
                    return _buildMacBookSection(
                      macbook['model'],
                      macbook['variants'],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

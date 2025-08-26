import 'package:flipzon/components/ipad_details_page.dart';
import 'package:flipzon/models/ipad/ipad_product.dart';
import 'package:flipzon/models/ipad/ipad_shop.dart';
import 'package:flipzon/models/mac/mac_shop.dart';
import 'package:flipzon/models/shop.dart';
import 'package:flipzon/screens/compare_page.dart';
import 'package:flipzon/screens/ipad/ipad_shop_list.dart';
import 'package:flipzon/screens/ipad/shop_page_ipad.dart';
import 'package:flipzon/screens/ipad/shop_page_ipad_air.dart';
import 'package:flipzon/screens/ipad/shop_page_ipad_mini.dart';
import 'package:flipzon/screens/ipad/shop_page_ipad_pro.dart';
import 'package:flipzon/screens/iphone/iphone_shop_list.dart';
import 'package:flipzon/screens/iphone/shop_page_iphone14_series.dart';
import 'package:flipzon/screens/iphone/shop_page_iphone15_series.dart';
import 'package:flipzon/screens/iphone/shop_page_iphone16_series.dart';
import 'package:flipzon/screens/mac/mac_shop_list.dart';
import 'package:flipzon/screens/mac/shop_page_macbookAir_series.dart';
import 'package:flipzon/screens/main_shop_home_page.dart';
import 'package:flipzon/screens/wishlist_page.dart';
import 'package:flipzon/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'screens/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  final shop = Shop();
  final ipadShop = IpadShop();

  try {
    await Future.wait([
      shop.loadProductsFromJson(),
      ipadShop.loadProductsFromJson(),
    ]);

    await Future.wait([
      shop.loadWishlist(),
    ]);
  } catch (e) {
    debugPrint('Error loading data: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => shop),
        ChangeNotifierProvider(create: (context) => ipadShop),
        ChangeNotifierProvider(create: (_) => MacBookShop()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlipZon',
      theme: lightMode,
      home: HomePage(),
      routes: {
        '/home_page': (context) => HomePage(),
        '/shop_page': (context) => MainShopHomePage(),
        '/iphone_list_page': (context) => IphoneShopList(),
        '/shop_page_iphone_15_series': (context) => ShopPageIphone15Series(),
        '/shop_page_iphone_16_series': (context) => ShopPageIphone16Series(),
        '/shop_page_iphone_14_series': (context) => ShopPageIphone14Series(),
        '/wishlist_page': (context) => WishlistPage(),
        '/compare_page': (context) => ComparePage(),
        '/ipad_shop_list': (context) => const IpadShopList(),
        '/ipad_pro_page': (context) => const ShopPageIpadPro(),
        '/ipad_air_page': (context) => const ShopPageIpadAir(),
        '/ipad_mini_page': (context) => const ShopPageIpadMini(),
        '/ipad_page': (context) => const ShopPageIpad(),
        '/ipad_details': (context) => IpadDetailsPage(
              ipad: ModalRoute.of(context)!.settings.arguments as IpadProduct,
            ),
        // MacBook section - simplified to single route
        '/mac_list_page': (context) => MacShopList(),
        '/shop_page_macbook_air': (context) => const ShopPageMacBookAirSeries(),
      },
    );
  }
}

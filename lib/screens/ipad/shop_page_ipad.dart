import 'package:flipzon/components/ipad_product_tile.dart';
import 'package:flipzon/components/wishlist_icon.dart';
import 'package:flipzon/models/ipad/ipad_shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopPageIpad extends StatelessWidget {
  const ShopPageIpad({super.key});

  @override
  Widget build(BuildContext context) {
    final ipadShop = Provider.of<IpadShop>(context);
    // Get only the first 3 iPads from the list
    final standardIpads = ipadShop.getIpadsByCategory('ipad').take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('iPad'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: standardIpads.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: IpadProductTile(ipad: standardIpads[index]),
            );
          },
        ),
      ),
    );
  }
}
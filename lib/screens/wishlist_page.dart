import 'package:flipzon/models/ipad/ipad_shop.dart';
import 'package:flipzon/models/mac/mac_shop.dart';
import 'package:flipzon/models/product.dart';
import 'package:flipzon/models/shop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // GET ACCESS TO THE CART
    final cart = context.watch<Shop>().cart;

    // Calculate total price
    double totalPrice = 0;
    for (var product in cart) {
      String priceString =
          product.prices[product.description.split(',')[0].trim()] ?? '0';
      totalPrice += double.tryParse(priceString.replaceAll(',', '')) ?? 0;
    }

    // Format total price using NumberFormat for Indian currency
    final indianCurrencyFormat =
        NumberFormat.currency(locale: "en_IN", symbol: "₹");

    // Number of items in the cart
    int itemCount = cart.length;

    // REMOVE ITEM FROM CART METHOD
    void removeItemFromCart(BuildContext context, Product product) {
      // Show a dialog box to confirm removing the item
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Remove from Cart'),
          content: const Text(
              'Are you sure you want to remove this from your cart?'),
          actions: [
            // CANCEL BUTTON
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),

            // ACCEPT BUTTON
            MaterialButton(
              onPressed: () {
                // POP THE DIALOG
                Navigator.pop(context);

                // REMOVE THE PRODUCT FROM THE CART
                context.read<Shop>().removeItemFromCart(product);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("CART PAGE"),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          // CART LIST
          Expanded(
            child: cart.isEmpty
                ? Center(
                    child: Text(
                      "Your cart is empty!",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      // GET INDIVIDUAL ITEM IN THE CART
                      final item = cart[index];

                      // RETURN AS A CART TILE UI
                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Image.asset(item.image),
                          title: Text(
                            '${item.name}\n${item.description}',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              "₹${item.prices[item.description.split(',')[0].trim()]}"),
                          trailing: IconButton(
                              onPressed: () =>
                                  removeItemFromCart(context, item),
                              icon: Icon(CupertinoIcons.trash)),
                        ),
                      );
                    },
                  ),
          ),

          // CART TOTAL
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (cart.isNotEmpty)
                  Text(
                    "$itemCount items in your cart",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                if (cart.isNotEmpty)
                  Text(
                    "Total Price: ${indianCurrencyFormat.format(totalPrice)}",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wishlist'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Combined Wishlist
          Expanded(
            child: Consumer3<Shop, IpadShop, MacBookShop>(
              builder: (context, shop, ipadShop, macBookShop, child) {
                // Calculate total price for both regular products and iPads
                double totalPrice = 0;

                // Regular products price
                for (final item in shop.wishlist) {
                  final cleanPrice = cleanPriceString(
                      item.prices[item.storageOptions[0]] ?? '0');
                  totalPrice += double.tryParse(cleanPrice) ?? 0;
                }

                // iPads price
                for (final ipadModel in ipadShop.wishlist) {
                  final ipad = ipadShop.ipads.firstWhere(
                    (ipad) => ipad.model == ipadModel,
                  );
                  final cleanPrice = cleanPriceString(
                      ipad.storagePrices[ipad.storageOptions[0]] ?? '0');
                  totalPrice += double.tryParse(cleanPrice) ?? 0;
                }

                // MacBooks price
                for (final macItem in macBookShop.wishlist) {
                  final cleanPrice = cleanPriceString(
                      macItem['variant']['base_price_inr'].toString());
                  totalPrice += double.tryParse(cleanPrice) ?? 0;
                }

                final totalItems =
                    shop.wishlist.length + ipadShop.wishlist.length + macBookShop.wishlist.length;

                if (totalItems == 0) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 100,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Your wishlist is empty!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.all(16),
                        children: [
                          // Regular Products
                          ...shop.wishlist.map((item) => _buildWishlistItem(
                                context,
                                title: '${item.name} - ${item.description}',
                                subtitle: '${item.storageOptions[0]}',
                                price:
                                    '₹${item.prices[item.storageOptions[0]]}',
                                image: item.image,
                                onRemove: () {
                                  context
                                      .read<Shop>()
                                      .removeItemFromWishlist(item);
                                },
                              )),

                          // iPads
                          ...ipadShop.wishlist.map((ipadModel) {
                            final ipad = ipadShop.ipads.firstWhere(
                              (ipad) => ipad.model == ipadModel,
                            );
                            return _buildWishlistItem(
                              context,
                              title: ipad.model,
                              subtitle: ipad.storageOptions[0],
                              price:
                                  '₹${ipad.storagePrices[ipad.storageOptions[0]]}',
                              image:
                                  'assets/${ipad.model.toLowerCase().replaceAll(' ', '-')}.png',
                              onRemove: () {
                                ipadShop.removeFromWishlist(ipad.model);
                              },
                            );
                          }),

                          // MacBooks
                          ...macBookShop.wishlist.map((macItem) => _buildWishlistItem(
                            context,
                            title: '${macItem['variant']['size']} MacBook Air',
                            subtitle: 'Storage: ${macItem['variant']['storage']} • Memory: ${macItem['variant']['memory']}',
                            price: '₹${macItem['variant']['base_price_inr']}',
                            image: 'assets/macbook/${macItem['model'].toLowerCase().replaceAll(' ', '-')}.png',
                            onRemove: () {
                              macBookShop.removeFromWishlist(macItem['productKey']);
                            },
                          )),
                        ],
                      ),
                    ),
                    // Wishlist Summary
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$totalItems items in wishlist',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Total: ₹${totalPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline,
                                  size: 14,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary),
                              SizedBox(width: 2),
                              Text("These prices may vary based on the seller",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String price,
    required String image,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        leading: Container(
          width: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(8),
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              price,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: Colors.red,
          ),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Remove from Wishlist'),
              content: Text(
                  'Are you sure you want to remove this item from your wishlist?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onRemove();
                  },
                  child: Text('Remove', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Add this helper function to clean price strings
String cleanPriceString(String price) {
  // Remove currency symbol, commas and any whitespace
  return price
      .replaceAll('₹', '')
      .replaceAll(',', '')
      .replaceAll(' ', '')
      .trim();
}

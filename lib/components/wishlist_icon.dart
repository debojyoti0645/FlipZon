import 'package:flipzon/models/ipad/ipad_shop.dart';
import 'package:flipzon/models/mac/mac_shop.dart';
import 'package:flipzon/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistIcon extends StatelessWidget {
  final Color? iconColor;
  final VoidCallback? onPressed;

  const WishlistIcon({
    Key? key,
    this.iconColor,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.favorite_outline,
            color: iconColor,
          ),
          onPressed: onPressed ?? () {
            Navigator.pushNamed(context, '/wishlist_page');
          },
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Consumer3<Shop, IpadShop, MacBookShop>(
            builder: (context, shop, ipadShop, macBookShop, child) {
              final totalItems = shop.wishlist.length + 
                               ipadShop.wishlist.length + 
                               macBookShop.wishlist.length;
              
              if (totalItems == 0) {
                return const SizedBox.shrink();
              }
              
              return Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Center(
                  child: Text(
                    '$totalItems',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
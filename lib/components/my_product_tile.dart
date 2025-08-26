import 'package:flipzon/models/product.dart';
import 'package:flipzon/models/shop.dart';
import 'package:flipzon/screens/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProductTile extends StatefulWidget {
  final Product product;
  const MyProductTile({super.key, required this.product});

  @override
  State<MyProductTile> createState() => _MyProductTileState();
}

class _MyProductTileState extends State<MyProductTile> {
  late String selectedStorage;

  @override
  void initState() {
    super.initState();
    selectedStorage = widget.product.storageOptions[0];
  }

  void addToWishlist(BuildContext context) {
    final shop = context.read<Shop>();
    if (shop.isInWishlist(widget.product)) {
      // If already in wishlist, remove it
      shop.removeItemFromWishlist(widget.product);
    } else {
      // If not in wishlist, show dialog to add it
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("Add ${widget.product.name} to your wishlist?"),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                shop.addToWishlist(widget.product);
              },
              child: Text("Yes"),
            ),
          ],
        ),
      );
    }
  }

  void showDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: widget.product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isInWishlist = context.watch<Shop>().isInWishlist(widget.product);

    return GestureDetector(
      onTap: () => showDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.only(right: 5),
        padding: const EdgeInsets.all(10),
        width: 200,
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Image.asset(widget.product.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            
            // Basic Info
            Text(
              "${widget.product.name} - ${widget.product.description}",  // description contains the color
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            
            // Storage Dropdown
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: selectedStorage,
                isExpanded: true,
                underline: SizedBox(),
                items: widget.product.storageOptions.map((String storage) {
                  return DropdownMenuItem<String>(
                    value: storage,
                    child: Text(storage),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedStorage = newValue;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 5),
            
            // Price and Add to Cart
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${widget.product.prices[selectedStorage]}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => addToWishlist(context),
                  icon: Icon(
                    isInWishlist ? Icons.favorite : Icons.favorite_outline,
                    color: isInWishlist ? Colors.red : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

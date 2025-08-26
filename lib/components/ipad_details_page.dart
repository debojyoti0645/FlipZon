import 'package:flipzon/models/ipad/ipad_product.dart';
import 'package:flipzon/models/ipad/ipad_shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IpadDetailsPage extends StatefulWidget {
  final IpadProduct ipad;

  const IpadDetailsPage({
    super.key,
    required this.ipad,
  });

  @override
  State<IpadDetailsPage> createState() => _IpadDetailsPageState();
}

class _IpadDetailsPageState extends State<IpadDetailsPage> {
  late String selectedStorage;
  late String selectedColor;

  bool get isInWishlist {
    final shop = context.read<IpadShop>();
    return shop.isInWishlist(widget.ipad.model);
  }

  @override
  void initState() {
    super.initState();
    selectedStorage = widget.ipad.storageOptions[0];
    selectedColor = widget.ipad.colors[0];
  }

  void addToWishlist(BuildContext context) {
    final shop = context.read<IpadShop>();
    if (shop.isInWishlist(widget.ipad.model)) {
      // If already in wishlist, remove it
      shop.removeFromWishlist(widget.ipad.model);
    } else {
      // If not in wishlist, show dialog to add it
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("Add ${widget.ipad.model} to your wishlist?"),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                shop.addToWishlist(widget.ipad.model);
              },
              child: const Text("Yes"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.ipad.model,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              background: Hero(
                tag: 'ipad-${widget.ipad.model}',
                child: Image.asset(
                  'assets/${widget.ipad.model.toLowerCase().replaceAll(' ', '-')}.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.ipad.storagePrices[selectedStorage]}',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Wishlist Button
                            IconButton(
                              onPressed: () => addToWishlist(context),
                              icon: Consumer<IpadShop>(
                                builder: (context, shop, child) => Icon(
                                  shop.isInWishlist(widget.ipad.model)
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  color: shop.isInWishlist(widget.ipad.model)
                                      ? Colors.red
                                      : Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Release Date
                  _buildInfoSection(
                    'Release Date',
                    widget.ipad.releaseDate,
                    Icons.calendar_today,
                  ),

                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'About This iPad',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.ipad.description,
                    style: TextStyle(
                      height: 1.5,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Storage Options
                  Text(
                    'Storage',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.ipad.storageOptions.map((storage) {
                      return ChoiceChip(
                        label: Text(storage),
                        selected: selectedStorage == storage,
                        onSelected: (selected) {
                          setState(() {
                            selectedStorage = storage;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Color Options
                  Text(
                    'Color',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: widget.ipad.colors.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: _getColorFromName(color),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selectedColor == color
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              color,
                              style: TextStyle(
                                fontSize: 12,
                                color: selectedColor == color
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Technical Specifications
                  Text(
                    'Technical Specifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Display
                  _buildSpecGroup('Display', [
                    'Size: ${widget.ipad.specifications.display.size}',
                    'Type: ${widget.ipad.specifications.display.type}',
                    'Resolution: ${widget.ipad.specifications.display.resolution}',
                    if (widget.ipad.specifications.display.refreshRate != null)
                      'Refresh Rate: ${widget.ipad.specifications.display.refreshRate}',
                    'Brightness: ${widget.ipad.specifications.display.brightness["typical"]}',
                  ]),

                  // Performance
                  _buildSpecGroup('Performance', [
                    'Processor: ${widget.ipad.specifications.processor}',
                    'Memory: ${widget.ipad.specifications.memory}',
                  ]),

                  // Camera
                  _buildSpecGroup('Camera', [
                    if (widget.ipad.specifications.camera.rear is Map)
                      'Rear: ${widget.ipad.specifications.camera.rear["megapixels"]} (${widget.ipad.specifications.camera.rear["aperture"]})',
                    'Front: ${widget.ipad.specifications.camera.front["megapixels"]} (${widget.ipad.specifications.camera.front["aperture"]})',
                  ]),

                  // Battery
                  _buildSpecGroup('Battery & Charging', [
                    'Type: ${widget.ipad.specifications.battery.type}',
                    'Charging: ${widget.ipad.specifications.battery.charging["wired"]}',
                  ]),

                  // Connectivity
                  _buildSpecGroup(
                    'Connectivity',
                    widget.ipad.specifications.connectivity
                        .map((e) => '• $e')
                        .toList(),
                  ),

                  // Dimensions
                  if (widget.ipad.specifications.dimensions != null)
                    _buildSpecGroup('Physical Specifications', [
                      if (widget.ipad.specifications.dimensions?.height != null)
                        'Height: ${widget.ipad.specifications.dimensions?.height}',
                      if (widget.ipad.specifications.dimensions?.width != null)
                        'Width: ${widget.ipad.specifications.dimensions?.width}',
                      if (widget.ipad.specifications.dimensions?.depth != null)
                        'Depth: ${widget.ipad.specifications.dimensions?.depth}',
                    ]),

                  // Operating System
                  _buildSpecGroup('Software', [
                    'Operating System: ${widget.ipad.specifications.operatingSystem}',
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecGroup(String title, List<String> specs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...specs.map((spec) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                spec,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  height: 1.5,
                ),
              ),
            )),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInfoSection(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                content,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'space gray':
        return Colors.grey.shade800;
      case 'silver':
        return Colors.grey.shade300;
      case 'gold':
        return const Color(0xFFE7BD74);
      case 'rose gold':
        return const Color(0xFFB76E79);
      case 'blue':
        return Colors.blue;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'starlight':
        return const Color(0xFFF9F6EF);
      case 'yellow':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}

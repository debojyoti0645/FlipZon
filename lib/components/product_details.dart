import 'package:flipzon/models/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductDetails extends StatelessWidget {
  final Product product;

  const ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Release Date: ${DateFormat('MMMM d, y').format(DateTime.parse(product.releaseDate))}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          const SizedBox(height: 16),
          
          // Display Section
          _buildDisplaySection(),
          
          // Camera Section
          _buildCameraSection(),
          
          // Battery Section
          _buildBatterySection(),
          
          // Performance Section
          _buildPerformanceSection(),
        ],
      ),
    );
  }

  Widget _buildDisplaySection() {
    return _buildSpecificationSection(
      'Display',
      [
        'Size: ${product.specifications.display.size}',
        'Type: ${product.specifications.display.type}',
        'Resolution: ${product.specifications.display.resolution}',
        'Refresh Rate: ${product.specifications.display.refreshRate}',
      ],
    );
  }

  Widget _buildCameraSection() {
    return _buildSpecificationSection(
      'Camera',
      [
        'Main Camera: ${product.specifications.camera.rear[0].megapixels} MP, ${product.specifications.camera.rear[0].aperture}',
        'Front Camera: ${product.specifications.camera.front.megapixels} MP, ${product.specifications.camera.front.aperture}',
      ],
    );
  }

  Widget _buildBatterySection() {
    return _buildSpecificationSection(
      'Battery',
      [
        'Type: ${product.specifications.battery.type}',
        'Wired Charging: ${product.specifications.battery.charging.wired}',
        'Wireless Charging: ${product.specifications.battery.charging.wireless.join(", ")}',
      ],
    );
  }

  Widget _buildPerformanceSection() {
    return _buildSpecificationSection(
      'Performance',
      [
        'Processor: ${product.specifications.processor}',
        'Memory: ${product.specifications.memory}',
      ],
    );
  }

  Widget _buildSpecificationSection(String title, List<String> specs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...specs.map((spec) => Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 4),
          child: Text(spec),
        )).toList(),
        const SizedBox(height: 16),
      ],
    );
  }
}
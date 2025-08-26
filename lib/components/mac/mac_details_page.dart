import 'package:flutter/material.dart';

class MacDetailsPage extends StatelessWidget {
  final Map<String, dynamic> macbook;
  final Map<String, dynamic> variant;
  final String model;

  const MacDetailsPage({
    Key? key,
    required this.macbook,
    required this.variant,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final specifications = variant['specifications'];
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(model),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image with gradient background
            Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.1),
                    theme.colorScheme.background,
                  ],
                ),
              ),
              child: Image.asset(
                'assets/macbook/${model.toLowerCase().replaceAll(' ', '-')}.png',
                fit: BoxFit.contain,
              ),
            ),

            // Product details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Model name and price section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${variant['size']} MacBook Air',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '₹${variant['base_price_inr'].toString()}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Description
                  Text(
                    variant['description'],
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick specs overview
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickSpec(Icons.storage, variant['storage']),
                        _buildQuickSpec(Icons.memory, variant['memory']),
                        _buildQuickSpec(Icons.api, '${variant['gpu']}-core GPU'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Detailed specifications
                  _buildSpecSection('Configuration', [
                    'Storage: ${variant['storage']}',
                    'Memory: ${variant['memory']}',
                    'GPU: ${variant['gpu']}-core GPU',
                  ]),

                  _buildSpecSection('Display', [
                    'Type: ${specifications['display']['type']}',
                    'Resolution: ${specifications['display']['resolution']}',
                    'Brightness: ${specifications['display']['brightness']}',
                    'Color Support: ${specifications['display']['color_support']}',
                  ]),

                  _buildSpecSection('Processor', [
                    'CPU: ${specifications['chip']['cpu']}',
                    'GPU: ${specifications['chip']['gpu']}',
                    'Neural Engine: ${specifications['chip']['neural_engine']}',
                    'Memory Bandwidth: ${specifications['chip']['memory_bandwidth']}',
                  ]),

                  _buildSpecSection('Battery & Power', [
                    'Capacity: ${specifications['battery']['capacity']}',
                    'Wireless Web: ${specifications['battery']['life']['wireless_web']}',
                    'Video Playback: ${specifications['battery']['life']['video_playback']}',
                    'Adapter: ${specifications['battery']['adapter']}',
                  ]),

                  _buildSpecSection('Ports & Connectivity', [
                    ...specifications['ports'].map((port) => port.toString()).toList(),
                  ]),

                  _buildSpecSection('Camera & Audio', [
                    'Camera: ${specifications['camera']}',
                    'Speakers: ${specifications['audio']['speakers']}',
                    'Microphones: ${specifications['audio']['microphones']}',
                  ]),

                  _buildSpecSection('Physical Specifications', [
                    'Height: ${specifications['dimensions']['height']}',
                    'Width: ${specifications['dimensions']['width']}',
                    'Depth: ${specifications['dimensions']['depth']}',
                    'Weight: ${specifications['weight']}',
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSpec(IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecSection(String title, List<String> specs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: specs.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey.withOpacity(0.2),
              ),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Text(
                  specs[index],
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
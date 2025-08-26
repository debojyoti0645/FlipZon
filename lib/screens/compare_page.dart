import 'package:flipzon/models/credit_manager.dart';
import 'package:flipzon/models/product.dart';
import 'package:flipzon/models/shop.dart';
import 'package:flipzon/widgets/ad_container.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class ComparePage extends StatefulWidget {
  const ComparePage({super.key});

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  Product? device1;
  Product? device2;
  RewardedAd? _rewardedAd;
  bool _isComparing = false;
  int _credits = 0;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
    _loadCredits();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Test ad unit ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('Failed to show ad: ${error.message}');
              ad.dispose();
              _loadRewardedAd();
            },
            onAdShowedFullScreenContent: (ad) {
              debugPrint('Ad showed fullscreen content.');
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Failed to load rewarded ad: ${error.message}');
          _rewardedAd = null;
          // Retry after delay
          Future.delayed(const Duration(minutes: 1), _loadRewardedAd);
        },
      ),
    );
  }

  Future<void> _loadCredits() async {
    final credits = await CreditManager.getCredits();
    setState(() {
      _credits = credits;
    });
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      debugPrint('Warning: Attempt to show rewarded ad before loaded.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ad not ready yet. Please try again.')),
      );
      return;
    }

    _rewardedAd!.show(
      onUserEarnedReward: (_, reward) async {
        await CreditManager.addCredits(5);
        await _loadCredits();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Earned 5 Flip Credits!')),
        );
      },
    );
  }

  Future<void> _compareDevices() async {
    if (device1 == null || device2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both devices to compare')),
      );
      return;
    }

    if (await CreditManager.useCredits(10)) {
      setState(() {
        _isComparing = true;
        _credits -= 10;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Not enough credits! Watch an ad to earn more.'),
          action: SnackBarAction(
            label: 'Watch Ad',
            onPressed: _showRewardedAd,
          ),
        ),
      );
    }
  }

  Widget _buildDeviceSelector(
      String title, Product? selectedDevice, Function(Product?) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12, // Reduced from 16
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),// Reduced from 8
        Consumer<Shop>(
          builder: (context, shop, child) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<Product>(
                    value: selectedDevice,
                    hint: Text(
                      "Select a device",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12, // Reduced from 14
                      ),
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey.shade600,
                      size: 20, // Reduced icon size
                    ),
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(8),
                    dropdownColor: Colors.white,
                    menuMaxHeight: 300,
                    itemHeight: 55, // Added fixed height for items
                    items: shop.shop.map((Product product) {
                      return DropdownMenuItem<Product>(
                        value: product,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                product.image,
                                width: 32, // Reduced from 40
                                height: 32, // Reduced from 40
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 4), // Reduced from 12
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 10, // Reduced from 14
                                      fontWeight: FontWeight.bold, // Reduced from w600
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.fade
                                  ),
                                  Text(
                                    product.description,
                                    style: TextStyle(
                                      fontSize: 10, // Reduced from 12
                                      color: Colors.grey.shade600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (Product? value) => onSelect(value),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDeviceDetails(Product device) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Device Image and Basic Info
        Image.asset(device.image, height: 150, fit: BoxFit.cover),
        const SizedBox(height: 16),

        // Basic Information Section
        _buildSection(
          "Basic Information",
          [
            _buildInfoRow("Model", device.name),
            _buildInfoRow("Release Date", device.releaseDate),
            _buildInfoRow("Available Colors", device.colors.join(", ")),
            _buildInfoRow("Storage Options", device.storageOptions.join(", ")),
          ],
        ),

        // Display Section
        _buildSection(
          "Display",
          [
            _buildInfoRow("Size", device.specifications.display.size),
            _buildInfoRow("Type", device.specifications.display.type),
            _buildInfoRow(
                "Resolution", device.specifications.display.resolution),
            _buildInfoRow(
                "Refresh Rate", device.specifications.display.refreshRate),
            _buildInfoRow("Peak Brightness",
                "${device.specifications.display.brightness.peak}"),
          ],
        ),

        // Performance Section
        _buildSection(
          "Performance",
          [
            _buildInfoRow("Processor", device.specifications.processor),
            _buildInfoRow("Memory", device.specifications.memory),
          ],
        ),

        // Camera Section
        _buildSection(
          "Camera System",
          [
            _buildInfoRow("Main Camera",
                "${device.specifications.camera.rear[0].megapixels} MP, ${device.specifications.camera.rear[0].aperture}"),
            _buildInfoRow("Ultra Wide",
                "${device.specifications.camera.rear[1].megapixels} MP, ${device.specifications.camera.rear[1].aperture}"),
            if (device.specifications.camera.rear.length > 2)
              _buildInfoRow("Telephoto",
                  "${device.specifications.camera.rear[2].megapixels} MP, ${device.specifications.camera.rear[2].aperture}"),
            _buildInfoRow("Front Camera",
                "${device.specifications.camera.front.megapixels} MP, ${device.specifications.camera.front.aperture}"),
          ],
        ),

        // Battery & Charging Section
        _buildSection(
          "Battery & Charging",
          [
            _buildInfoRow(
                "Wired Charging", device.specifications.battery.charging.wired),
            _buildInfoRow("Wireless Charging",
                device.specifications.battery.charging.wireless.join(", ")),
          ],
        ),

        // Physical Specifications
        _buildSection(
          "Physical Look",
          [
            _buildInfoRow("Dimensions",
                "${device.specifications.dimensions.height} × ${device.specifications.dimensions.width} × ${device.specifications.dimensions.depth}"),
            _buildInfoRow("Weight", device.specifications.weight),
          ],
        ),

        // Price Section
        _buildSection(
          "Pricing",
          device.storageOptions
              .map((storage) =>
                  _buildInfoRow(storage, "₹${device.prices[storage]}"))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(
                  _getSectionIcon(title),
                  color: Colors.blue.shade700,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  title,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  // Add this helper method to get section icons
  IconData _getSectionIcon(String title) {
    switch (title) {
      case 'Basic Information':
        return Icons.info_outline;
      case 'Display':
        return Icons.phone_android;
      case 'Performance':
        return Icons.speed;
      case 'Camera System':
        return Icons.camera_alt_outlined;
      case 'Battery & Charging':
        return Icons.battery_charging_full;
      case 'Physical Specifications':
        return Icons.straighten;
      case 'Pricing':
        return Icons.attach_money;
      default:
        return Icons.info_outline;
    }
  }

  // Update the _buildInfoRow method as well
  Widget _buildInfoRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48.0), // Reduced height
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Compare Devices',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.stars, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '$_credits',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.secondary.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            AdContainer(
              onWatchPress: _showRewardedAd,
              credits: _credits,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildDeviceSelector(
                                "Device 1",
                                device1,
                                (Product? p) => setState(() => device1 = p),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _buildDeviceSelector(
                                "Device 2",
                                device2,
                                (Product? p) => setState(() => device2 = p),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: !_isComparing ? _compareDevices : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.compare_arrows, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            !_isComparing ? 'Compare (10 Credits)' : 'Comparing...',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Show comparison results only if _isComparing is true
                    if (_isComparing && device1 != null && device2 != null)
                      Expanded(
                        child: SingleChildScrollView(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Device 1 Column
                              Expanded(
                                child: Card(
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _buildDeviceDetails(device1!),
                                  ),
                                ),
                              ),

                              // Device 2 Column
                              Expanded(
                                child: Card(
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _buildDeviceDetails(device2!),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    if (!_isComparing)
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Select two devices and press compare",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

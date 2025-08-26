import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class IpadComparePage extends StatefulWidget {
  const IpadComparePage({super.key});

  @override
  State<IpadComparePage> createState() => _IpadComparePageState();
}

class _IpadComparePageState extends State<IpadComparePage> {
  List<dynamic> _devices = [];
  Map<String, dynamic>? device1;
  Map<String, dynamic>? device2;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    final String jsonString = await rootBundle.loadString('lib/device_data/ipadSeries.json');
    setState(() {
      _devices = json.decode(jsonString);
    });
  }

  Widget _buildDeviceSelector(String title, Map<String, dynamic>? selectedDevice, Function(Map<String, dynamic>?) onSelect) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButton<Map<String, dynamic>>(
            value: selectedDevice,
            hint: const Text("Select an iPad model"),
            isExpanded: true,
            items: _devices.map((device) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: device as Map<String, dynamic>,
                child: Text(
                  device['model'] as String,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) => onSelect(value),
          ),
        ],
      ),
    );
  }

  // Modify _buildSpecificationComparison method
  Widget _buildSpecificationComparison() {
    if (device1 == null || device2 == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Select two devices to compare",
            style: TextStyle(fontSize: 20, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDeviceDetailsColumn(device1!),
          const SizedBox(width: 16),
          Container(
            width: 2,
            height: 800, // Adjust this height based on your content
            color: Colors.grey[300],
          ),
          const SizedBox(width: 16),
          _buildDeviceDetailsColumn(device2!),
        ],
      ),
    );
  }

  // Add this new method for column layout
  Widget _buildDeviceDetailsColumn(Map<String, dynamic> device) {
    final specs = device['specifications'] as Map<String, dynamic>;
    
    return Container(
      width: 300, // Fixed width for each column
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            device['model'] as String,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          _buildComparisonSection("Display", [
            _buildComparisonRow("Size", specs['display']['size']),
            _buildComparisonRow("Type", specs['display']['type']),
            _buildComparisonRow("Resolution", specs['display']['resolution'] is String 
                ? specs['display']['resolution'] 
                : specs['display']['resolution']['11']),
            _buildComparisonRow("Refresh Rate", specs['display']['refresh_rate'] ?? 'N/A'),
          ]),

          _buildComparisonSection("Performance", [
            _buildComparisonRow("Processor", specs['processor']),
            _buildComparisonRow("Memory", specs['memory']),
            _buildComparisonRow("Storage", (specs['storage'] as List).join(", ")),
          ]),

          _buildComparisonSection("Camera", [
            _buildComparisonRow("Main Camera", 
              specs['camera']['rear'] is List 
                ? "${specs['camera']['rear'][0]['megapixels']}"
                : "${specs['camera']['rear']['megapixels']}"),
            _buildComparisonRow("Front Camera", "${specs['camera']['front']['megapixels']}"),
          ]),

          _buildComparisonSection("Battery & Charging", [
            _buildComparisonRow("Type", specs['battery']['type']),
            _buildComparisonRow("Charging", specs['battery']['charging']['wired']),
          ]),

          _buildComparisonSection("Physical", [
            _buildComparisonRow("Height", specs['dimensions'] is Map 
                ? specs['dimensions']['height'] 
                : "Varies by model"),
            _buildComparisonRow("Width", specs['dimensions'] is Map 
                ? specs['dimensions']['width'] 
                : "Varies by model"),
            _buildComparisonRow("Depth", specs['dimensions'] is Map 
                ? specs['dimensions']['depth'] 
                : "Varies by model"),
          ]),

          _buildComparisonSection("Pricing", [
            ...device['storage_prices'].entries.map((e) => 
              _buildComparisonRow(e.key, "₹${e.value}")
            ).toList(),
          ]),
        ],
      ),
    );
  }

  // Add these new helper methods
  Widget _buildComparisonSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            width: double.infinity,
            color: Colors.blue[50],
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 8),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iPad Comparison'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Replace Row with Column for phone layout
              Column(
                children: [
                  _buildDeviceSelector(
                    "First iPad",
                    device1,
                    (value) => setState(() => device1 = value),
                  ),
                  const SizedBox(height: 16),
                  _buildDeviceSelector(
                    "Second iPad",
                    device2,
                    (value) => setState(() => device2 = value),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSpecificationComparison(),
            ],
          ),
        ),
      ),
    );
  }
}
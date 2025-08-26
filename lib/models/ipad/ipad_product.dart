class IpadProduct {
  final String model;
  final String releaseDate;
  final List<String> colors;
  final List<String> storageOptions;
  final Map<String, String> storagePrices;
  final String description;
  final IpadSpecifications specifications;

  IpadProduct({
    required this.model,
    required this.releaseDate,
    required this.colors,
    required this.storageOptions,
    required this.storagePrices,
    required this.description,
    required this.specifications,
  });

  factory IpadProduct.fromJson(Map<String, dynamic> json) {
    return IpadProduct(
      model: json['model'],
      releaseDate: json['release_date'],
      colors: List<String>.from(json['colors']),
      storageOptions: List<String>.from(json['storage_options']),
      storagePrices: Map<String, String>.from(json['storage_prices']),
      description: json['description'],
      specifications: IpadSpecifications.fromJson(json['specifications']),
    );
  }
}

class IpadSpecifications {
  final Display display;
  final String processor;
  final String memory;
  final List<String> storage;
  final Battery battery;
  final Camera camera;
  final String operatingSystem;
  final List<String> connectivity;
  final Dimensions? dimensions;

  IpadSpecifications({
    required this.display,
    required this.processor,
    required this.memory,
    required this.storage,
    required this.battery,
    required this.camera,
    required this.operatingSystem,
    required this.connectivity,
    this.dimensions,
  });

  factory IpadSpecifications.fromJson(Map<String, dynamic> json) {
    return IpadSpecifications(
      display: Display.fromJson(json['display']),
      processor: json['processor'],
      memory: json['memory'],
      storage: List<String>.from(json['storage']),
      battery: Battery.fromJson(json['battery']),
      camera: Camera.fromJson(json['camera']),
      operatingSystem: json['operating_system'],
      connectivity: List<String>.from(json['connectivity']),
      dimensions: json['dimensions'] != null ? Dimensions.fromJson(json['dimensions']) : null,
    );
  }
}

class Display {
  final String size;
  final String type;
  final dynamic resolution;
  final String? refreshRate;
  final Map<String, dynamic> brightness;

  Display({
    required this.size,
    required this.type,
    required this.resolution,
    this.refreshRate,
    required this.brightness,
  });

  factory Display.fromJson(Map<String, dynamic> json) {
    return Display(
      size: json['size'],
      type: json['type'],
      resolution: json['resolution'],
      refreshRate: json['refresh_rate'],
      brightness: Map<String, dynamic>.from(json['brightness']),
    );
  }
}

class Battery {
  final String type;
  final Map<String, dynamic> charging;

  Battery({
    required this.type,
    required this.charging,
  });

  factory Battery.fromJson(Map<String, dynamic> json) {
    return Battery(
      type: json['type'],
      charging: Map<String, dynamic>.from(json['charging']),
    );
  }
}

class Camera {
  final dynamic rear;
  final Map<String, dynamic> front;

  Camera({
    required this.rear,
    required this.front,
  });

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
      rear: json['rear'],
      front: Map<String, dynamic>.from(json['front']),
    );
  }
}

class Dimensions {
  final String? height;
  final String? width;
  final String? depth;

  Dimensions({
    this.height,
    this.width,
    this.depth,
  });

  factory Dimensions.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Dimensions();
    }
    return Dimensions(
      height: json['height']?.toString(),
      width: json['width']?.toString(),
      depth: json['depth']?.toString(),
    );
  }
}
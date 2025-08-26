class Product {
  final String id; // Add this field
  final String name;
  final String releaseDate;
  final List<String> colors;
  final List<String> storageOptions;
  final Map<String, String> prices;
  final String description;
  final String image;
  final String type;
  final Specifications specifications;

  Product({
    required this.id,
    required this.name,
    required this.releaseDate,
    required this.colors,
    required this.storageOptions,
    required this.prices,
    required this.description,
    required this.image,
    required this.type,
    required this.specifications,
  });
}

class Specifications {
  final Display display;
  final String processor;
  final String memory;
  final Battery battery;
  final Camera camera;
  final Dimensions dimensions;
  final String weight;

  Specifications({
    required this.display,
    required this.processor,
    required this.memory,
    required this.battery,
    required this.camera,
    required this.dimensions,
    required this.weight,
  });
}

class Display {
  final String size;
  final String type;
  final String resolution;
  final String refreshRate;
  final Brightness brightness;

  Display({
    required this.size,
    required this.type,
    required this.resolution,
    required this.refreshRate,
    required this.brightness,
  });
}

class Brightness {
  final String typical;
  final String peak;

  Brightness({
    required this.typical,
    required this.peak,
  });
}

class Battery {
  final String type;
  final Charging charging;

  Battery({
    required this.type,
    required this.charging,
  });
}

class Charging {
  final String wired;
  final List<String> wireless;

  Charging({
    required this.wired,
    required this.wireless,
  });
}

class Camera {
  final List<CameraLens> rear;
  final CameraLens front;

  Camera({
    required this.rear,
    required this.front,
  });
}

class CameraLens {
  final String megapixels;
  final String aperture;
  final String lens;

  CameraLens({
    required this.megapixels,
    required this.aperture,
    required this.lens,
  });
}

class Dimensions {
  final String height;
  final String width;
  final String depth;

  Dimensions({
    required this.height,
    required this.width,
    required this.depth,
  });
}

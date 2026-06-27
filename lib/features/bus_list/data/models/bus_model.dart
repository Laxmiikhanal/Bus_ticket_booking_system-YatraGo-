class BusModel {
  final String id;
  final String name;
  final String type;
  final String from;
  final String to;
  final String departure;
  final String arrival;
  final String duration;
  final int price;
  final int totalSeats;
  final int availableSeats;
  final List<String> amenities;
  final double rating;
  final bool isActive;

  const BusModel({
    required this.id,
    required this.name,
    required this.type,
    required this.from,
    required this.to,
    required this.departure,
    required this.arrival,
    required this.duration,
    required this.price,
    required this.totalSeats,
    required this.availableSeats,
    required this.amenities,
    required this.rating,
    required this.isActive,
  });

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      id: json["_id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "Unknown Bus",
      type: json["type"]?.toString() ?? "",
      from: json["from"]?.toString() ?? "",
      to: json["to"]?.toString() ?? "",
      departure: json["departure"]?.toString() ?? "",
      arrival: json["arrival"]?.toString() ?? "",
      duration: json["duration"]?.toString() ?? "",
      price: _toInt(json["price"]),
      totalSeats: _toInt(json["totalSeats"]),
      availableSeats: _toInt(json["availableSeats"]),
      amenities: (json["amenities"] as List?)?.map((e) => e.toString()).toList() ?? <String>[],
      rating: _toDouble(json["rating"]),
      isActive: json["isActive"] == true,
    );
  }

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v?.toString() ?? "") ?? 0;
  }

  static double _toDouble(dynamic v) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v?.toString() ?? "") ?? 0.0;
  }
}

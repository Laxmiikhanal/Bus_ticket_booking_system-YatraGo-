class BookingModel {
  final String id;
  final String bookingId;
  final String busId;
  final String busName;
  final String from;
  final String to;
  final String departure;
  final List<String> selectedSeats;
  final String passengerName;
  final String passengerPhone;
  final String passengerEmail;
  final int totalPrice;
  final String paymentMethod;
  final String paymentStatus;
  final String bookingStatus;
  final String refundStatus;
  final DateTime? createdAt;

  const BookingModel({
    required this.id,
    required this.bookingId,
    required this.busId,
    required this.busName,
    required this.from,
    required this.to,
    required this.departure,
    required this.selectedSeats,
    required this.passengerName,
    required this.passengerPhone,
    required this.passengerEmail,
    required this.totalPrice,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.bookingStatus,
    this.refundStatus = "not_applicable",
    this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json["_id"]?.toString() ?? "",
      bookingId: json["bookingId"]?.toString() ?? "",
      busId: json["busId"]?.toString() ?? "",
      busName: json["busName"]?.toString() ?? "",
      from: json["from"]?.toString() ?? "",
      to: json["to"]?.toString() ?? "",
      departure: json["departure"]?.toString() ?? "",
      selectedSeats: (json["selectedSeats"] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[],
      passengerName: json["passengerName"]?.toString() ?? "",
      passengerPhone: json["passengerPhone"]?.toString() ?? "",
      passengerEmail: json["passengerEmail"]?.toString() ?? "",
      totalPrice: _toInt(json["totalPrice"]),
      paymentMethod: json["paymentMethod"]?.toString() ?? "",
      paymentStatus: json["paymentStatus"]?.toString() ?? "pending",
      bookingStatus: json["bookingStatus"]?.toString() ?? "confirmed",
      refundStatus: json["refundStatus"]?.toString() ?? "not_applicable",
      createdAt: DateTime.tryParse(json["createdAt"]?.toString() ?? ""),
    );
  }

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v?.toString() ?? "") ?? 0;
  }
}
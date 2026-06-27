class AuthEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String? token;

  const AuthEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.token,
  });

  String get fullName => "$firstName $lastName".trim();

  factory AuthEntity.fromJson(Map<String, dynamic> json, {String? token}) {
    return AuthEntity(
      id: json["_id"]?.toString() ?? "",
      firstName: json["firstName"]?.toString() ?? "",
      lastName: json["lastName"]?.toString() ?? "",
      email: json["email"]?.toString() ?? "",
      role: json["role"]?.toString() ?? "user",
      token: token,
    );
  }
}

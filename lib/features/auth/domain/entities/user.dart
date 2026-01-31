class User {
  final int id;
  final String email;
  final String phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });
}

class Account {
  final int id;
  final int userId;
  final String firstAmount;
  final String currentAmount;
  final String createdAt;
  final String updatedAt;
  final User user;

  Account({
    required this.id,
    required this.userId,
    required this.firstAmount,
    required this.currentAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  // Factory method for parsing JSON
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      userId: json['user_id'],
      firstAmount: json['first_amount'],
      currentAmount: json['current_amount'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method for parsing JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

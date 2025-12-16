class AuthResponse {
  final String token;
  final String userId;
  final String email;
  final String? message;

  AuthResponse({
    required this.token,
    required this.userId,
    required this.email,
    this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};

    return AuthResponse(
      token: json['token'] ?? json['accessToken'] ?? '',
      userId: json['userId'] ?? user['id'] ?? user['_id'] ?? json['id'] ?? '',
      email: json['email'] ?? user['email'] ?? '',
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
      'email': email,
      'message': message,
    };
  }
}

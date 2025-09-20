class LoginData {
  final String email;
  final String password;
  final bool acceptTerms;

  const LoginData({
    required this.email,
    required this.password,
    required this.acceptTerms,
  });

  LoginData copyWith({
    String? email,
    String? password,
    bool? acceptTerms,
  }) {
    return LoginData(
      email: email ?? this.email,
      password: password ?? this.password,
      acceptTerms: acceptTerms ?? this.acceptTerms,
    );
  }
}
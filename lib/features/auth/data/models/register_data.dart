class RegisterData {
  final String email;
  final String password;
  final String confirmPassword;
  final bool acceptTerms;

  const RegisterData({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.acceptTerms,
  });

  RegisterData copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    bool? acceptTerms,
  }) {
    return RegisterData(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      acceptTerms: acceptTerms ?? this.acceptTerms,
    );
  }

  bool get passwordsMatch => password == confirmPassword;
  bool get isValid => email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty && acceptTerms && passwordsMatch;
}
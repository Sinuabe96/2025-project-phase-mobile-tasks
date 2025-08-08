class SignupReqParams {
  final String name;
  final String email;
  final String password;

  SignupReqParams({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,  // Try 'name' instead of 'username'
      'email': email,
      'password': password,
    };
  }
}

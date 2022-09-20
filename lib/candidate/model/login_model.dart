class LoginModel {
  int? id;
  String? email;
  String? token;
  int? status;

  LoginModel(
      {required this.id,
      required this.email,
      required this.token,
      required this.status});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
        id: json['id'],
        email: json['email'],
        token: json['token'],
        status: json['status']);
  }
}

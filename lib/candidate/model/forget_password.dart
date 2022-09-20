class Forgets {
  dynamic data;
  String? message;

  Forgets({this.data, this.message});

  Forgets.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data;
    data['message'] = message;
    return data;
  }
}

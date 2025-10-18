class AdminModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? image;
  String? datetime;

  AdminModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.phone,
    this.image,
    this.datetime,
  });

  AdminModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    image = json['image'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    data['image'] = image;
    data['datetime'] = datetime;
    return data;
  }
}

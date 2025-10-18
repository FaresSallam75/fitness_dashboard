class CoachModel {
  int? id;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? gender;
  int? age;
  String? twon;
  String? image;
  String? emailCreate;

  CoachModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.phone,
    this.gender,
    this.age,
    this.twon,
    this.image,
    this.emailCreate,
  });

  CoachModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    gender = json['gender'];
    age = json['age'];
    twon = json['twon'];
    image = json['image'];
    emailCreate = json['emailCreate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    data['gender'] = gender;
    data['age'] = age;
    data['twon'] = twon;
    data['image'] = image;
    data['emailCreate'] = emailCreate;
    return data;
  }
}

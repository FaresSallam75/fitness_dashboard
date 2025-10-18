class ExportModel {
  int? id;
  String? name;
  int? count;
  int? price;
  int? adminId;
  String? exportDate;

  ExportModel({
    this.id,
    this.name,
    this.count,
    this.price,
    this.adminId,
    this.exportDate,
  });

  ExportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    count = json['count'];
    price = json['price'];
    adminId = json['adminId'];
    exportDate = json['exportDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['count'] = count;
    data['price'] = price;
    data['adminId'] = adminId;
    data['exportDate'] = exportDate;
    return data;
  }
}

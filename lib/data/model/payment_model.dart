class PaymentModel {
  int? paymentId;
  int? userId;
  int? adminId;
  int? price;
  String? startDate;
  String? endDate;
  String? type;
  int? status;

  PaymentModel({
    this.paymentId,
    this.userId,
    this.adminId,
    this.price,
    this.startDate,
    this.endDate,
    this.type,
    this.status,
  });

  PaymentModel.fromJson(Map<String, dynamic> json) {
    paymentId = json['paymentId'];
    userId = json['userId'];
    adminId = json['adminId'];
    price = json['price'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    type = json['type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymentId'] = paymentId;
    data['userId'] = userId;
    data['adminId'] = adminId;
    data['price'] = price;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['type'] = type;
    data['status'] = status;
    return data;
  }
}

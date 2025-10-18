class OfferModel {
  int? id;
  String? name;
  String? period;
  int? price;
  String? image;
  String? offerDateTime;

  OfferModel({
    this.id,
    this.name,
    this.period,
    this.price,
    this.image,
    this.offerDateTime,
  });

  OfferModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    period = json['period'];
    price = json['price'];
    image = json['image'];
    offerDateTime = json['offerDateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['period'] = period;
    data['price'] = price;
    data['image'] = image;
    data['offerDateTime'] = offerDateTime;
    return data;
  }
}

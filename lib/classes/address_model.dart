class AddressModel {
  int id;
  String fullAddress;
  String district;
  String city;
  String postCode;

  AddressModel({
    this.id,
    this.fullAddress,
    this.district,
    this.city,
    this.postCode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json["aid"],
      fullAddress: json["fullAddress"],
      district: json["district"],
      city: json["city"],
      postCode: json["postcode"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "aid": id,
      "fullAddress": fullAddress,
      "district": district,
      "city": city,
      "postcode": postCode,
    };
  }
}

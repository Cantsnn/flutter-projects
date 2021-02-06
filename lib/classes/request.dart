class Request {
  int id;
  int userId;
  int addressId;
  int stateInfo;

  Request({this.id, this.addressId, this.stateInfo, this.userId});

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json["reqID"],
      addressId: json["addressID"],
      stateInfo: json["state"],
      userId: json["userId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "reqID": id,
      "addressID": addressId,
      "userID": userId,
      "state": stateInfo,
    };
  }
}

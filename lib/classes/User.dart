import 'package:flutter/cupertino.dart';
import 'package:ileri_donusum/classes/address_model.dart';
import 'package:ileri_donusum/classes/request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User extends ChangeNotifier {
  int id;
  String firstName;
  String lastName;
  String gender;
  String birthDay;
  String phoneNumber;
  String eMail;
  String password;
  String verifyEmail;
  int recordTime;
  bool isBlock;
  List<AddressModel> addressList;
  List<Request> requestList;
  SharedPreferences shrdPrf;
  User({
    this.firstName,
    this.lastName,
    this.gender,
    this.phoneNumber,
    this.eMail,
    this.password,
    this.id,
    this.birthDay,
    this.verifyEmail,
    this.recordTime,
    this.isBlock,
    this.addressList,
  }) {
    addressList = List<AddressModel>();
    requestList = List<Request>();

    notifyListeners();
  }

  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      id: json["id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      gender: json["gender"],
      birthDay: json["birthDay"],
      phoneNumber: json["phoneNumber"],
      eMail: json["email"],
      password: json["password"],
      verifyEmail: json["verifyEmail"],
      recordTime: json["recordTime"],
      isBlock: json["isBlock"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "birthDaty": birthDay,
      "phoneNumber": phoneNumber,
      "email": eMail,
      "password": password,
      "verifyEmail": verifyEmail,
      "recordTime": recordTime,
      "isBlock": isBlock,
    };
  }

  void changeValues(User user) {
    this.firstName = user.firstName;
    this.lastName = user.lastName;
    this.gender = user.gender;
    this.phoneNumber = user.phoneNumber;
    this.eMail = user.eMail;
    this.password = user.password;
    this.id = user.id;
    this.birthDay = user.birthDay;
    this.verifyEmail = user.verifyEmail;
    this.recordTime = user.recordTime;
    this.isBlock = user.isBlock;
  }

  Future<void> createSharedPref() async {
    shrdPrf = await SharedPreferences.getInstance();
  }

  Future<void> saveUserInfoToShrdPref(String userInfo) async {
    await createSharedPref();
    shrdPrf.setString("userInfo", userInfo);
  }

  void addToList(dynamic item) {
    item.runtimeType.toString() == "AddressModel"
        ? addressList.add(item)
        : requestList.add(item);

    //notifyListeners();
  }

  void changeAddressItems(int index, AddressModel item) {
    addressList[index] = item;
    //notifyListeners();
  }

  void removeFromList(dynamic item) {
    item.runtimeType.toString() == "AddressModel"
        ? addressList.remove(item)
        : requestList.remove(item);
    //notifyListeners();
  }
}

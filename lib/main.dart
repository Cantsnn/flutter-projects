import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ileri_donusum/classes/User.dart';
import 'package:ileri_donusum/classes/address_model.dart';
import 'package:ileri_donusum/pages/home_page.dart';
import 'package:ileri_donusum/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  String password;
  List<String> addressStringList = List<String>();
  List<AddressModel> addressList = List<AddressModel>();

  if (pref.getStringList("addressList") != null) {
    addressStringList = pref.getStringList("addressList");
    addressList = addressStringList
        .map((e) => AddressModel.fromJson(json.decode(e)))
        .toList();
  }
  if (pref.getString("password") != null) {
    password = pref.getString("password");
  }
  runApp(ChangeNotifierProvider<User>(
    create: (context) {
      return pref.getString("userInfo") != null
          ? User.fromJson(
              json.decode(
                pref.getString("userInfo"),
              ),
            )
          : User();
    },
    child: MyApp(
      password: password,
      addressList: addressList,
      isLogin:
          pref.getBool("isLogin") != null ? pref.getBool("isLogin") : false,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final String password;
  final bool isLogin;
  final List<AddressModel> addressList;
  MyApp({
    this.password,
    this.isLogin,
    this.addressList,
  });
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.lightGreenAccent[700],
        accentColor: Colors.black,
      ),
      home: isLogin
          ? HomePage(
              password: password,
              addressList: addressList,
            )
          : LogInPage(),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ileri_donusum/classes/address_model.dart';
import 'package:ileri_donusum/pages/home_page.dart';
import 'package:ileri_donusum/http_methods.dart';
import 'package:ileri_donusum/pages/register_page.dart';
import 'package:ileri_donusum/useful_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/User.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController emailCtrl;
  TextEditingController passwordCtrl;
  Map<String, dynamic> responseData;
  SharedPreferences sharedPref;
  bool isLoading = false;
  User user;

  @override
  void initState() {
    super.initState();
    emailCtrl = new TextEditingController(
      text: "raptelacann@gmail.com",
    );
    passwordCtrl = new TextEditingController(
      text: "123456",
    );
  }

  Future<void> createSharedPref() async {
    sharedPref = await SharedPreferences.getInstance();
  }

  void logIn() async {
    responseData = await httpPost(
      "https://appupcycling.herokuapp.com/api/users/signin",
      itemBody: json.encode(<String, String>{
        "email": emailCtrl.text,
        "password": passwordCtrl.text,
      }),
    );
    Provider.of<User>(context, listen: false).changeValues(
      User.fromJson(
        responseData["content"],
      ),
    );
    await getAddresListToUser();
    await saveAddresListToShrdPrf();
    await Provider.of<User>(context, listen: false).saveUserInfoToShrdPref(
      json.encode(responseData["content"]),
    );

    goToHomePage(responseData["info"]["isSucces"]);
  }

  Future<void> saveAddresListToShrdPrf() async {
    await createSharedPref();
    List<String> stringList = List<String>();
    stringList = Provider.of<User>(context, listen: false)
        .addressList
        .map((e) => json.encode(e.toJson()))
        .toList();
    sharedPref.setStringList("addressList", stringList);
  }

  Future<void> getAddresListToUser() async {
    int userId = Provider.of<User>(context, listen: false).id;

    dynamic response = await httpGet(
      "https://appupcycling.herokuapp.com/api/users/$userId/address",
    );

    if (response["info"]["isSucces"]) {
      Provider.of<User>(context, listen: false).addressList =
          List<AddressModel>();

      for (var i = 0; i < response["content"].length; i++) {
        Provider.of<User>(context, listen: false)
            .addressList
            .add(AddressModel.fromJson(response["content"][i]));
      }
    } else {
      Provider.of<User>(context, listen: false).addressList =
          List<AddressModel>();
    }
  }

  void goToHomePage(bool isSucces) async {
    if (isSucces) {
      await createSharedPref();
      sharedPref.setBool("isLogin", isSucces);
      sharedPref.setString("password", passwordCtrl.text);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomePage(
              password: passwordCtrl.text,
            );
          },
        ),
        (route) => false,
      );
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void signUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Register();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "İLERİ DÖNÜŞÜM",
        ),
        centerTitle: true,
        backgroundColor: Colors.lightGreenAccent[700],
      ),
      backgroundColor: Colors.green,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36.0),
            color: Colors.white,
          ),
          height: 400,
          width: 370,
          padding: EdgeInsets.all(40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                buildTextForm(
                  label: "E-Posta",
                  ctrl: emailCtrl,
                  itemIcon: Icon(Icons.email),
                ),
                PasswordDesign(
                  label: "Şifre",
                  ctrl: passwordCtrl,
                ),
                responseData != null && !responseData["info"]["isSucces"]
                    ? Text(
                        responseData["info"]["message"],
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      )
                    : Padding(padding: EdgeInsets.all(10)),
                !isLoading
                    ? MaterialButton(
                        color: Colors.lightGreenAccent[700],
                        minWidth: 280,
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          logIn();
                        },
                        child: Text("Giriş Yap"),
                      )
                    : buildRefreshProgressIndicator(),
                Padding(padding: EdgeInsets.all(5)),
                MaterialButton(
                  color: Colors.blue,
                  minWidth: 280,
                  onPressed: signUp,
                  child: Text("Kayıt Ol"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

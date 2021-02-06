import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ileri_donusum/classes/User.dart';
import 'package:ileri_donusum/classes/address_model.dart';
import 'package:ileri_donusum/http_methods.dart';
import 'package:ileri_donusum/useful_widgets.dart';
import 'package:provider/provider.dart';

class PersonSetting extends StatefulWidget {
  @override
  _PersonSettingState createState() => _PersonSettingState();
}

class _PersonSettingState extends State<PersonSetting> {
  String email;
  String password;
  List<TextEditingController> controllerList;
  List<AddressModel> addressList;
  User usr;
  bool isLoading = false;
  @override
  void initState() {
    email = Provider.of<User>(context, listen: false).eMail;
    password = Provider.of<User>(context, listen: false).password;
    usr = User.fromJson(Provider.of<User>(context, listen: false).toJson());
    addressList = Provider.of<User>(context, listen: false).addressList;

    controllerList = <TextEditingController>[
      TextEditingController(text: usr.firstName),
      TextEditingController(text: usr.lastName),
      TextEditingController(text: usr.gender),
      TextEditingController(text: usr.phoneNumber),
    ];

    super.initState();
  }

  Future<void> saveUserInfo() async {
    User user =
        User.fromJson(Provider.of<User>(context, listen: false).toJson());
    Provider.of<User>(context, listen: false)
        .saveUserInfoToShrdPref(json.encode(user.toJson()));
  }

  void dataSave() async {
    dynamic response = await httpPut(
      "https://appupcycling.herokuapp.com/api/users/update/${usr.id}",
      json.encode(<String, dynamic>{
        "firstName": controllerList[0].text,
        "lastName": controllerList[1].text,
        "gender": controllerList[2].text,
        "phoneNumber": controllerList[3].text,
        "birthDay": null,
      }),
    );
    if (response != null) {
      if (response["info"]["isSucces"]) {
        Provider.of<User>(context, listen: false).changeValues(
          User.fromJson(
            response["content"],
          ),
        );
        Provider.of<User>(context, listen: false).eMail = email;
        Provider.of<User>(context, listen: false).password = password;
        await saveUserInfo();
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
    Fluttertoast.showToast(
      msg: response["info"]["message"],
      backgroundColor: response["info"]["isSucces"] ? Colors.green : Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KİŞİSEL BİLGİLER'),
        centerTitle: true,
      ),
      backgroundColor: Colors.green,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36.0),
            color: Colors.white,
          ),
          padding: EdgeInsets.only(bottom: 50, left: 20, right: 20),
          height: 500,
          width: 370,
          child: Center(
            child: !isLoading
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        buildTextForm(
                          itemIcon: Icon(Icons.contacts, color: Colors.black87),
                          label: "İsim",
                          ctrl: controllerList[0],
                        ),
                        buildTextForm(
                          itemIcon: Icon(
                            Icons.contacts_outlined,
                            color: Colors.black87,
                          ),
                          label: "Soy İsim",
                          ctrl: controllerList[1],
                        ),
                        buildTextForm(
                          label: "Cinsiyet",
                          ctrl: controllerList[2],
                        ),
                        buildTextForm(
                          label: "Telefon Numarası",
                          ctrl: controllerList[3],
                          itemIcon: Icon(
                            Icons.call,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 30),
                        MaterialButton(
                          minWidth: 150,
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            dataSave();
                          },
                          child: Text('KAYDET'),
                          color: Colors.amber,
                        )
                      ],
                    ),
                  )
                : buildRefreshProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

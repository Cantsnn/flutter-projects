import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ileri_donusum/http_methods.dart';
import '../useful_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  List<TextEditingController> controllerList;
  Future<Map<String, dynamic>> responseData;

  Future<Map<String, dynamic>> createUser() async {
    return httpPost(
      "https://appupcycling.herokuapp.com/api/users/register",
      itemBody: json.encode(<String, String>{
        "firstName": controllerList[0].text,
        "lastName": controllerList[1].text,
        "phoneNumber": controllerList[2].text,
        "email": controllerList[3].text,
        "password": controllerList[4].text,
        "gender": controllerList[5].text,
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    controllerList = <TextEditingController>[
      for (var i = 0; i < 6; i++) TextEditingController(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kayıt"),
        centerTitle: true,
      ),
      backgroundColor: Colors.green,
      body: Center(
        child: Container(
          height: 550,
          width: 370,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36.0),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(30),
          child: Center(
            child: SingleChildScrollView(
              child: (responseData == null)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        buildTextForm(
                          itemIcon: Icon(
                            Icons.contacts,
                            color: Colors.black87,
                          ),
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
                          label: "Telefon Numarası",
                          ctrl: controllerList[2],
                          itemIcon: Icon(
                            Icons.call,
                            color: Colors.black87,
                          ),
                        ),
                        buildTextForm(
                          label: "E-Posta",
                          ctrl: controllerList[3],
                          itemIcon: Icon(
                            Icons.email,
                            color: Colors.black87,
                          ),
                        ),
                        PasswordDesign(
                          label: "Şifre",
                          ctrl: controllerList[4],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: GenderSelector(
                                onPress: () {
                                  setState(() {
                                    controllerList[5].text = 'kadin';
                                  });
                                },
                                color: controllerList[5].text == 'kadin'
                                    ? Colors.pink[200]
                                    : Colors.white,
                                child: GenderIcon(
                                  genderName: 'KADIN',
                                  icon: FontAwesomeIcons.female,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Expanded(
                              child: GenderSelector(
                                onPress: () {
                                  setState(() {
                                    controllerList[5].text = 'erkek';
                                  });
                                },
                                color: controllerList[5].text == 'erkek'
                                    ? Colors.lightBlue[100]
                                    : Colors.white,
                                child: GenderIcon(
                                  genderName: 'ERKEK',
                                  icon: FontAwesomeIcons.male,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(4)),
                        MaterialButton(
                          color: Colors.amber,
                          minWidth: 280,
                          onPressed: () {
                            for (var i = 0; i < 6; i++) {
                              if (controllerList[i].text == "") {
                                Fluttertoast.showToast(
                                  msg: "Formun tamamını doldurmalısınız.",
                                  backgroundColor: Colors.red,
                                );
                                return;
                              }
                            }
                            setState(() {
                              responseData = createUser();
                            });
                          },
                          child: Text("Kayıt Ol"),
                        ),
                      ],
                    )
                  : FutureBuilder(
                      future: responseData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) return buildPage(snapshot);
                        return Center(
                          child: Column(
                            children: <Widget>[
                              buildRefreshProgressIndicator(),
                              Padding(padding: EdgeInsets.all(5)),
                              Text("Kaydınız Alınıyor..."),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Center buildPage(AsyncSnapshot snapshot) {
    return Center(
      child: (snapshot.data["info"]["isSucces"])
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.verified,
                  size: 50,
                  color: Colors.green,
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  snapshot.data["info"]["message"],
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Icon(
                  Icons.error,
                  size: 50,
                  color: Colors.red,
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  snapshot.data["info"]["message"],
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
    );
  }
}

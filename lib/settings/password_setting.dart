import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ileri_donusum/classes/User.dart';
import 'package:ileri_donusum/useful_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../http_methods.dart';

class PasswordSetting extends StatefulWidget {
  @override
  _PasswordSettingState createState() => _PasswordSettingState();
}

class _PasswordSettingState extends State<PasswordSetting> {
  SharedPreferences sharedPassword;
  TextEditingController password = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  bool passwordVisible = false;
  bool passwordVisible2 = false;
  String currentPassword;
  bool isWrong=false;
  bool isLoading=false;

 
  @override
  void initState() {
    super.initState();
    print(Provider.of<User>(context,listen: false).password);
    currentPassword = Provider.of<User>(context,listen: false).password;
    
  }
  
  Future<void> createSharedPref()async{
    sharedPassword = await SharedPreferences.getInstance();
  }

  Future<void> loadSharedPref() async{
    await createSharedPref();
    sharedPassword.setString("password", newPassword.text);
  }


  void savePassword() async{
    
      if (password.text == "" || newPassword.text=="") {
           Fluttertoast.showToast(
                msg: "Şifre kısmı boş olamaz",
                 backgroundColor: Colors.red,
               );
           return;
          }

    setState(() {
      isWrong = false;
  
    });
    if(currentPassword!=password.text){
      setState(() {
        isWrong=true;
        
      });
      return;
    }

    setState(() {
       isLoading=true;
    });
    dynamic response = await httpPut(
      "https://appupcycling.herokuapp.com/api/users/updatePassword/${Provider.of<User>(context,listen: false).id}",
      json.encode(<String, dynamic>{
        "password" : newPassword.text,
      }),
    );
  if(response!=null){
        setState(() {
          isLoading=false;
      });
    if(response["info"]["isSucces"]){

      Provider.of<User>(context,listen: false).password=newPassword.text;
    }
    Fluttertoast.showToast(
      msg: response["info"]["message"],
      backgroundColor: response["info"]["isSucces"]?Colors.green:Colors.red,
      );
    await loadSharedPref();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ŞİFRE DEĞİŞTİRME'),
        centerTitle: true,
      ),
      backgroundColor: Colors.green,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36.0),
            color: Colors.white,
          ),
          padding: EdgeInsets.only(
            left: 30,
            right: 30,
            top:2,
          ),
          height: 500,
          width: 370,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  PasswordDesign(
                    label: "Mevcut Şifre",
                    ctrl: password,
                  ),
                  isWrong
                  ?Text("Şifre yanlış",style: TextStyle(color: Colors.red))
                  :Text(""),
                  SizedBox(height: 30),
                  PasswordDesign(
                    label: "Yeni Şifre",
                    ctrl: newPassword,
                  ),
                  SizedBox(height: 30),
                  !isLoading
                  ?MaterialButton(
                    onPressed:(){

                        savePassword();


                    } ,
                    child: Text('KAYDET'),
                    color: Colors.amber,
                  ):buildRefreshProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

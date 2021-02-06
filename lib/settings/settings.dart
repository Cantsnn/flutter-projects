import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ileri_donusum/pages/login_page.dart';
import 'package:ileri_donusum/settings/app_settings.dart';
import 'package:ileri_donusum/settings/password_setting.dart';
import 'package:ileri_donusum/settings/person_setting.dart';
import '../useful_widgets.dart';
import '../constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  SharedPreferences isLogIn;
  @override
  void initState() {
    super.initState();
    loadSharedPrefernce();
  }

  void loadSharedPrefernce() async {
    isLogIn = await SharedPreferences.getInstance();
  }

  void checkLogIn() async {
    isLogIn.setBool("isLogin", false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LogInPage();
        },
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Text(
          'AYARLAR',
          style: kMetinStili,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: 600,
          width: 320,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              MyCard(
                icon: Icon(
                  FontAwesomeIcons.addressBook,
                  color: Colors.black87,
                ),
                label: 'Kişisel Bilgiler',
                page: PersonSetting(),
              ),
              SizedBox(
                height: 30,
              ),
              MyCard(
                icon: Icon(
                  FontAwesomeIcons.userLock,
                  color: Colors.black87,
                ),
                label: 'Şifre Değişikliği',
                page: PasswordSetting(),
              ),
              SizedBox(
                height: 30,
              ),
              MyCard(
                icon: Icon(
                  Icons.settings,
                  color: Colors.black87,
                ),
                label: 'Uygulama Ayarları',
                page: AppSettings(),
              ),
              SizedBox(height: 150),
              Container(
                child: ElevatedButton(
                    child: Text("ÇIKIŞ"),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red),),
                    onPressed: () {
                      checkLogIn();
                    },
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

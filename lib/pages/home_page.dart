import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:ff_navigation_bar/ff_navigation_bar_theme.dart';
import 'package:flutter/material.dart';
import 'package:ileri_donusum/classes/User.dart';
import 'package:ileri_donusum/classes/address_model.dart';
import 'package:ileri_donusum/pages/feedback.dart';
import 'package:ileri_donusum/pages/request_history.dart';
import 'package:ileri_donusum/settings/settings.dart';
import 'package:provider/provider.dart';
import '../address/address_list.dart';
import 'first_page.dart';

class HomePage extends StatefulWidget {
  final String password;
  final List<AddressModel> addressList;

  HomePage({
    this.password,
    this.addressList,
  });
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> tabs;
  String url;

  @override
  void initState() {
    super.initState();
    if (widget.addressList != null && widget.addressList.isNotEmpty) {
      Provider.of<User>(context, listen: false).addressList =
          widget.addressList;
    }
    if (widget.password != null) {
      Provider.of<User>(context, listen: false).password = widget.password;
    }
    tabs = <Widget>[
      FirstPage(),
      Addresses(),
      RequestHistory(),
      GeriBildirim(),
      Settings(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs.elementAt(_selectedIndex),
      bottomNavigationBar: FFNavigationBar(
        selectedIndex: _selectedIndex,
        onSelectTab: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: <FFNavigationBarItem>[
          FFNavigationBarItem(
            iconData: Icons.home_outlined,
            label: 'Ana sayfa',
          ),
          FFNavigationBarItem(
            iconData: Icons.edit_location_outlined,
            label: 'Adresler',
          ),
          FFNavigationBarItem(
            iconData: Icons.history_outlined,
            label: 'İstekGeçmişi',
          ),
          FFNavigationBarItem(
            iconData: Icons.feedback_outlined,
            label: 'GeriBildirim',
          ),
          FFNavigationBarItem(
            iconData: Icons.settings,
            label: 'Ayarlar',
          ),
        ],
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.green,
          selectedItemBorderColor: Colors.orange,
          selectedItemBackgroundColor: Colors.green,
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: Colors.black,
          unselectedItemIconColor: Colors.white,
          unselectedItemLabelColor: Colors.white,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ileri_donusum/classes/address_model.dart';
import 'package:ileri_donusum/sendRequest.dart';
import 'package:provider/provider.dart';
import '../classes/User.dart';
import '../constants.dart';
import 'notifications.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<DropdownMenuItem<AddressModel>> _dropdownMenu;
  AddressModel selectedAddress;
  Map<String, dynamic> responseData;
  bool isListEmpty = true;
  @override
  void initState() {
    super.initState();
    if (Provider.of<User>(context, listen: false).addressList.isNotEmpty) {
      isListEmpty = false;
      _dropdownMenu =
          buildropdownd(Provider.of<User>(context, listen: false).addressList);
      selectedAddress = _dropdownMenu[0].value;
    }
  }

  List<DropdownMenuItem<AddressModel>> buildropdownd(
      List<AddressModel> addresList) {
    List<DropdownMenuItem<AddressModel>> items = List();
    for (AddressModel address in addresList) {
      items.add(
        DropdownMenuItem(
          child: Text(address.fullAddress),
          value: address,
        ),
      );
    }
    return items;
  }

  void sendRequest() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(

          title: Text(
            "    İSTEK GÖNDER",
          ),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                Text("Adres seçin :"),
                  !isListEmpty
                      ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                                              child: DropdownButton(
            value: selectedAddress,
            items: _dropdownMenu,
            onChanged: (value) {
              setState(() {
                selectedAddress = value;
              });
            },
                          ),
                      )
                      : Center(child: Text("Adres Listesi Boş")),
                ],
              );
          }),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Iptal",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),
            ),
            FlatButton(
              onPressed: !isListEmpty
                  ? () {
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return SendRequest(
                              selectedAddress: selectedAddress,
                            );
                          },
                        ));
                      });
                    }
                  : null,
              child: Text(
                "Gönder",
                style: TextStyle(
                  fontSize: 20,
                  color: isListEmpty ? Colors.grey : Colors.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Notifications();
                      },
                    ),
                  );
                });
              },
              icon: Icon(
                Icons.notifications,
                size: 30,
                color: Colors.orange[600],
              ),
            ),
          ),
        ],
        title: Text(
          'İLERİ DÖNÜŞÜM',
          style: kMetinStili,
        ),
        centerTitle: true,
      ),
     // backgroundColor: Colors.lightGreenAccent[700],
      body: Column(
          children: <Widget>[
            Expanded(
      flex: 8,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Container(
              child: Center(
                   child: ClipRRect(
                    borderRadius: BorderRadius.circular(70.0),
                        child: Image.asset(
                          'assets/images/maps.png',
                            height: 280.0,
                            width: 400.0,
                        ),
                    )
                ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36.0),
             
            ),
          ),
        ),
      ),
            ),
            Expanded(
      child: ButtonTheme(
        height: 10,
        buttonColor: Colors.white,
        child: FlatButton(
          minWidth: 300,
          onPressed: sendRequest,
          child: Text(
            'GERİ DÖNÜŞÜM İSTEĞİ',
            style: kMetinStili2,
          ),
          color: Colors.green,
        ),
      ),
            ),
            SizedBox(
      height: 100,
            ),
          ],
        ),
    );
  }
}

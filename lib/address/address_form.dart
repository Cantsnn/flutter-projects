import 'package:flutter/material.dart';
import 'package:ileri_donusum/classes/address_model.dart';
import 'package:ileri_donusum/constants.dart';
import 'package:ileri_donusum/useful_widgets.dart';

class AddressForm extends StatefulWidget {
  final AddressModel addedAddress;
  AddressForm({this.addedAddress});
  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  List<TextEditingController> controllerList;

  @override
  void initState() {
    super.initState();
    if (widget.addedAddress != null) {
      controllerList = <TextEditingController>[
        TextEditingController(text: widget.addedAddress.fullAddress),
        TextEditingController(text: widget.addedAddress.district),
        TextEditingController(text: widget.addedAddress.city),
        TextEditingController(text: widget.addedAddress.postCode),
      ];
    } else {
      controllerList = <TextEditingController>[
        for (var i = 0; i < 4; i++) TextEditingController(),
      ];
    }
  }

  saveAdress() {
    for (var i = 0; i < 4; i++) {
      if (controllerList[i].text == "") {
        buildShowToast();
        return;
      }
    }
    Map<String, dynamic> responseData = <String, String>{
      "fullAddress": controllerList[0].text,
      "district": controllerList[1].text,
      "city": controllerList[2].text,
      "postcode": controllerList[3].text,
    };

    Navigator.of(context).pop(responseData);
  }

  editAddress() {
    for (var i = 0; i < 4; i++) {
      if (controllerList[i].text == "") {
        buildShowToast();
        return;
      }
    }
    Map<String, dynamic> responseData = <String, dynamic>{
      "aid": widget.addedAddress.id,
      "fullAddress": controllerList[0].text,
      "district": controllerList[1].text,
      "city": controllerList[2].text,
      "postcode": controllerList[3].text,
    };
    Navigator.of(context).pop(responseData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.addedAddress == null ? "Adres Ekle" : "Adres Düzenle",
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.green,
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36.0),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  buildTextForm(
                    label: "Tam Adres",
                    ctrl: controllerList[0],
                  ),
                  buildTextForm(
                    label: "İlçe",
                    ctrl: controllerList[1],
                  ),
                  buildTextForm(
                    label: "Şehir",
                    ctrl: controllerList[2],
                  ),
                  buildTextForm(
                    label: "Posta Kodu",
                    ctrl: controllerList[3],
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                  MaterialButton(
                    color: Colors.lightGreenAccent[700],
                    minWidth: 240,
                    onPressed:
                        widget.addedAddress == null ? saveAdress : editAddress,
                    child: Text(
                      (widget.addedAddress == null)
                          ? "Ekle"
                          : "Değişikliği Kaydet",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

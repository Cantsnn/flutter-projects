import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ileri_donusum/classes/address_model.dart';
import 'package:ileri_donusum/http_methods.dart';
import 'package:ileri_donusum/useful_widgets.dart';
import 'package:provider/provider.dart';
import 'classes/User.dart';
import 'classes/request.dart';

class SendRequest extends StatefulWidget {
  final AddressModel selectedAddress;
  SendRequest({this.selectedAddress});

  @override
  _SendRequestState createState() => _SendRequestState();
}

class _SendRequestState extends State<SendRequest> {
  Map<String, dynamic> responseData;
  String url;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    url =
        "https://appupcycling.herokuapp.com/api/users/${Provider.of<User>(context, listen: false).id}/requests";
    sendRequest();
  }

  void sendRequest() async {
    responseData = await httpPost(
      url,
      itemBody: json.encode(<String, int>{
        "addressID": widget.selectedAddress.id,
      }),
    );
    if (responseData["info"]["isSucces"]) {
     
      setState(() {
        isLoading=false;
        Provider.of<User>(context, listen: false)
            .addToList(Request.fromJson(responseData["content"]));
      });
      
    }
    else{
      setState(() {
      isLoading=false;
    });
    }
  
  }

  



istekGonder() {
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
                  
                  Center(child: Text("Adres Listesi Boş")),
                
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

            ],
          );
        });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[600],
      body: AlertDialog(
          title: Text(""),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
 

                  Center( 
                    child: 
                    isLoading?
                    buildRefreshProgressIndicator():
                    Text(responseData["info"]["message"]),
                    ),
                
                ],
              );
            }),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            actions: [
              !isLoading
              ?FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Geri",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
              )
              :null,

            ],
          )
    );
  }
}

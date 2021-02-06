import 'package:flutter/material.dart';
import 'package:ileri_donusum/classes/User.dart';
import 'package:ileri_donusum/classes/request.dart';
import 'package:ileri_donusum/constants.dart';
import 'package:ileri_donusum/http_methods.dart';
import 'package:ileri_donusum/useful_widgets.dart';
import 'package:provider/provider.dart';

class RequestHistory extends StatefulWidget {
  @override
  _RequestHistoryState createState() => _RequestHistoryState();
}

class _RequestHistoryState extends State<RequestHistory> {
  List<Request> requestList = List<Request>();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getRequestList();
  }

  void getRequestList() async {
    int userID = Provider.of<User>(context, listen: false).id;
    dynamic response = await httpGet(
      "https://appupcycling.herokuapp.com/api/users/$userID/requests",
    );
    if (response["info"]["isSucces"]) {
     setState(() {
       for (var i = 0; i < response["content"].length; i++) {
        requestList.insert(0, Request.fromJson(response["content"][i]));
      }
       
     }); 

    }
   setState(() {
        isLoading = false;
      });
  }

  String listItemName(index) {
    String fullAddress;
    for (var i = 0;
        i < Provider.of<User>(context, listen: false).addressList.length;
        i++) {
      if (requestList[index].addressId ==
          Provider.of<User>(context, listen: false).addressList[i].id) {
        fullAddress = Provider.of<User>(context, listen: false)
            .addressList[i]
            .fullAddress;
      }
    }
    return fullAddress;
  }

  Icon iconState(int index) {
    int info = requestList[index].stateInfo;
    if (info == 1) {
      return Icon(
        Icons.schedule,
        color: Colors.amber,
      );
    } else if (info == 2) {
      return Icon(
        Icons.check_circle,
        color: Colors.green,
      );
    } else if (info == 3) {
      return Icon(
        Icons.error,
        color: Colors.red,
      );
    } else if (info == 4) {
      return Icon(
        Icons.cloud_done,
        color: Colors.green,
      );
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "İSTEK GEÇMİŞİ",
          style: kMetinStili,
        ),
        centerTitle: true,
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: buildRefreshProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                    Expanded(
                    child: 
                requestList.isNotEmpty
                   ?ListView.separated(
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: iconState(index),
                          title: Text(listItemName(index)),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Colors.black,
                          thickness: 0.8,
                          height: 4,
                        );
                      },
                      itemCount: requestList.length,
                    )
                  :Center(
                    child: 
                      Text("İstek Listeniz Boş"),
                  ),
                  )


                ],
              ),
      ),
    );
  }
}

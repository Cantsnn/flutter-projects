import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ileri_donusum/classes/User.dart';
import 'package:ileri_donusum/constants.dart';
import 'package:ileri_donusum/http_methods.dart';
import 'package:ileri_donusum/useful_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'address_form.dart';
import '../classes/address_model.dart';

class Addresses extends StatefulWidget {
  @override
  _AddressesState createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  bool isLoading = false;
  Map<String, dynamic> responseData;
  String url;
  int userId;
  SharedPreferences sharedPref;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<User>(context, listen: false).id;
    url = "https://appupcycling.herokuapp.com/api/users/$userId/address";
  }

  Future<void> createSharedPref() async {
    sharedPref = await SharedPreferences.getInstance();
  }

  Future<void> saveToSharedPref() async {
    await createSharedPref();
    List<String> stringList = Provider.of<User>(context, listen: false)
        .addressList
        .map((e) => json.encode(e.toJson()))
        .toList();
    sharedPref.setStringList("addressList", stringList);
  }

  void removeFromList(AddressModel item) async {
    print(url + "/${item.id}");
    await httpDelete(url + "/${item.id}").then((value) {
      if (value != null) {
        print(value["info"]["isSucces"]);

        if (value["info"]["isSucces"]) {
          setState(() {
            isLoading = false;
          });
          Provider.of<User>(context, listen: false).removeFromList(item);
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    });
    await saveToSharedPref();
  }

  void addAdress() async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return AddressForm();
      },
    )).then((value) async {
      if (value != null) {
        setState(() {
          isLoading = true;
        });
      }
      httpPost(
        url,
        itemBody: json.encode(value),
      ).then((response) async {
        if (response != null) {
          if (response["info"]["isSucces"]) {
            setState(() {
              isLoading = false;
            });
            Provider.of<User>(context, listen: false)
                .addToList(AddressModel.fromJson(response["content"]));
            await saveToSharedPref();
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }
      });
    });
  }

  void editAdress(int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return AddressForm(
          addedAddress:
              Provider.of<User>(context, listen: false).addressList[index],
        );
      },
    )).then((data) async {
      if (data != null) {
        setState(() {
          isLoading = true;
        });
      }
      httpPut(
        url +
            "/${Provider.of<User>(context, listen: false).addressList[index].id}",
        json.encode(data),
      ).then((value) async {
        if (value != null) {
          if (value["info"]["isSucces"]) {
            setState(() {
              isLoading = false;
            });
            Provider.of<User>(context, listen: false)
                .changeAddressItems(index, AddressModel.fromJson(data));
            await saveToSharedPref();
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ADRESLER",
          style: kMetinStili,
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            Expanded(
              child: !isLoading
                  ? Provider.of<User>(context, listen: false)
                          .addressList
                          .isNotEmpty
                      ? ListView.separated(
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: Key(
                                "${Provider.of<User>(context, listen: false).addressList[index].hashCode}",
                              ),
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Icon(
                                  Icons.delete_sharp,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                color: Colors.red[600],
                              ),
                              onDismissed: (direction) {
                                removeFromList(
                                  Provider.of<User>(context, listen: false)
                                      .addressList[index],
                                );
                                setState(() {
                                  isLoading = true;
                                });
                              },
                              direction: DismissDirection.endToStart,
                              child: ListTile(
                                leading: Icon(Icons.location_on),
                                title: Text(
                                  Provider.of<User>(context, listen: false)
                                      .addressList[index]
                                      .city,
                                ),
                                onLongPress: () {
                                  editAdress(index);
                                },
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Colors.black,
                              thickness: 0.8,
                              height: 4,
                            );
                          },
                          itemCount: Provider.of<User>(context, listen: false)
                              .addressList
                              .length,
                        )
                      : Center(child: Text("Liste Boş"))
                  : Center(child: buildRefreshProgressIndicator()),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: addAdress,
      ),
    );
  }
}

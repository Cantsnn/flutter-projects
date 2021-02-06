import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class GeriBildirim extends StatefulWidget {
  @override
  _GeriBildirimState createState() => _GeriBildirimState();
}

class _GeriBildirimState extends State<GeriBildirim> {
  String dropdownValue = 'Öneri';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GERİ BİLDİRİM',
          style: kMetinStili,
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Konu başlığı giriniz :',
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Mesajınızı giriniz',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            // When the child is tapped, show a snackbar.
            onTap: () {
              final snackBar = SnackBar(
                  content: Text(
                "Gönderildi",
              ));

              Scaffold.of(context).showSnackBar(snackBar);
            },
            // The custom button
            child: Container(
              height: 50,
              width: 100,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Text(
                  'GÖNDER',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

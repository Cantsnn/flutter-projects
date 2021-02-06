import 'package:flutter/material.dart';

import '../constants.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        centerTitle: true,
        title: Text(
          'BİLDİRİMLER',
          style: kMetinStili,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Container buildTextForm(
    {String label, TextEditingController ctrl, Icon itemIcon}) {
  return Container(
    padding: EdgeInsets.all(5.0),
    child: TextFormField(
      decoration: InputDecoration(
        prefixIcon: itemIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.black,
        ),
      ),
      controller: ctrl,
    ),
  );
}

class PasswordDesign extends StatefulWidget {
  final TextEditingController ctrl;
  final String label;
  PasswordDesign({
    this.ctrl,
    this.label,
  });
  @override
  _PasswordDesignState createState() => _PasswordDesignState();
}

class _PasswordDesignState extends State<PasswordDesign> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: TextFormField(
        controller: widget.ctrl,
        obscureText: passwordVisible ? false : true,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.vpn_key,
            color: Colors.black87,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.black87,
            ),
            onPressed: () {
              setState(() {
                passwordVisible
                    ? passwordVisible = false
                    : passwordVisible = true;
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: widget.label,
          labelStyle: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class GenderSelector extends StatelessWidget {
  final Color color;
  final Widget child;
  final Function onPress;
  GenderSelector({
    this.color = Colors.white,
    this.child,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: child,
        margin: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: color,
        ),
      ),
    );
  }
}

class GenderIcon extends StatelessWidget {
  final String genderName;
  final IconData icon;
  GenderIcon({
    this.genderName,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 42,
          color: Colors.black54,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          genderName,
          //style: kMetinStili,
        )
      ],
    );
  }
}

class MyCard extends StatelessWidget {
  final Icon icon;
  final String label;
  final Widget page;
  const MyCard({
    this.icon,
    this.label,
    this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ButtonTheme(
        
        child: ListTile(
        tileColor: Colors.grey[300],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return page;
                },
              ),
            );
          },
          leading: icon,
          title: Text(
            label,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

RefreshProgressIndicator buildRefreshProgressIndicator() {
  return RefreshProgressIndicator(
    strokeWidth: 5,
    backgroundColor: Colors.blue,
    valueColor: AlwaysStoppedAnimation(
      Colors.amber,
    ),
  );
}


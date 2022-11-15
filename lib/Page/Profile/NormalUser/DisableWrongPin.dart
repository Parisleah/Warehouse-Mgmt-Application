import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_mnmt/Page/Model/Profile.dart';

// Components

// Models
import 'package:warehouse_mnmt/Page/Model/Shop.dart';
import 'package:warehouse_mnmt/Page/Profile/1_addShopName.dart';
import 'package:warehouse_mnmt/Page/Provider/theme_provider.dart';
import 'package:warehouse_mnmt/db/database.dart';
import 'package:warehouse_mnmt/main.dart';



class DisableWrongPinPage extends StatefulWidget {
  final Profile profile;
  const DisableWrongPinPage({
    required this.profile,
    Key? key,
  }) : super(key: key);

  @override
  State<DisableWrongPinPage> createState() => _DisableWrongPinPageState();
}

class _DisableWrongPinPageState extends State<DisableWrongPinPage> {
  bool isLoading = false;
  List<Shop> shops = [];
  Profile? profile;

  @override
  void initState() {
    profile = widget.profile;
    super.initState();

  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            title: new Text('คุณแน่ใจ ?'),
            content: new Text('ต้องการออกจากแอปพลิเคชัน'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: Text(
                  'ไม่',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // <-- SEE HERE
                child: Text('ออก', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: (MediaQuery.of(context).size.height),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              // ignore: prefer_const_literals_to_create_immutables
              colors: [
                Color.fromRGBO(29, 29, 65, 1.0),
                Color.fromRGBO(31, 31, 31, 1.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                     
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

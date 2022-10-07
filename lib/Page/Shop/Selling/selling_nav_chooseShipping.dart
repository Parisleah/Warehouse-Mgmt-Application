import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class selling_nav_chooseShipping extends StatefulWidget {
  const selling_nav_chooseShipping({Key? key}) : super(key: key);

  @override
  State<selling_nav_chooseShipping> createState() =>
      _selling_nav_chooseShippingState();
}

class _selling_nav_chooseShippingState
    extends State<selling_nav_chooseShipping> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        title: Column(
          children: [
            Text(
              "เลือกการจัดส่ง",
              style: TextStyle(fontSize: 25),
            )
          ],
        ),
        centerTitle: true,
        actions: [],
        backgroundColor: Color.fromRGBO(30, 30, 65, 1.0),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color.fromRGBO(29, 29, 65, 1.0),
            Color.fromRGBO(31, 31, 31, 1.0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Column(children: [
          SizedBox(height: 80),

          // Choose Customer Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(56, 54, 76, 1.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            onPressed: () {},
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: const Text("Flash Express",
                    style: TextStyle(fontSize: 15, color: Colors.white)),
              ),
              Spacer(),
            ]),
          ),
          // Choose Customer Button
        ]),
      ),
    );
  }
}
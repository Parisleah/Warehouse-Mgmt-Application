import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

// Components
import 'package:warehouse_mnmt/Page/Component/searchBox.dart';
// Page
import 'package:warehouse_mnmt/Page/Shop/Selling/selling_nav_createCustomer.dart';

class selling_nav_chooseCustomer extends StatefulWidget {
  const selling_nav_chooseCustomer({Key? key}) : super(key: key);

  @override
  State<selling_nav_chooseCustomer> createState() =>
      _selling_nav_chooseCustomerState();
}

class _selling_nav_chooseCustomerState
    extends State<selling_nav_chooseCustomer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
          title: Column(
            children: [
              Text(
                "เลือกลูกค้า",
                style: TextStyle(fontSize: 25),
              )
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => selling_nav_createCustomer()));
              },
              icon: Icon(Icons.add),
            )
          ],
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Baseline(
              child: SearchBox("ชื่อลูกค้า หรือ เบอร์โทรศัพท์"),
              baselineType: TextBaseline.alphabetic,
              baseline: 90,
            ),
          ),
          backgroundColor: Color.fromRGBO(30, 30, 65, 1.0),
        ),
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
          SizedBox(height: 150),

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
                child: const Text("พิสิษฐ์ จันทวี",
                    style: TextStyle(fontSize: 15, color: Colors.white)),
              ),
              Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              )
            ]),
          ),
          // Choose Customer Button
        ]),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:warehouse_mnmt/Page/Component/theme/theme.dart';

import '../Component/searchBox.dart';

class BuyingPage extends StatefulWidget {
  const BuyingPage({Key? key}) : super(key: key);

  @override
  State<BuyingPage> createState() => _BuyingPageState();
}

class _BuyingPageState extends State<BuyingPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(180),
          child: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            title: const Text(
              "สั่งซื้อสินค้า",
              textAlign: TextAlign.start,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     new MaterialPageRoute(
                  //         builder: (context) => sellingNavAdd()));
                },
                icon: const Icon(
                  Icons.add,
                  size: 30,
                ),
              )
            ],
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Baseline(
                  baseline: 110,
                  baselineType: TextBaseline.alphabetic,
                  child: SearchBox("ชื่อร้าน หรือ เบอร์โทรศัพท์ร้าน")),
            ),
            bottom: TabBar(tabs: [
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    // color: Color.fromRGBO(56, 54, 76, 1.0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(" ทั้งหมด "),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    // color: Color.fromRGBO(56, 54, 76, 1.0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("วันนี้"),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    // color: Color.fromRGBO(56, 54, 76, 1.0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Align(
                      alignment: Alignment.center, child: Text("สัปดาห ์")),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    // color: Color.fromRGBO(56, 54, 76, 1.0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("เดือน "),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    // color: Color.fromRGBO(56, 54, 76, 1.0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("ระบุวัน"),
                  ),
                ),
              ),
            ]),
          ),
        ),
        body: Container(
          // decoration: BoxDecoration(
          //     gradient: scafBG_dark_Color),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 200,
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                        child: Text(
                      "(พื้นที่วาง Widget)",
                      style: TextStyle(color: Colors.grey, fontSize: 30),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

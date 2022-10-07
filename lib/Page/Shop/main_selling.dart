import 'package:flutter/material.dart';
import 'package:warehouse_mnmt/Page/Component/SearchBox.dart';
// Component
import 'package:warehouse_mnmt/Page/Component/theme/theme.dart';

import '../Component/SearchBoxController.dart';
import 'Selling/nav_add.dart';

class SellingPage extends StatefulWidget {
  const SellingPage({Key? key}) : super(key: key);

  @override
  State<SellingPage> createState() => _SellingPageState();
}

class _SellingPageState extends State<SellingPage> {
  bool isTapSelect = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(180),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              "ขายสินค้า",
              textAlign: TextAlign.start,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => SellingNavAdd()));
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
                  child: SearchBox("ชื่อลูกค้า หรือ เบอร์โทรศัพท์")),
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
          decoration: BoxDecoration(gradient: scafBG_dark_Color),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 200,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Container(
                //       width: 280,
                //       decoration: BoxDecoration(
                //           color: Color.fromRGBO(35, 30, 60, 1.0),
                //           borderRadius: BorderRadius.circular(20)),
                //       child: Padding(
                //         padding: const EdgeInsets.all(2.0),
                //         child: Row(
                //             mainAxisAlignment: MainAxisAlignment.start,
                //             children: [
                //               Padding(
                //                 padding: const EdgeInsets.all(2.0),
                //                 child: ElevatedButton(
                //                   child: Text("?"),
                //                   onPressed: () {},
                //                 ),
                //               ),
                //             ]),
                //       ),
                //     ),
                //     Spacer(),
                //     ElevatedButton(
                //       style: !isTapSelect == true
                //           ? ElevatedButton.styleFrom(
                //               primary: Theme.of(context).colorScheme.background)
                //           : ElevatedButton.styleFrom(primary: Colors.red),
                //       child: Row(children: [
                //         Icon(Icons.select_all),
                //         SizedBox(
                //           width: 5,
                //         ),
                //         !isTapSelect == true ? Text("ยกเลิก") : Text("เลือก")
                //       ]),
                //       onPressed: () {
                //         setState(() {
                //           isTapSelect = !isTapSelect;
                //         });
                //       },
                //     )
                //   ],
                // ),
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

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_mnmt/Page/Model/Dealer.dart';

import '../../../db/database.dart';
import 'nav_create_dealer.dart';

class BuyingNavChooseDealer extends StatefulWidget {
  final ValueChanged<DealerModel> update;

  const BuyingNavChooseDealer({required this.update, Key? key})
      : super(key: key);
  @override
  State<BuyingNavChooseDealer> createState() => _buying_nav_chooseDealerState();
}

class _buying_nav_chooseDealerState extends State<BuyingNavChooseDealer> {
  @override
  void initState() {
    super.initState();
    refreshDealer();
  }

  @override
  List<DealerModel> dealers = [];
  Future refreshDealer() async {
    dealers = await DatabaseManager.instance.readAllDealers();
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        title: Column(
          children: [
            Text(
              "เลือกตัวแทนจำหน่าย",
              style: TextStyle(fontSize: 25),
            )
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => BuyingNavCreateDealer()));
              refreshDealer();
            },
            icon: Icon(Icons.add),
          )
        ],
        backgroundColor: Color.fromRGBO(30, 30, 65, 1.0),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: (MediaQuery.of(context).size.height),
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
            const SizedBox(height: 90),
            dealers.isEmpty
                ? Container(
                    width: 440,
                    height: 560,
                    child: Center(
                        child: Text(
                      'ไม่มีตัวแทนจำหน่าย',
                      style: TextStyle(color: Colors.grey, fontSize: 25),
                    )),
                  )
                : Container(
                    width: 440,
                    height: 560,
                    child: RefreshIndicator(
                      onRefresh: refreshDealer,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: dealers.length,
                          itemBuilder: (context, index) {
                            final dealer = dealers[index];
                            return Dismissible(
                              background: Container(
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(
                                      Icons.delete_forever,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              resizeDuration: Duration(seconds: 1),
                              key: Key(dealers[index].dName),
                              onDismissed: (direction) async {
                                await DatabaseManager.instance
                                    .deleteDealer(dealer.dealerId!);
                                refreshDealer();
                                setState(() {});
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.redAccent,
                                  content:
                                      Text("ลบตัวแทนจำหน่าย ${dealer.dName}"),
                                  duration: Duration(seconds: 2),
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary:
                                          const Color.fromRGBO(56, 54, 76, 1.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    widget.update(dealer);
                                  },
                                  child: Row(children: [
                                    Icon(Icons.person_pin_circle),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(dealer.dName,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          Wrap(children: [
                                            Text('ที่อยู่ ${dealer.dAddress}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white)),
                                          ]),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                  ]),
                                ),
                              ),
                            );
                            // Choose Customer Button;
                          }),
                    ),
                  ),
          ]),
        ),
      ),
    );
  }
}

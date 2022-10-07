import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warehouse_mnmt/Page/Component/theme/theme.dart';
import 'package:warehouse_mnmt/Page/Model/Dealer.dart';
import 'package:warehouse_mnmt/Page/Model/Purchasing.dart';
import 'package:warehouse_mnmt/Page/Model/Shop.dart';
import 'package:warehouse_mnmt/Page/Shop/Buying/nav_add.dart';

import '../../db/database.dart';
import '../Component/SearchBox.dart';
import '../Component/SearchBoxController.dart';

class BuyingPage extends StatefulWidget {
  final Shop shop;
  const BuyingPage({required this.shop, Key? key}) : super(key: key);

  @override
  State<BuyingPage> createState() => _BuyingPageState();
}

class _BuyingPageState extends State<BuyingPage> {
  TextEditingController searchProductController = TextEditingController();
  List<PurchasingModel> purchasings = [];
  List<DealerModel> dealers = [];
  final df = new DateFormat('dd-MM-yyyy hh:mm a');
  @override
  void initState() {
    super.initState();
    refreshPurchasings();

    searchProductController.addListener(() => setState(() {}));
  }

  Future refreshPurchasings() async {
    purchasings =
        await DatabaseManager.instance.readAllPurchasings(widget.shop.shopid!);
    dealers = await DatabaseManager.instance.readAllDealers();
    setState(() {});
  }

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
            toolbarHeight: 70,
            title: const Text(
              "สั่งซื้อสินค้า",
              textAlign: TextAlign.start,
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  await Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => BuyingNavAdd(
                                shop: widget.shop,
                              )));
                  refreshPurchasings();
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
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(gradient: scafBG_dark_Color),
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
                  Container(
                    decoration: BoxDecoration(
                      // color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        purchasings.isEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                  // color:
                                  //     Theme.of(context).colorScheme.background,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.65,
                                child: Center(
                                    child: Text(
                                  'ไม่มีการสั่งซื้อ',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 25),
                                )),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  height: 480.0,
                                  width: 440.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    // color: Color.fromRGBO(37, 35, 53, 1.0),
                                  ),
                                  child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: purchasings.length,
                                      itemBuilder: (context, index) {
                                        final purchasing = purchasings[index];
                                        var _dealer;

                                        for (var dealer in dealers) {
                                          if (dealer.dealerId ==
                                              purchasing.dealerId) {
                                            _dealer = dealer;
                                          }
                                        }
                                        return Dismissible(
                                          key: UniqueKey(),
                                          direction:
                                              DismissDirection.endToStart,
                                          resizeDuration: Duration(seconds: 1),
                                          background: Container(
                                            margin: EdgeInsets.only(
                                                left: 0,
                                                top: 10,
                                                right: 10,
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
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
                                          onDismissed: (direction) async {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Colors.redAccent,
                                              content: Container(
                                                  child: Row(
                                                children: [
                                                  Text(
                                                      "ลบรายการสั่งซื้อ ${_dealer.dName}"),
                                                  Text(
                                                      ' ยอด ${NumberFormat("#,###.##").format(purchasing.total)}',
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12)),
                                                ],
                                              )),
                                              duration: Duration(seconds: 5),
                                            ));
                                            await DatabaseManager.instance
                                                .deletePurchasing(
                                                    purchasing.purId!);
                                            refreshPurchasings();
                                            setState(() {});
                                          },
                                          child: TextButton(
                                            onPressed: () {
                                              // Navigator.of(context).push(
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             buyingNavEdit(
                                              //                 dealer: dealer)));
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 0.0,
                                                  horizontal: 0.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Container(
                                                  height: 80,
                                                  width: 400,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        width: 80,
                                                        height: 80,
                                                        child: Icon(
                                                          Icons.person,
                                                          color: Colors.white,
                                                          size: 40,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              '${_dealer.dName}',
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .phone_in_talk,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 14,
                                                                ),
                                                                Text(
                                                                  ' ${_dealer.dPhone}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                              ],
                                                            ),
                                                            Center(
                                                              child: Text(
                                                                  '${df.format(purchasing.orderedDate)}',
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          12)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            purchasing.isReceive ==
                                                                    true
                                                                ? Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    color: Colors
                                                                        .greenAccent,
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .circle_outlined,
                                                                    color: Colors
                                                                        .greenAccent,
                                                                  ),
                                                            Text(
                                                              '${NumberFormat("#,###.##").format(purchasing.total)} ฿',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .greenAccent,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

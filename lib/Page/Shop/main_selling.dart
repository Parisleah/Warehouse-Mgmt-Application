import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warehouse_mnmt/Page/Component/SearchBox.dart';
// Component

import 'package:warehouse_mnmt/Page/Model/Customer.dart';
import 'package:warehouse_mnmt/Page/Model/CustomerAdress.dart';
import 'package:warehouse_mnmt/Page/Model/Selling.dart';
import 'package:warehouse_mnmt/Page/Model/Selling_item.dart';
import 'package:warehouse_mnmt/Page/Provider/theme_provider.dart';
import 'package:warehouse_mnmt/Page/Shop/Selling/nav_edit.dart';

import '../../db/database.dart';
import '../Component/SearchBoxController.dart';
import '../Model/Shop.dart';
import 'Selling/nav_add.dart';

class SellingPage extends StatefulWidget {
  final Shop shop;
  const SellingPage({required this.shop, Key? key}) : super(key: key);

  @override
  State<SellingPage> createState() => _SellingPageState();
}

class _SellingPageState extends State<SellingPage> {
  bool isTapSelect = true;
  List<SellingModel> selllings = [];
  List<SellingItemModel> selllingItems = [];
  List<CustomerModel> customers = [];
  List<CustomerAddressModel> addresses = [];
  @override
  void initState() {
    super.initState();
    refreshSellings();
  }

  Future refreshSellings() async {
    selllings =
        await DatabaseManager.instance.readAllSellings(widget.shop.shopid!);
    addresses = await DatabaseManager.instance
        .readCustomerAllAddress(widget.shop.shopid!);
    customers = await DatabaseManager.instance
        .readAllCustomerInShop(widget.shop.shopid!);

    setState(() {});
  }

  final df = new DateFormat('dd-MM-yyyy hh:mm a');
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
                onPressed: () async {
                  await Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => SellingNavAdd(
                                shop: widget.shop,
                              )));
                  refreshSellings();
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
            bottom: TabBar(
                onTap: (value) {
                  setState(() {
                    // if (value == 0) {
                    //   refreshPurchasings();
                    // } else if (value == 1) {
                    //   refreshPurchasingsWHEREisReceived();
                    // } else {
                    //   refreshPurchasingsWHEREisNotReceived();
                    // }
                  });
                },
                tabs: [
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
                        child: Text(" รับสินค้าแล้ว "),
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
                        child: Text("ไม่ได้รับสินค้า"),
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
                        selllings.isEmpty
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
                                  '(ไม่มีการขายสินค้า)',
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
                                  child: RefreshIndicator(
                                    onRefresh: refreshSellings,
                                    child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: selllings.length,
                                        itemBuilder: (context, index) {
                                          final selling = selllings[index];
                                          var _customerText;
                                          var _phoneText;
                                          var _addressText;

                                          for (var customer in customers) {
                                            if (customer.cusId ==
                                                selling.customerId) {
                                              _customerText = customer;
                                            }
                                          }
                                          for (var address in addresses) {
                                            if (address.cAddreId ==
                                                selling.cAddreId) {
                                              _phoneText = address;
                                              _addressText = address;
                                            }
                                          }

                                          return Dismissible(
                                            key: UniqueKey(),
                                            direction:
                                                DismissDirection.endToStart,
                                            resizeDuration:
                                                Duration(seconds: 1),
                                            background: Container(
                                              margin: EdgeInsets.only(
                                                  left: 0,
                                                  top: 10,
                                                  right: 10,
                                                  bottom: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
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
                                                backgroundColor:
                                                    Colors.redAccent,
                                                content: Container(
                                                    child: Row(
                                                  children: [
                                                    Text(
                                                        "ลบรายการสั่งซื้อ {_customer.cName}"),
                                                    Text(
                                                        ' ยอด ${NumberFormat("#,###.##").format(selling.total)}',
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12)),
                                                  ],
                                                )),
                                                duration: Duration(seconds: 5),
                                              ));
                                              selllingItems = await DatabaseManager
                                                  .instance
                                                  .readAllSellingItemsWhereSellID(
                                                      selling.selId!);

                                              await DatabaseManager.instance
                                                  .deleteSelling(
                                                      selling.selId!);

                                              for (var sellingItem
                                                  in selllingItems) {
                                                await DatabaseManager.instance
                                                    .deleteSellingItem(
                                                        sellingItem.selItemId!);
                                              }

                                              refreshSellings();
                                              setState(() {});
                                            },
                                            child: TextButton(
                                              onPressed: () async {
                                                await Navigator
                                                        .of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            SellingNavEdit(
                                                                customer:
                                                                    _customerText,
                                                                customerAddress:
                                                                    _addressText,
                                                                shop:
                                                                    widget.shop,
                                                                selling:
                                                                    selling)));
                                                refreshSellings();
                                                setState(() {});
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0.0,
                                                    horizontal: 0.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
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
                                                                _customerText
                                                                    .cName,
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
                                                                    _phoneText
                                                                        .cPhone,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                ],
                                                              ),
                                                              Text(
                                                                _addressText
                                                                    .cAddress,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              Center(
                                                                child: Text(
                                                                    '${df.format(selling.orderedDate)}',
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
                                                              selling.isDelivered ==
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
                                                                '${NumberFormat("#,###.##").format(selling.total)} ฿',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
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

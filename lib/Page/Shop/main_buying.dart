import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';

import 'package:warehouse_mnmt/Page/Model/Dealer.dart';
import 'package:warehouse_mnmt/Page/Model/Purchasing.dart';
import 'package:warehouse_mnmt/Page/Model/Purchasing_item.dart';
import 'package:warehouse_mnmt/Page/Model/Shop.dart';
import 'package:warehouse_mnmt/Page/Provider/theme_provider.dart';
import 'package:warehouse_mnmt/Page/Shop/Buying/nav_add.dart';
import 'package:warehouse_mnmt/Page/Shop/Buying/nav_edit.dart';

import '../../db/database.dart';
import '../Component/SearchBox.dart';
import '../Component/SearchBoxController.dart';
import '../Model/ProductLot.dart';

class BuyingPage extends StatefulWidget {
  final Shop shop;
  const BuyingPage({required this.shop, Key? key}) : super(key: key);

  @override
  State<BuyingPage> createState() => _BuyingPageState();
}

class _BuyingPageState extends State<BuyingPage> {
  TextEditingController searchDealerController = new TextEditingController();
  List<PurchasingModel> selectedPurchasing = [];
  List<PurchasingModel> purchasings = [];
  List<DealerModel> dealers = [];
  List<ProductLot> productLots = [];

  final df = new DateFormat('dd-MM-yyyy hh:mm a');
  @override
  void initState() {
    super.initState();
    refreshPurchasings();

    searchDealerController.addListener(() => setState(() {}));
  }

  Future refreshPurchasings() async {
    purchasings =
        await DatabaseManager.instance.readAllPurchasings(widget.shop.shopid!);
    dealers = await DatabaseManager.instance.readAllDealers();
    productLots = await DatabaseManager.instance.readAllProductLots();

    setState(() {});
  }

  Future refreshPurchasingsWHEREisReceived() async {
    purchasings = await DatabaseManager.instance
        .readAllPurchasingsWHEREisReceived(widget.shop.shopid!);
    dealers = await DatabaseManager.instance.readAllDealers();
    productLots = await DatabaseManager.instance.readAllProductLots();
    setState(() {});
  }

  Future refreshPurchasingsWHEREisNotReceived() async {
    purchasings = await DatabaseManager.instance
        .readAllPurchasingsWHEREisNotReceived(widget.shop.shopid!);
    dealers = await DatabaseManager.instance.readAllDealers();
    productLots = await DatabaseManager.instance.readAllProductLots();
    setState(() {});
  }

  Future searchDealerByName() async {
    purchasings = await DatabaseManager.instance.readAllPurchasingsByDealerName(
        widget.shop.shopid!, searchDealerController.text);

    setState(() {});
  }

  bool isSelectedPurchasing = false;
  //sellling Page

  List<Widget> buyingIndicators(purchasingItemsLength) {
    return List<Widget>.generate(purchasingItemsLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color:
                // currentIndex == index
                //     ? Theme.of(context).backgroundColor
                //     :
                Colors.black26,
            shape: BoxShape.circle),
      );
    });
  }

  Future<void> dialogConfirmDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, dialogSetState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            title: Row(
              children: [
                const Text(
                  'ต้องการลบ ?',
                  style: TextStyle(color: Colors.white),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.grey,
                    ))
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                child: const Text('ลบ'),
                onPressed: () async {
                  List<PurchasingItemsModel> purchasingItems = [];
                  for (var pur in selectedPurchasing) {
                    purchasingItems = await DatabaseManager.instance
                        .readAllPurchasingItemsWherePurID(pur.purId!);
                    if (pur.isReceive == true) {
                      print(pur.isReceive);
                      for (var item in purchasingItems) {
                        for (var lot in productLots) {
                          if (item.purId == lot.purId) {
                            final updatedLot = lot.copy(
                                remainAmount: lot.remainAmount - item.amount);
                            await DatabaseManager.instance
                                .updateProductLot(updatedLot);
                          }
                        }
                        await DatabaseManager.instance
                            .deletePurchasingItem(item.purItemsId!);
                      }
                    } else {
                      print('else Purchjasing');
                      for (var item in purchasingItems) {
                        await DatabaseManager.instance
                            .deletePurchasingItem(item.purItemsId!);
                      }
                    }
                    await DatabaseManager.instance.deletePurchasing(pur.purId!);
                  }

                  dialogSetState(() {});
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

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
                  child: Column(
                    children: [
                      TextFormField(
                          keyboardType: TextInputType.text,
                          onChanged: (text) {
                            searchDealerByName();
                            setState(() {});
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100),
                          ],
                          controller: searchDealerController,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                          decoration: InputDecoration(
                            // labelText: title,
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.background,
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                                borderSide: BorderSide.none),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                            hintText: 'ชื่อตัวแทนจำหน่าย หรือ เบอร์โทรศัพท์',
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.white),
                            suffixIcon: searchDealerController.text.isEmpty
                                ? Container(
                                    width: 0,
                                  )
                                : IconButton(
                                    onPressed: () {
                                      searchDealerController.clear();
                                      refreshPurchasings();
                                    },
                                    icon: const Icon(
                                      Icons.close_sharp,
                                      color: Colors.white,
                                    ),
                                  ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )),
            ),
            bottom: TabBar(
                onTap: (value) {
                  setState(() {
                    if (value == 0) {
                      refreshPurchasings();
                    } else if (value == 1) {
                      refreshPurchasingsWHEREisReceived();
                    } else {
                      refreshPurchasingsWHEREisNotReceived();
                    }
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
                  purchasings.isEmpty
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            isSelectedPurchasing
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: isSelectedPurchasing
                                            ? Colors.redAccent
                                            : Theme.of(context)
                                                .backgroundColor),
                                    onPressed: () {
                                      setState(() {
                                        isSelectedPurchasing =
                                            !isSelectedPurchasing;
                                        selectedPurchasing.clear();
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.select_all_rounded),
                                        Text('ยกเลิก')
                                      ],
                                    ))
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: isSelectedPurchasing
                                            ? Colors.redAccent
                                            : Theme.of(context)
                                                .backgroundColor),
                                    onPressed: () {
                                      setState(() {
                                        isSelectedPurchasing =
                                            !isSelectedPurchasing;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.select_all_rounded),
                                        Text('เลือก')
                                      ],
                                    ))
                          ],
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
                                  '(ไม่มีการสั่งซื้อ)',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 25),
                                )),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  height: 480.0,
                                  width: 400.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    // color: Color.fromRGBO(37, 35, 53, 1.0),
                                  ),
                                  child: RefreshIndicator(
                                    onRefresh: refreshPurchasings,
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
                                          final isSelectedItem =
                                              selectedPurchasing
                                                  .contains(purchasing);
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
                                              List<PurchasingItemsModel>
                                                  purchasingItems = [];
                                              if (purchasing.isReceive ==
                                                  true) {
                                                print(purchasing.isReceive);
                                                for (var item
                                                    in purchasingItems) {
                                                  purchasingItems =
                                                      await DatabaseManager
                                                          .instance
                                                          .readAllPurchasingItemsWherePurID(
                                                              purchasing
                                                                  .purId!);
                                                  for (var lot in productLots) {
                                                    if (item.purId ==
                                                        lot.purId) {
                                                      final updatedLot = lot.copy(
                                                          remainAmount:
                                                              lot.remainAmount -
                                                                  item.amount);
                                                      await DatabaseManager
                                                          .instance
                                                          .updateProductLot(
                                                              updatedLot);
                                                    }
                                                  }
                                                  await DatabaseManager.instance
                                                      .deletePurchasingItem(
                                                          item.purItemsId!);
                                                }
                                              } else {
                                                print('else Purchjasing');
                                                for (var item
                                                    in purchasingItems) {
                                                  await DatabaseManager.instance
                                                      .deletePurchasingItem(
                                                          item.purItemsId!);
                                                }
                                              }
                                              await DatabaseManager.instance
                                                  .deletePurchasing(
                                                      purchasing.purId!);

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
                                              refreshPurchasings();
                                              setState(() {});
                                            },
                                            child: TextButton(
                                              onPressed: () async {
                                                await Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(
                                                        builder: (context) =>
                                                            BuyingNavEdit(
                                                              shop: widget.shop,
                                                              dealer: _dealer,
                                                              purchasing:
                                                                  purchasing,
                                                            )));
                                                refreshPurchasings();
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
                                                          child: isSelectedPurchasing
                                                              ? IconButton(
                                                                  onPressed: () {
                                                                    if (isSelectedItem ==
                                                                        false) {
                                                                      selectedPurchasing
                                                                          .add(
                                                                              purchasing);
                                                                      showModalBottomSheet(
                                                                          elevation:
                                                                              0,
                                                                          backgroundColor: Colors
                                                                              .transparent,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return Container(
                                                                              width: 370,
                                                                              height: 250,
                                                                              decoration: BoxDecoration(gradient: scafBG_dark_Color, borderRadius: new BorderRadius.only(topLeft: const Radius.circular(30.0), topRight: const Radius.circular(30.0))),
                                                                              child: Wrap(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 20, right: 20),
                                                                                    child: Container(
                                                                                      width: 390,
                                                                                      height: 90,
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Text(
                                                                                            'รายการสั่งซื้อสินค้า \n(${selectedPurchasing.length})',
                                                                                            style: TextStyle(fontSize: 20),
                                                                                          ),
                                                                                          const Spacer(),
                                                                                          ElevatedButton(
                                                                                              style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                                                                                              onPressed: () async {
                                                                                                await dialogConfirmDelete();
                                                                                                selectedPurchasing.clear();
                                                                                                refreshPurchasings();
                                                                                              },
                                                                                              child: Icon(
                                                                                                Icons.delete_rounded,
                                                                                              )),
                                                                                          SizedBox(
                                                                                            width: 10,
                                                                                          ),
                                                                                          ElevatedButton(
                                                                                              onPressed: () async {
                                                                                                List<PurchasingItemsModel> purchasingItems = [];
                                                                                                for (var pur in selectedPurchasing) {
                                                                                                  if (pur.isReceive != true) {
                                                                                                    purchasingItems = await DatabaseManager.instance.readAllPurchasingItemsWherePurID(pur.purId!);
                                                                                                    for (var item in purchasingItems) {
                                                                                                      for (var lot in productLots) {
                                                                                                        if (item.purId == lot.purId) {
                                                                                                          final updatedLot = lot.copy(isReceived: true, remainAmount: int.parse('${lot.amount}'));
                                                                                                          await DatabaseManager.instance.updateProductLot(updatedLot);
                                                                                                        }
                                                                                                      }
                                                                                                    }
                                                                                                    final updatedPur = pur.copy(isReceive: true);
                                                                                                    await DatabaseManager.instance.updatePurchasing(updatedPur);
                                                                                                  }
                                                                                                }
                                                                                                setState(() {});
                                                                                                refreshPurchasings();
                                                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                                  backgroundColor: Theme.of(context).backgroundColor,
                                                                                                  behavior: SnackBarBehavior.floating,
                                                                                                  content: Row(
                                                                                                    children: [
                                                                                                      Text("ปรับปรุงสินค้าคงเหลือแล้ว"),
                                                                                                    ],
                                                                                                  ),
                                                                                                  duration: Duration(seconds: 5),
                                                                                                ));
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                              child: Row(
                                                                                                children: [
                                                                                                  Text('รับสินค้าแล้ว'),
                                                                                                  Icon(
                                                                                                    Icons.check_circle,
                                                                                                    color: Colors.greenAccent,
                                                                                                    size: 15,
                                                                                                  )
                                                                                                ],
                                                                                              ))
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Column(
                                                                                    children: [
                                                                                      Container(
                                                                                        width: 390,
                                                                                        height: 90,
                                                                                        child: ListView.builder(
                                                                                            scrollDirection: Axis.horizontal,
                                                                                            // padding: const EdgeInsets.all(8),

                                                                                            itemCount: selectedPurchasing.length,
                                                                                            itemBuilder: (BuildContext context, int index) {
                                                                                              final indItem = selectedPurchasing[index];

                                                                                              // ??????asdsd
                                                                                              return Padding(
                                                                                                padding: const EdgeInsets.all(3),
                                                                                                child: ClipRRect(
                                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                                  child: Container(
                                                                                                    height: 30,
                                                                                                    color: Theme.of(context).colorScheme.primary,
                                                                                                    child: Padding(
                                                                                                      padding: const EdgeInsets.all(10.0),
                                                                                                      child: Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: [
                                                                                                          IconButton(
                                                                                                              onPressed: () {
                                                                                                                selectedPurchasing.remove(indItem);
                                                                                                                Navigator.pop(context);
                                                                                                                setState(() {});
                                                                                                              },
                                                                                                              icon: Icon(
                                                                                                                Icons.check_box_rounded,
                                                                                                                color: Theme.of(context).backgroundColor,
                                                                                                              )),
                                                                                                          Text(
                                                                                                            '${_dealer.dName}',
                                                                                                            style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                                                                                                          ),
                                                                                                          Row(
                                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                                            children: [
                                                                                                              indItem.isReceive == true
                                                                                                                  ? Icon(
                                                                                                                      Icons.check_circle,
                                                                                                                      color: Colors.greenAccent,
                                                                                                                      size: 15,
                                                                                                                    )
                                                                                                                  : Icon(
                                                                                                                      Icons.circle_outlined,
                                                                                                                      color: Colors.greenAccent,
                                                                                                                      size: 15,
                                                                                                                    ),
                                                                                                              Text(
                                                                                                                '${NumberFormat("#,###.##").format(indItem.total)} ฿',
                                                                                                                style: TextStyle(fontSize: 11, color: Colors.greenAccent, fontWeight: FontWeight.bold),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              );
                                                                                            }),
                                                                                      ),
                                                                                      Row(mainAxisAlignment: MainAxisAlignment.center, children: buyingIndicators(selectedPurchasing.length)),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          });
                                                                    } else {
                                                                      selectedPurchasing
                                                                          .remove(
                                                                              purchasing);
                                                                    }
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  icon: isSelectedItem
                                                                      ? Icon(
                                                                          Icons
                                                                              .check_box_rounded,
                                                                          color:
                                                                              Theme.of(context).backgroundColor,
                                                                          size:
                                                                              25,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .check_box_outline_blank_rounded,
                                                                          color:
                                                                              Theme.of(context).backgroundColor,
                                                                          size:
                                                                              25,
                                                                        ))
                                                              : Icon(
                                                                  Icons.person,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 25,
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

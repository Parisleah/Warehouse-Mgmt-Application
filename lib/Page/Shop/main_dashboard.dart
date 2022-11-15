import 'dart:io';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:warehouse_mnmt/Page/Component/PieChart.dart';
import 'package:warehouse_mnmt/Page/Component/RaisedGradientButton%20.dart';
import 'package:warehouse_mnmt/Page/Model/Customer.dart';
import 'package:warehouse_mnmt/Page/Model/CustomerAdress.dart';
import 'package:warehouse_mnmt/Page/Model/Product.dart';
import 'package:warehouse_mnmt/Page/Model/ProductLot.dart';
// Component

import 'package:warehouse_mnmt/Page/Model/Selling.dart';
import 'package:warehouse_mnmt/Page/Model/Selling_item.dart';
import 'package:warehouse_mnmt/Page/Model/Shop.dart';
import 'package:warehouse_mnmt/Page/Provider/theme_provider.dart';
import 'package:warehouse_mnmt/Page/Shop/Selling/nav_edit.dart';
import 'package:warehouse_mnmt/Page/Shop/main_shop.dart';

import '../../db/database.dart';
import '../Component/MoneyBox.dart';
import '../Component/ImgCarouselWidget.dart';
import 'package:warehouse_mnmt/Page/Component/TextField/CustomTextField.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../Model/Purchasing.dart';

class DashboardPage extends StatefulWidget {
  final Shop shop;
  DashboardPage({required this.shop, Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final df = new DateFormat('dd-MM-yyyy hh:mm a');
  final dfToday = new DateFormat('hh:mm');
  DateTime date = DateTime.now();

  ThemeMode themeMode = ThemeMode.light;
  bool get isDark => themeMode == ThemeMode.dark;
  List<Color> gradientColors = [
    Color.fromARGB(255, 160, 119, 255),
    Color.fromRGBO(29, 29, 65, 1.0),
  ];

  List<Color> purchasingGradientColors = [
    Color.fromARGB(255, 141, 106, 225),
    Color.fromRGBO(29, 29, 65, 1.0)
  ];
  List<Color> sellingGradientColors = [
    Color.fromARGB(255, 255, 40, 40),
    Color.fromARGB(255, 135, 97, 0)
  ];
  List<Color> profitGradientColors = [
    Color.fromARGB(255, 40, 255, 126),
    Color.fromARGB(255, 0, 116, 60)
  ];
  bool isShowPurchasing = true;
  bool isShowSelling = true;
  bool isShowProfit = true;

  List<PurchasingModel> purchasings = [];
  List<SellingModel> sellings = [];
  List<CustomerModel> customers = [];
  List<Product> products = [];
  var tabbarSelectedIndex = 0;
  var sale = 0;
  var cost = 0;
  var profit = 0;
  var _maxPurchasing = 0;
  bool isToday = true;
  late PageController _pageController;
  int activePage = 1;
  late Shop shop = widget.shop;
  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
    refreshPage();
    _pageController = PageController(viewportFraction: 0.8);
    setState(() {});
  }

  Future refreshShop() async {
    shop = await DatabaseManager.instance.readShop(widget.shop.shopid!);
    setState(() {});
  }

  tabbarChanging() async {
    if (tabbarSelectedIndex == 0) {
      // Today

      purchasings = await DatabaseManager.instance
          .readPurchasingsWHEREisReceivedANDToday(widget.shop.shopid!);

      _calculateDashboard(sale, cost, profit);
      setState(() {});
    } else if (tabbarSelectedIndex == 1) {
      // Week
      // var start = DateFormat('dd-MM-yyyy')
      //     .format(DateTime(date.year, date.month, date.day - 7));
      // var end = DateFormat('dd-MM-yyyy')
      //     .format(DateTime(date.year, date.month, date.day));
      var start = DateTime(date.year, date.month, date.day - 7);
      var end = DateTime(date.year, date.month, date.day);

      purchasings = await DatabaseManager.instance
          .readPurchasingsWHEREisReceivedANDRangeDate(start.toIso8601String(),
              end.toIso8601String(), widget.shop.shopid!);

      _calculateDashboard(sale, cost, profit);
      setState(() {});
      print('purchasings (${purchasings.length})');
    } else if (tabbarSelectedIndex == 2) {
      // Month
      var start = DateTime(date.year, date.month - 1, date.day);
      var end = DateTime(date.year, date.month, date.day + 15);
      purchasings = await DatabaseManager.instance
          .readPurchasingsWHEREisReceivedANDRangeDate(start.toIso8601String(),
              end.toIso8601String(), widget.shop.shopid!);

      _calculateDashboard(sale, cost, profit);
      setState(() {});
    } else {}
  }

  _returnMaxAxis(tabbarSelectedIndex) {
    if (tabbarSelectedIndex == 0) {
      // Today
      return 12.0;
    } else if (tabbarSelectedIndex == 1) {
      // Week
      return 7.0;
    } else if (tabbarSelectedIndex == 2) {
      // Month
      return 30.0;
    } else {
      // Year
      return 12.0;
    }
  }

  List<Widget> sellingIndicators(sellingLength) {
    return List<Widget>.generate(sellingLength, (index) {
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

  List<Widget> productIndicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.black : Colors.black26,
            shape: BoxShape.circle),
      );
    });
  }

  List<CustomerAddressModel> addresses = [];

  Future refreshPage() async {
    products =
        await DatabaseManager.instance.readAllProducts(widget.shop.shopid!);
    purchasings = await DatabaseManager.instance
        .readPurchasingsWHEREisReceivedANDToday(widget.shop.shopid!);
    addresses = await DatabaseManager.instance
        .readCustomerAllAddress(widget.shop.shopid!);
    sellings = await DatabaseManager.instance
        .readAllSellingsORDERBYPresentForGraph(widget.shop.shopid!);
    customers = await DatabaseManager.instance
        .readAllCustomerInShop(widget.shop.shopid!);

    _calculateDashboard(sale, cost, profit);
    setState(() {});
  }

  _calculateDashboard(_sale, _cost, _profit) {
    _cost = 0;
    _sale = 0;
    _profit = 0;
    for (var purchasing in purchasings) {
      _cost += purchasing.total;
    }
    for (var selling in sellings) {
      _sale += selling.total;
      _profit += selling.profit;
    }
    cost = _cost;
    sale = _sale;
    profit = _profit;
  }

  List<FlSpot> gatherPurData() {
    List<FlSpot> spotPurchasingList = [];
    // List<FlSpot> removedSpotWeightList = [];
    for (var pur in purchasings) {
      spotPurchasingList
          .add(FlSpot(pur.amount.toDouble(), pur.total.toDouble()));
      // if (spotWeightList.length >= 19) {
      //   spotWeightList.removeAt(0);
      //   removedSpotWeightList = spotWeightList;
      //   return removedSpotWeightList;
      // }
    }
    return spotPurchasingList;
  }

  List<String> images = [
    "assets/images/products/1.png",
    "assets/images/products/2.png",
    "assets/images/products/3.png",
    "assets/images/products/4.png"
  ];
  dialogPickDateTimeRange() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (dContext, DialogSetState) {
          return AlertDialog(
            backgroundColor: Theme.of(dContext).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            title: Flexible(
              child: Container(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.date_range_rounded),
                    Text(
                      'ระบุช่วง',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            content: Container(
              width: 200,
              height: 200,
              child: SfDateRangePicker(
                view: DateRangePickerView.month,
                selectionMode: DateRangePickerSelectionMode.range,
                // Style
                selectionTextStyle: const TextStyle(color: Colors.white),
                selectionColor: Colors.blue,
                startRangeSelectionColor: Color.fromRGBO(29, 29, 65, 1.0),
                endRangeSelectionColor: Color.fromRGBO(29, 29, 65, 1.0),
                rangeSelectionColor: Theme.of(context).backgroundColor,
                rangeTextStyle:
                    const TextStyle(color: Colors.white, fontSize: 14),
                // Style
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                child: const Text('ยกเลิก'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text('เลือกวัน'),
                onPressed: () {
                  setState(() {});

                  Navigator.pop(context);
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
    DateFormat dateFormat;
    dateFormat = new DateFormat.yMMMMd('th');

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: AppBar(
            // backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              "ภาพรวม",
              textAlign: TextAlign.start,
            ),
            flexibleSpace: Center(
                child: Baseline(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(shop.name, style: Theme.of(context).textTheme.headline2),
                  const SizedBox(
                    width: 10,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                        color: Theme.of(context).colorScheme.background,
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: shop.image == null
                                ? Icon(
                                    Icons.image,
                                    color: Colors.white,
                                  )
                                : Image.file(
                                    File(shop.image),
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
              baselineType: TextBaseline.alphabetic,
              baseline: 25,
            )),
            bottom: TabBar(
                onTap: (value) async {
                  tabbarSelectedIndex = value;
                  setState(() {});
                  if (value == 4) {
                    dialogPickDateTimeRange();
                  }
                  tabbarChanging();
                },
                tabs: [
                  Tab(
                    child: Text("วันนี้"),
                  ),
                  Tab(
                    child: Text("สัปดาห ์"),
                  ),
                  Tab(
                    child: Text("เดือน"),
                  ),
                  Tab(
                    child: Text("ปี"),
                  ),
                  Tab(
                    child: Text("ระบุวันที่"),
                  )
                ]),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 1.5,
            decoration: BoxDecoration(gradient: scafBG_dark_Color),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 160,
                  ),

                  // Color.fromARGB(255, 37, 37, 82),
                  // Color.fromARGB(255, 123, 52, 255),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).colorScheme.primary,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 4))
                      ],
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(29, 29, 65, 1.0),
                          Theme.of(context).backgroundColor,
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        stops: [0.1, 0.8],
                        tileMode: TileMode.clamp,
                      ),
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (tabbarSelectedIndex == 0)
                            Row(
                              children: [
                                Text(
                                  'วันนี้',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' ${DateFormat.yMMMd().format(date)}',

                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                                ),
                              ],
                            ),
                          if (tabbarSelectedIndex == 1)
                            Row(
                              children: [
                                Text(
                                  'สัปดาห์',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' ${DateFormat.yMMMd().format(DateTime(date.year, date.month, date.day - 7))}',

                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                                ),
                                Text(
                                  ' - ${DateFormat.yMMMd().format(date)}',

                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                                ),
                              ],
                            ),
                          if (tabbarSelectedIndex == 2)
                            Row(
                              children: [
                                Text(
                                  'เดือน',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' ${DateFormat.yMMMd().format(DateTime(date.year, date.month - 1, date.day))}',

                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                                ),
                                Text(
                                  ' - ${DateFormat.yMMMd().format(date)}',

                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                                ),
                              ],
                            ),
                          if (tabbarSelectedIndex == 3)
                            Row(
                              children: [
                                Text(
                                  'ปี',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' ${DateFormat.yMMMd().format(DateTime(date.year - 1, date.month, date.day))}',

                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                                ),
                                Text(
                                  ' - ${DateFormat.yMMMd().format(date)}',

                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                                ),
                              ],
                            ),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MoneyBox(
                          Icon(
                            Icons.sell,
                            color: Colors.white,
                          ),
                          Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                          ),
                          'ยอดขาย',
                          sale,
                          Color.fromRGBO(29, 29, 65, 1.0),
                          Theme.of(context).backgroundColor,
                          90,
                          Colors.white),
                      MoneyBox(
                          Icon(Icons.price_change, color: Colors.white),
                          Icon(Icons.price_change, color: Colors.white),
                          'ยอดต้นทุน',
                          cost,
                          Color.fromRGBO(29, 29, 65, 1.0),
                          Theme.of(context).backgroundColor,
                          90,
                          Colors.white),
                      MoneyBox(
                          Icon(Icons.attach_money_rounded, color: Colors.white),
                          Icon(Icons.price_change, color: Colors.white),
                          'กำไร',
                          profit < 0 ? 0 : profit,
                          Color.fromRGBO(29, 29, 65, 1.0),
                          Theme.of(context).backgroundColor,
                          90,
                          Colors.white),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  // Graph Container
                  sellings.isEmpty && purchasings.isEmpty
                      ? Expanded(
                          child: Container(
                            width: 400,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 4))
                              ],
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(29, 29, 65, 1.0),
                                  Theme.of(context).colorScheme.primary,
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                stops: [0.0, 0.8],
                                tileMode: TileMode.clamp,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_chart_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                Text('แสดงผลรูปแบบกราฟ'),
                                Text('(ยังไม่มีการขาย และ สั่งซื้อ)',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          width: 400,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).colorScheme.primary,
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 4))
                            ],
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(29, 29, 65, 1.0),
                                Theme.of(context).colorScheme.primary,
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: [0.0, 0.8],
                              tileMode: TileMode.clamp,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    if (tabbarSelectedIndex == 0)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'วันนี้',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${DateFormat.yMMMd().format(date)}',

                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white),
                                            // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                                          ),
                                        ],
                                      ),
                                    if (tabbarSelectedIndex == 1)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'สัปดาห์ ',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${DateFormat.yMMMd().format(DateTime(date.year, date.month - 1, date.day))} - ${DateFormat.yMMMd().format(date)}',

                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                            // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                                          ),
                                        ],
                                      ),
                                    if (tabbarSelectedIndex == 2)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'เดือน ${DateFormat.MMM().format(DateTime(date.year, date.month - 1, date.day))} -  ${DateFormat.MMM().format(DateTime(date.year, date.month, date.day))}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${DateFormat.yMMMd().format(DateTime(date.year, date.month - 1, date.day))} - ${DateFormat.yMMMd().format(date)}',

                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                            // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                                          ),
                                        ],
                                      ),
                                    if (tabbarSelectedIndex == 3)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ปี ${DateFormat.y().format(DateTime(date.year - 1))} -  ${DateFormat.y().format(DateTime(date.year))}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${DateFormat.yMMMd().format(DateTime(date.year - 1, date.month, date.day))} - ${DateFormat.yMMMd().format(date)}',

                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                            // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                                          ),
                                        ],
                                      ),
                                    const Spacer(),
                                    Container(
                                      color: Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                isShowSelling = !isShowSelling;
                                                setState(() {});
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        isShowSelling
                                                            ? Icons
                                                                .remove_red_eye_rounded
                                                            : Icons
                                                                .remove_red_eye_outlined,
                                                        color: Color.fromARGB(
                                                            255, 255, 40, 40),
                                                        size: 15,
                                                      ),
                                                      Text(
                                                        ' ยอดขาย',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        ' ${NumberFormat("#,###,###.##").format(sale)} ฿',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255)),
                                                        // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                isShowPurchasing =
                                                    !isShowPurchasing;
                                                setState(() {});
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        isShowPurchasing
                                                            ? Icons
                                                                .remove_red_eye_rounded
                                                            : Icons
                                                                .remove_red_eye_outlined,
                                                        color: Color.fromARGB(
                                                            255, 119, 40, 255),
                                                        size: 15,
                                                      ),
                                                      Text(
                                                        ' ต้นทุน',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        ' ${NumberFormat("#,###,###.##").format(cost)} ฿',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255)),
                                                        // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                isShowProfit = !isShowProfit;
                                                setState(() {});
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        isShowProfit
                                                            ? Icons
                                                                .remove_red_eye_rounded
                                                            : Icons
                                                                .remove_red_eye_outlined,
                                                        color: Color.fromARGB(
                                                            255, 40, 255, 180),
                                                        size: 15,
                                                      ),
                                                      Text(
                                                        ' กำไร',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        ' ${NumberFormat("#,###,###.##").format(profit)} ฿',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255)),
                                                        // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, right: 38),
                                child: Center(
                                  child: SizedBox(
                                    width: 400,
                                    height: 300,
                                    child: LineChart(LineChartData(
                                        borderData: FlBorderData(
                                            show: true,
                                            border: Border.all(
                                                color: Colors.transparent,
                                                width: 2)),
                                        gridData: FlGridData(
                                          show: true,
                                          getDrawingHorizontalLine: (value) {
                                            return FlLine(
                                                // เส้น Horizon
                                                color: Color.fromARGB(
                                                    255, 93, 93, 93),
                                                strokeWidth: 1);
                                          },
                                          drawVerticalLine: false,
                                          getDrawingVerticalLine: (value) {
                                            return FlLine(
                                                color: Colors.white,
                                                strokeWidth: 1);
                                          },
                                        ),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          bottomTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 35,
                                              getTextStyles: (context, value) {
                                                return const TextStyle(
                                                    color: Color(0xff68737d),
                                                    fontSize: 8,
                                                    fontWeight:
                                                        FontWeight.bold);
                                              },
                                              getTitles: (value) {
                                                // Today
                                                if (tabbarSelectedIndex == 0) {
                                                  switch (value.toInt()) {
                                                    case 0:
                                                      return '0';
                                                    case 1:
                                                      return '1';
                                                    case 2:
                                                      return '2';
                                                    case 4:
                                                      return '4';
                                                    case 6:
                                                      return '6';
                                                    case 8:
                                                      return '8';
                                                    case 10:
                                                      return '10';
                                                    case 12:
                                                      return '12';
                                                  }
                                                } else if (tabbarSelectedIndex ==
                                                    1) {
                                                  // Week
                                                  switch (value.toInt()) {
                                                    case 0:
                                                      return '${DateFormat.MMM().format(date)}} 1';
                                                    case 1:
                                                      return '${DateFormat.MMM().format(date)} 7';
                                                    case 2:
                                                      return '${DateFormat.MMM().format(date)} 14';
                                                    case 3:
                                                      return '${DateFormat.MMM().format(date)} 21';
                                                    case 4:
                                                      return '${DateFormat.MMM().format(date)} 28';
                                                    case 5:
                                                      return '${DateFormat.MMM().format(date)} 30';
                                                  }
                                                } else if (tabbarSelectedIndex ==
                                                    2) {
                                                  // Monthly\

                                                  switch (value.toInt()) {
                                                    case 0:
                                                      return '${DateFormat.MMM().format(DateTime(date.year, date.month - 1, date.day))} ${DateFormat.d().format(DateTime(date.year, date.month, date.day))}';
                                                    case 1:
                                                      return '${DateFormat.MMM().format(DateTime(date.year, date.month - 1, date.day))} ${DateFormat.d().format(DateTime(date.year, date.month, date.day + 5))}';
                                                    case 5:
                                                      return '${DateFormat.MMM().format(DateTime(date.year, date.month - 1, date.day))} ${DateFormat.d().format(DateTime(date.year, date.month, date.day + 10))}';
                                                    case 10:
                                                      return '${DateFormat.MMM().format(DateTime(date.year, date.month - 1, date.day))} ${DateFormat.d().format(DateTime(date.year, date.month, date.day + 15))}';
                                                    case 15:
                                                      return '${DateFormat.MMM().format(date)} 1';
                                                    case 20:
                                                      return '${DateFormat.MMM().format(date)} 5';
                                                    case 25:
                                                      return '${DateFormat.MMM().format(date)} 10';
                                                    case 30:
                                                      return '${DateFormat.MMM().format(date)} 15';
                                                  }
                                                } else if (tabbarSelectedIndex ==
                                                    3) {
                                                  // Year
                                                  switch (value.toInt()) {
                                                    case 0:
                                                      return 'Jan';
                                                    case 1:
                                                      return 'Jan';
                                                    case 2:
                                                      return 'Feb';
                                                    case 3:
                                                      return 'Mar';
                                                    case 4:
                                                      return 'April';
                                                    case 5:
                                                      return 'May';
                                                    case 6:
                                                      return 'June';
                                                    case 7:
                                                      return 'July';
                                                    case 8:
                                                      return 'Aug';
                                                    case 9:
                                                      return 'Sep';
                                                    case 10:
                                                      return 'Oct';
                                                    case 11:
                                                      return 'Nov';
                                                    case 12:
                                                      return 'Dec';
                                                  }
                                                }

                                                return '';
                                              },
                                              margin: 8),
                                          rightTitles: SideTitles(),
                                          topTitles: SideTitles(),
                                          leftTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 35,
                                            getTextStyles: (context, value) {
                                              return const TextStyle(
                                                  color: Color(0xff68737d),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold);
                                            },
                                            getTitles: (value) {
                                              var maxPurchasing = purchasings
                                                  .reduce((curr, next) =>
                                                      curr.total > next.total
                                                          ? curr
                                                          : next);

                                              var maxSelling = sellings.reduce(
                                                  (curr, next) =>
                                                      curr.total > next.total
                                                          ? curr
                                                          : next);
                                              int _maxPurchasing =
                                                  maxPurchasing.total;
                                              int _maxSelling =
                                                  maxSelling.total;
                                              switch (value.toInt()) {
                                                // กดเดือน
                                                // 1. Display เดือนที่ผ่านมา
                                                // 2. Display เป็นเดือนกว้างๆ Sep Oct Nov Dec
                                                case 0:
                                                  return '0';
                                                case 5000:
                                                  return '${_maxPurchasing > _maxSelling ? (_maxPurchasing / 6).toInt() : (_maxSelling / 6).toInt()}';
                                                case 10000:
                                                  return '${_maxPurchasing > _maxSelling ? (_maxPurchasing / 4).toInt() : (_maxSelling / 4).toInt()}';
                                                case 15000:
                                                  return '${_maxPurchasing > _maxSelling ? (_maxPurchasing / 2).toInt() : (_maxSelling / 2).toInt()}';
                                                case 20000:
                                                  return '${_maxPurchasing > _maxSelling ? _maxPurchasing : _maxSelling}';
                                              }
                                              return '';
                                            },
                                            margin: 12,
                                          ),
                                        ),
                                        maxX:
                                            _returnMaxAxis(tabbarSelectedIndex),
                                        maxY: 20000,
                                        minY: 0,
                                        minX: 0,
                                        lineBarsData: [
                                          if (purchasings.isNotEmpty)
                                            LineChartBarData(
                                                spots: isShowPurchasing
                                                    ? purchasings
                                                        .map((point) => FlSpot(
                                                            tabbarSelectedIndex ==
                                                                    0
                                                                ?
                                                                // Today
                                                                point
                                                                    .orderedDate
                                                                    .hour
                                                                    .toDouble()
                                                                :
                                                                // Year
                                                                tabbarSelectedIndex ==
                                                                        3
                                                                    ? point
                                                                        .orderedDate
                                                                        .month
                                                                        .toDouble()
                                                                    :
                                                                    // Week
                                                                    tabbarSelectedIndex ==
                                                                            1
                                                                        ? point.orderedDate.day.toDouble() /
                                                                            7
                                                                        :
                                                                        // Month
                                                                        point.orderedDate.month !=
                                                                                date
                                                                                    .month
                                                                            ? point.orderedDate.day.toDouble() -
                                                                                15
                                                                            : point.orderedDate.day.toDouble() +
                                                                                15,
                                                            point.total
                                                                .toDouble()))
                                                        .toList()
                                                    : null,
                                                isCurved: true,
                                                colors: [
                                                  Theme.of(context)
                                                      .backgroundColor,
                                                ],
                                                barWidth: 2,
                                                belowBarData: BarAreaData(
                                                    gradientFrom: Offset(0, 1),
                                                    show: true,
                                                    colors: gradientColors
                                                        .map((e) =>
                                                            e.withOpacity(0.8))
                                                        .toList())),
                                          if (sellings.isNotEmpty)
                                            LineChartBarData(
                                                spots: isShowSelling
                                                    ? 

                                                    // List ข้อมูลการขายs
                                                    sellings
                                                        .map((point) => FlSpot(
                                                            //  X ข้อมูลวันที่
                                                            point
                                                                .orderedDate.day
                                                                .toDouble(),
                                                            // Y ยอดขาย
                                                            point.total
                                                                .toDouble()
                                                                ))


                                                        .toList()
                                                    : null,
                                                isCurved: true,
                                                colors: [
                                                  Color.fromARGB(
                                                      255, 244, 112, 112),
                                                ],
                                                barWidth: 2,
                                                belowBarData: BarAreaData(
                                                    gradientFrom: Offset(0, 1),
                                                    show: true,
                                                    colors:
                                                        sellingGradientColors
                                                            .map((e) =>
                                                                e.withOpacity(
                                                                    0.0))
                                                            .toList())),
                                          if (sellings.isNotEmpty)
                                            LineChartBarData(
                                                spots: isShowProfit
                                                    ? sellings
                                                        .map((point) => FlSpot(
                                                            point
                                                                .orderedDate.day
                                                                .toDouble(),
                                                            point.profit
                                                                .toDouble()))
                                                        .toList()
                                                    : null,
                                                isCurved: true,
                                                colors: [
                                                  Color.fromARGB(
                                                      255, 24, 255, 167),
                                                ],
                                                barWidth: 2,
                                                belowBarData: BarAreaData(
                                                    gradientFrom: Offset(0, 1),
                                                    show: true,
                                                    colors: profitGradientColors
                                                        .map((e) =>
                                                            e.withOpacity(0.0))
                                                        .toList()))
                                        ])),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  // Doing

                  const SizedBox(
                    height: 10,
                  ),
                  // sellings.isEmpty && products.isEmpty
                  //     ? Container()
                  //     : Container(
                  //         height: 300,
                  //         // decoration: BoxDecoration(
                  //         //   boxShadow: [
                  //         //     BoxShadow(
                  //         //         color: Theme.of(context).colorScheme.primary,
                  //         //         spreadRadius: 2,
                  //         //         blurRadius: 5,
                  //         //         offset: Offset(0, 4))
                  //         //   ],
                  //         //   gradient: LinearGradient(
                  //         //     colors: [
                  //         //       Color.fromRGBO(29, 29, 65, 1.0),
                  //         //       Theme.of(context).backgroundColor,
                  //         //     ],
                  //         //     begin: Alignment.bottomLeft,
                  //         //     end: Alignment.topRight,
                  //         //     stops: [0.1, 0.8],
                  //         //     tileMode: TileMode.clamp,
                  //         //   ),
                  //         //   borderRadius: BorderRadius.circular(20),
                  //         // ),
                  //         child: Column(
                  //           children: [
                  //             Row(
                  //               children: [
                  //                 Padding(
                  //                   padding: const EdgeInsets.all(10.0),
                  //                   child: Text(
                  //                     "สินค้าขายดี",
                  //                     style: TextStyle(
                  //                         fontSize: 20, color: Colors.white),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //             ClipRRect(
                  //               borderRadius: BorderRadius.circular(20),
                  //               child: SizedBox(
                  //                 width: MediaQuery.of(context).size.width,
                  //                 height: 220,
                  //                 child: PageView.builder(
                  //                     itemCount: products.length,
                  //                     pageSnapping: true,
                  //                     controller: _pageController,
                  //                     onPageChanged: (page) {
                  //                       setState(() {
                  //                         activePage = page;
                  //                       });
                  //                     },
                  //                     itemBuilder: (context, pagePosition) {
                  //                       return Container(
                  //                         margin: EdgeInsets.all(10),
                  //                         child: Column(
                  //                           children: [
                  //                             Stack(
                  //                               children: [
                  //                                 ClipRRect(
                  //                                   borderRadius:
                  //                                       BorderRadius.circular(
                  //                                           10),
                  //                                   child: Container(
                  //                                     width: 300,
                  //                                     height: 175,
                  //                                     child: Image.file(
                  //                                       File(products[
                  //                                               pagePosition]
                  //                                           .prodImage!),
                  //                                       fit: BoxFit.cover,
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                                 Positioned(
                  //                                   top: 0.0,
                  //                                   right: 0.0,
                  //                                   child: Container(
                  //                                       decoration:
                  //                                           BoxDecoration(
                  //                                         boxShadow: [
                  //                                           BoxShadow(
                  //                                               color: Colors
                  //                                                   .black
                  //                                                   .withOpacity(
                  //                                                       0.7),
                  //                                               spreadRadius: 0,
                  //                                               blurRadius: 5,
                  //                                               offset: Offset(
                  //                                                   0, 4))
                  //                                         ],
                  //                                         color:
                  //                                             Colors.redAccent,
                  //                                         borderRadius:
                  //                                             BorderRadius
                  //                                                 .circular(10),
                  //                                       ),
                  //                                       child: Padding(
                  //                                         padding:
                  //                                             const EdgeInsets
                  //                                                 .all(3.0),
                  //                                         child: Row(
                  //                                           children: [
                  //                                             Icon(
                  //                                               Icons
                  //                                                   .sell_rounded,
                  //                                               color: Colors
                  //                                                   .white,
                  //                                               size: 15,
                  //                                             ),
                  //                                             Text(
                  //                                               'ขายดี',
                  //                                               style:
                  //                                                   TextStyle(
                  //                                                 fontSize: 9,
                  //                                                 color: Colors
                  //                                                     .white,
                  //                                               ),
                  //                                             )
                  //                                           ],
                  //                                         ),
                  //                                       )),
                  //                                 )
                  //                               ],
                  //                             ),
                  //                             Text(
                  //                                 '${products[pagePosition].prodName}'),
                  //                           ],
                  //                         ),
                  //                       );
                  //                     }),
                  //               ),
                  //             ),
                  //             Row(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: productIndicators(
                  //                     products.length, activePage))
                  //           ],
                  //         ),
                  //       ),
                  const SizedBox(
                    height: 10,
                  ),
                  sellings.isEmpty
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "ขายวันนี้",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                  sellings.isEmpty
                      ? Container()
                      : Container(
                          height: 140,
                          width: 450,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.zero,
                              itemCount: sellings.length,
                              itemBuilder: (context, index) {
                                final selling = sellings[index];
                                var _customerText;
                                var _phoneText;
                                var _addressText;
                                for (var customer in customers) {
                                  if (customer.cusId == selling.customerId) {
                                    _customerText = customer;
                                  }
                                }

                                for (var address in addresses) {
                                  if (address.cAddreId == selling.cAddreId) {
                                    _phoneText = address;
                                    _addressText = address;
                                  }
                                }
                                return TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SellingNavEdit(
                                                  customerAddress: _addressText,
                                                  customer: _customerText,
                                                  shop: widget.shop,
                                                  selling: selling,
                                                )));
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  spreadRadius: 0,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 3))
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(22),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromRGBO(29, 29, 65, 1.0),
                                                Theme.of(context)
                                                    .backgroundColor,
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            )),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.person,
                                                size: 50,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                _customerText.cName,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                '${NumberFormat("#,###.##").format(selling.total)} ฿',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ]),
                                      ),
                                      Positioned(
                                        top: 0.0,
                                        right: 0.0,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                    spreadRadius: 0,
                                                    blurRadius: 5,
                                                    offset: Offset(0, 4))
                                              ],
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Row(
                                              children: [
                                                selling.isDelivered == true
                                                    ? Row(
                                                        children: [
                                                          Icon(
                                                            Icons.check_circle,
                                                            color: Colors
                                                                .greenAccent,
                                                            size: 22,
                                                          ),
                                                          Text(
                                                            'จัดส่งแล้ว',
                                                            style: TextStyle(
                                                              fontSize: 9,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    : Icon(
                                                        Icons.circle_outlined,
                                                        color:
                                                            Colors.greenAccent,
                                                        size: 25,
                                                      ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: sellingIndicators(sellings.length)),

                  const SizedBox(
                    height: 10,
                  ),
                  // Container(
                  //   height: 140,
                  //   width: 450,
                  //   child: PieChartSample2(),
                  // ),

                  // SizedBox(
                  //   height: 50,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

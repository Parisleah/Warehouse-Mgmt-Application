import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final df = new DateFormat('dd-MM-yyyy hh:mm a');
  final dfToday = new DateFormat('hh:mm');

  DateTime date = DateTime.now();
  List<PurchasingModel> purchasings = [];
  List<SellingModel> sellings = [];
  List<CustomerModel> customers = [];
  List<Product> products = [];

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
        .readAllPurchasingsORDERBYPresentForGraph(widget.shop.shopid!);
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
    for (var purchasing in purchasings) {
      _cost += purchasing.total;
    }
    for (var selling in sellings) {
      _sale += selling.total;
    }
    cost = _cost;
    sale = _sale;
    profit = _sale - _cost;
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
                onTap: (value) {
                  date = DateTime.now();
                  // date = 30 / 9 / 2022
                  date = DateTime(date.day, date.month, date.year);
                  setState(() {
                    date = DateTime(
                      value == 3 ? date.year - 1 : date.year,
                      value == 2 ? date.month - 1 : date.month,
                      value == 1 ? date.day - 7 : date.day,
                      value == 0 ? date.day : date.day,
                    );
                  });

                  print(date);
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
            height: MediaQuery.of(context).size.height * 2.2,
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
                          Text(
                            'วันนี้',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' ${DateFormat.yMMMd().format(DateTime.now())}',

                            style: TextStyle(fontSize: 12, color: Colors.white),
                            // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
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
                  Container(
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
                              Container(),
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(
                                                255, 255, 40, 40),
                                            size: 15,
                                          ),
                                          Text(
                                            ' ยอดขาย',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            ' ${NumberFormat("#,###,###.##").format(sale)} ฿',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255)),
                                            // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(
                                                255, 141, 106, 225),
                                            size: 15,
                                          ),
                                          Text(
                                            ' ต้นทุน',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            ' ${NumberFormat("#,###,###.##").format(cost)} ฿',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255)),
                                            // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(
                                                255, 40, 255, 108),
                                            size: 15,
                                          ),
                                          Text(
                                            ' กำไร',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            ' ${NumberFormat("#,###,###.##").format(profit < 0 ? 0 : profit)} ฿',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255)),
                                            // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 38),
                          child: Center(
                            child: SizedBox(
                              width: 400,
                              height: 300,
                              child: LineChart(LineChartData(
                                  borderData: FlBorderData(
                                      show: true,
                                      border: Border.all(
                                          color: Colors.transparent, width: 2)),
                                  gridData: FlGridData(
                                    show: true,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                          // เส้น Horizon
                                          color:
                                              Color.fromARGB(255, 93, 93, 93),
                                          strokeWidth: 1);
                                    },
                                    drawVerticalLine: false,
                                    getDrawingVerticalLine: (value) {
                                      return FlLine(
                                          color: Colors.white, strokeWidth: 1);
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
                                              fontWeight: FontWeight.bold);
                                        },
                                        getTitles: (value) {
                                          DateFormat.yMMMd()
                                              .format(DateTime.now());

                                          switch (value.toInt()) {
                                            case 1:
                                              return '${DateFormat.MMM().format(date)} 1';
                                            case 5:
                                              return '${DateFormat.MMM().format(date)} 5';
                                            case 10:
                                              return '${DateFormat.MMM().format(date)} 10';
                                            case 15:
                                              return '${DateFormat.MMM().format(date)} 15';
                                            case 20:
                                              return '${DateFormat.MMM().format(date)} 20';
                                            case 25:
                                              return '${DateFormat.MMM().format(date)} 25';
                                            case 30:
                                              return '${DateFormat.MMM().format(date)} 30';
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
                                        var maxPurchasing = purchasings.reduce(
                                            (curr, next) =>
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
                                        int _maxSelling = maxSelling.total;
                                        switch (value.toInt()) {
                                          // กดเดือน
                                          // 1. Display เดือนที่ผ่านมา
                                          // 2. Display เป็นเดือนกว้างๆ Sep Oct Nov Dec
                                          case 0:
                                            return '0';
                                          case 1000:
                                            return '500';
                                          case 3000:
                                            return '750';
                                          case 10000:
                                            return '1500';
                                          case 20000:
                                            return '${_maxPurchasing > _maxSelling ? _maxPurchasing : _maxSelling}';
                                        }
                                        return '';
                                      },
                                      margin: 12,
                                    ),
                                  ),
                                  maxX: 30,
                                  maxY: 20000,
                                  minY: 0,
                                  minX: 0,
                                  lineBarsData: [
                                    LineChartBarData(
                                        spots: purchasings
                                            .map((point) => FlSpot(
                                                point.orderedDate.day
                                                    .toDouble(),
                                                point.total.toDouble()))
                                            .toList(),
                                        isCurved: true,
                                        colors: [
                                          Theme.of(context).backgroundColor,
                                        ],
                                        barWidth: 2,
                                        belowBarData: BarAreaData(
                                            gradientFrom: Offset(0, 1),
                                            show: true,
                                            colors: gradientColors
                                                .map((e) => e.withOpacity(0.8))
                                                .toList())),
                                    LineChartBarData(
                                        spots: sellings
                                            .map((point) => FlSpot(
                                                point.orderedDate.day
                                                    .toDouble(),
                                                point.total.toDouble()))
                                            .toList(),
                                        isCurved: true,
                                        colors: [
                                          Color.fromARGB(255, 244, 112, 112),
                                        ],
                                        barWidth: 2,
                                        belowBarData: BarAreaData(
                                            gradientFrom: Offset(0, 1),
                                            show: true,
                                            colors: sellingGradientColors
                                                .map((e) => e.withOpacity(0.8))
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
                  sellings.isEmpty && products.isEmpty
                      ? Container()
                      : Container(
                          height: 300,
                          // decoration: BoxDecoration(
                          //   boxShadow: [
                          //     BoxShadow(
                          //         color: Theme.of(context).colorScheme.primary,
                          //         spreadRadius: 2,
                          //         blurRadius: 5,
                          //         offset: Offset(0, 4))
                          //   ],
                          //   gradient: LinearGradient(
                          //     colors: [
                          //       Color.fromRGBO(29, 29, 65, 1.0),
                          //       Theme.of(context).backgroundColor,
                          //     ],
                          //     begin: Alignment.bottomLeft,
                          //     end: Alignment.topRight,
                          //     stops: [0.1, 0.8],
                          //     tileMode: TileMode.clamp,
                          //   ),
                          //   borderRadius: BorderRadius.circular(20),
                          // ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "สินค้าขายดี",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 220,
                                  child: PageView.builder(
                                      itemCount: products.length,
                                      pageSnapping: true,
                                      controller: _pageController,
                                      onPageChanged: (page) {
                                        setState(() {
                                          activePage = page;
                                        });
                                      },
                                      itemBuilder: (context, pagePosition) {
                                        return Container(
                                          margin: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Container(
                                                      width: 300,
                                                      height: 175,
                                                      child: Image.file(
                                                        File(products[
                                                                pagePosition]
                                                            .prodImage!),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0.0,
                                                    right: 0.0,
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.7),
                                                                spreadRadius: 0,
                                                                blurRadius: 5,
                                                                offset: Offset(
                                                                    0, 4))
                                                          ],
                                                          color:
                                                              Colors.redAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .sell_rounded,
                                                                color: Colors
                                                                    .white,
                                                                size: 15,
                                                              ),
                                                              Text(
                                                                'ขายดี',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 9,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                  )
                                                ],
                                              ),
                                              Text(
                                                  '${products[pagePosition].prodName}'),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: productIndicators(
                                      products.length, activePage))
                            ],
                          ),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "ขายวันนี้",
                          style: TextStyle(fontSize: 20, color: Colors.white),
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
                  Container(
                    height: 140,
                    width: 450,
                    child: PieChartSample2(),
                  ),

                  SizedBox(
                    height: 50,
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

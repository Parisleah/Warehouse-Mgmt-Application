import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warehouse_mnmt/Page/Component/RaisedGradientButton%20.dart';
// Component
import 'package:warehouse_mnmt/Page/Component/theme/theme.dart';
import 'package:warehouse_mnmt/Page/Model/Selling.dart';
import 'package:warehouse_mnmt/Page/Model/Selling_item.dart';
import 'package:warehouse_mnmt/Page/Model/Shop.dart';

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
    Color.fromARGB(255, 141, 106, 225),
    Color.fromRGBO(29, 29, 65, 1.0)
  ];
  DateTime date = DateTime.now();
  List<PurchasingModel> purchasings = [];
  List<SellingModel> sellings = [];
  var sale = 0;
  var cost = 0;
  var profit = 0;

  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
    refreshPurchasings();

    setState(() {});
  }

  Future refreshPurchasings() async {
    purchasings =
        await DatabaseManager.instance.readAllPurchasings(widget.shop.shopid!);
    sellings =
        await DatabaseManager.instance.readAllSellings(widget.shop.shopid!);
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
            automaticallyImplyLeading: false,
            title: const Text(
              "ภาพรวม",
              textAlign: TextAlign.start,
            ),
            flexibleSpace: Center(
                child: Baseline(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.shop.name,
                      style: Theme.of(context).textTheme.headline2),
                  const SizedBox(
                    width: 10,
                  ),
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
            height: MediaQuery.of(context).size.height * 1.9,
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
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).colorScheme.onSecondary,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 4))
                      ],
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).backgroundColor,
                          Theme.of(context).colorScheme.onSecondary,
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        stops: [0.1, 0.8],
                        tileMode: TileMode.clamp,
                      ),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'วันนี้',
                            style: TextStyle(
                                fontSize: 25,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold),
                          ),
                          Center(
                            child: Text(
                              dateFormat.format(date),
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white),
                              // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                            ),
                          )
                        ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                      Theme.of(context).backgroundColor,
                      Theme.of(context).colorScheme.onSecondary,
                      150,
                      Colors.white),
                  const SizedBox(
                    height: 20,
                  ),
                  MoneyBox(
                      Icon(Icons.price_change, color: Colors.white),
                      Icon(Icons.price_change, color: Colors.white),
                      'ยอดต้นทุน',
                      cost,
                      Theme.of(context).backgroundColor,
                      Theme.of(context).colorScheme.onSecondary,
                      150,
                      Colors.white),
                  const SizedBox(
                    height: 20,
                  ),
                  MoneyBox(
                      Icon(Icons.attach_money_rounded, color: Colors.white),
                      Icon(Icons.price_change, color: Colors.white),
                      'กำไร',
                      profit,
                      Theme.of(context).backgroundColor,
                      Theme.of(context).colorScheme.onSecondary,
                      150,
                      Colors.white),
                  const SizedBox(
                    height: 20,
                  ),

                  // Container(
                  //   height: 250,
                  //   decoration: BoxDecoration(
                  //     gradient: const LinearGradient(
                  //       colors: [
                  //         Color.fromRGBO(29, 29, 65, 1.0),
                  //         Color.fromARGB(255, 90, 70, 136),
                  //       ],
                  //       begin: Alignment.bottomLeft,
                  //       end: Alignment.topRight,
                  //       stops: [0.1, 0.8],
                  //       tileMode: TileMode.clamp,
                  //     ),
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   child: Column(
                  //     children: [Text("Top10"), ImgCarousel(images)],
                  //   ),
                  // ),

                  Padding(
                    padding: const EdgeInsets.only(right: 38),
                    child: Center(
                      child: SizedBox(
                        width: 400,
                        height: 300,
                        child: LineChart(LineChartData(
                            borderData: FlBorderData(
                                show: true,
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            gridData: FlGridData(
                              show: true,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                    color: Color.fromARGB(255, 93, 93, 93),
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold);
                                  },
                                  getTitles: (value) {
                                    switch (value.toInt()) {
                                      case 0:
                                        return 'Sep 19';
                                      case 4:
                                        return 'Oct 10';
                                      case 8:
                                        return 'Nov 16';
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold);
                                },
                                getTitles: (value) {
                                  switch (value.toInt()) {
                                    case 0:
                                      return '0';
                                    case 2:
                                      return '50';
                                    case 4:
                                      return '100';
                                    case 6:
                                      return '150';
                                  }
                                  return '';
                                },
                                margin: 12,
                              ),
                            ),
                            maxX: 8,
                            maxY: 8,
                            minY: 0,
                            minX: 0,
                            lineBarsData: [
                              LineChartBarData(
                                  spots: [
                                    const FlSpot(0, 0),
                                    const FlSpot(5, 5),
                                    const FlSpot(7, 6),
                                    const FlSpot(8, 4),
                                  ],
                                  isCurved: true,
                                  colors: [
                                    Colors.black12,
                                    Colors.white70,
                                    Colors.white
                                  ],
                                  barWidth: 5,
                                  belowBarData: BarAreaData(
                                      show: true,
                                      colors: gradientColors
                                          .map((e) => e.withOpacity(0.3))
                                          .toList()))
                            ])),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

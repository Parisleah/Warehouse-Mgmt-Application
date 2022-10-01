import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Component
import 'package:warehouse_mnmt/Page/Component/theme/theme.dart';
import 'package:warehouse_mnmt/Page/Model/Shop.dart';
import '../Component/moneyBox.dart';
import '../Component/imgCarouselWidget.dart';
import 'package:warehouse_mnmt/Page/Component/TextField/CustomTextField.dart';
import 'package:intl/date_symbol_data_local.dart';

class DashboardPage extends StatefulWidget {
  final Shop shop;
  DashboardPage({required this.shop, Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  ThemeMode themeMode = ThemeMode.light;
  bool get isDark => themeMode == ThemeMode.dark;
  final CustomTextField saveForm = new CustomTextField();
  final controller = TextEditingController();
  DateTime date = DateTime.now();
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    controller.addListener(() => setState(() {}));
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
            // decoration: BoxDecoration(gradient: scafBG_dark_Color),
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
                      212000,
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
                      124500.165,
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
                      87499.84,
                      Theme.of(context).backgroundColor,
                      Theme.of(context).colorScheme.onSecondary,
                      150,
                      Colors.white),
                  const SizedBox(
                    height: 20,
                  ),
                  // CustomTextField.textField(
                  //     context,
                  //     length: 30,
                  //     textController: controller,
                  //     'กำหนดชื่อโปรไฟล์ของคุณ'),
                  ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.save),
                      label: const Text('Save')),

                  // Container(
                  //   height: 200,
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
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

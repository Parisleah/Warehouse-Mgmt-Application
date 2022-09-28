import 'package:flutter/material.dart';
import 'package:warehouse_mnmt/Page/Component/theme/theme.dart';
import 'package:warehouse_mnmt/Page/Component/theme/theme.dart';
import 'package:warehouse_mnmt/Page/Shop/Product/nav_add.dart';
import 'package:warehouse_mnmt/Page/Shop/Selling/nav_add.dart';

import '../Component/searchBox.dart';
import '../Model/Product.dart';
import '../Model/Shop.dart';

class ProductPage extends StatefulWidget {
  final Shop shop;
  const ProductPage({required this.shop, Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;

    List<Product> products = [];

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(180),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "สินค้า",
              textAlign: TextAlign.start,
            ),
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Baseline(
                  baseline: 110,
                  baselineType: TextBaseline.alphabetic,
                  child: SearchBox("ชื่อสินค้า")),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => ProductNavAdd(
                                shop: widget.shop,
                              )));
                },
                icon: const Icon(
                  Icons.add,
                  size: 30,
                ),
              )
            ],
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
          // decoration: BoxDecoration(gradient: scafBG_dark_Color),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 210,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          "(พื้นที่วาง Widget)",
                          style: TextStyle(color: Colors.grey, fontSize: 30),
                        ))
                      ],
                    ),
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

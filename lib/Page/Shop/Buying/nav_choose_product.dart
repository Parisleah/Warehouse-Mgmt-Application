import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warehouse_mnmt/Page/Model/Product.dart';

import '../../../db/database.dart';
import '../../Model/ProductCategory.dart';
import '../../Model/ProductModel.dart';
import '../../Model/Shop.dart';
import 'nav_showProduct.dart';

class BuyiingNavChooseProduct extends StatefulWidget {
  final Shop shop;
  const BuyiingNavChooseProduct({required this.shop, Key? key})
      : super(key: key);

  @override
  State<BuyiingNavChooseProduct> createState() =>
      _BuyiingNavChooseProductState();
}

class _BuyiingNavChooseProductState extends State<BuyiingNavChooseProduct> {
  //  Visible -----------
  // ตะกร้า
  bool inCartIsVisible = false;

  // สินค้าหมด
  bool outOfStockIsVisible = false;
  //  Visible -----------
  bool _validate = false;
  List<Product> products = [];
  List<ProductCategory> productCategorys = [];
  List<ProductModel> productModels = [];
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    refreshProducts();

    setState(() {});
    searchController.addListener(() => setState(() {}));
  }

  Future refreshProducts() async {
    productModels = await DatabaseManager.instance.readAllProductModels();
    productCategorys = await DatabaseManager.instance
        .readAllProductCategorys(widget.shop.shopid!);
    products =
        await DatabaseManager.instance.readAllProducts(widget.shop.shopid!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(160),
        child: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
          title: Column(
            children: const [
              Text(
                "เลือกสินค้า",
                style: TextStyle(fontSize: 25),
              )
            ],
          ),
          centerTitle: true,
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Baseline(
              baseline: 120,
              baselineType: TextBaseline.alphabetic,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .background
                        .withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15)),
                width: 380,
                height: 80,
                child: TextFormField(
                    keyboardType: TextInputType.text,
                    onChanged: (text) async {
                      products = await DatabaseManager.instance
                          .readAllProductsByName(
                              widget.shop.shopid!, searchController.text);
                      setState(() {});
                    },
                    // maxLength: length,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(30),
                    ],
                    controller: searchController,
                    //-----------------------------------------------------

                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      errorText: _validate ? 'โปรดระบุ' : null, //
                      contentPadding: EdgeInsets.only(
                          top: 25, bottom: 10, left: 10, right: 10),
                      // labelText: title,
                      filled: true,
                      labelStyle: TextStyle(color: Colors.white),
                      counterStyle: TextStyle(color: Colors.white),
                      // fillColor: Theme.of(context).colorScheme.background,
                      focusColor: Color.fromARGB(255, 255, 0, 0),
                      hoverColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),

                      hintText: 'ชื่อสินค้า',
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      suffixIcon: searchController.text.isEmpty
                          ? Container(
                              width: 0,
                            )
                          : IconButton(
                              onPressed: () {
                                searchController.clear();
                                // refreshProducts();
                              },
                              icon: const Icon(
                                Icons.close_sharp,
                                color: Colors.white,
                              ),
                            ),
                    )),
              ),
            ),
          ),
          backgroundColor: Color.fromRGBO(30, 30, 65, 1.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
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
            SizedBox(height: 180),
            // ListView
            products.isEmpty
                ? Container(
                    width: 440,
                    height: 518.0,
                    child: Center(
                        child: Text(
                      searchController.text.isEmpty
                          ? 'ไม่มีสินค้า'
                          : 'ไม่มีสินค้า ${searchController.text}',
                      style: TextStyle(color: Colors.grey, fontSize: 25),
                    )),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      height: 518.0,
                      width: 440.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.transparent,
                      ),
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            var category;
                            for (var prCategory in productCategorys) {
                              if (product.prodCategId ==
                                  prCategory.prodCategId) {
                                category = prCategory;
                              }
                            }

                            var cost = [];
                            var price = [];

                            for (var prModel in productModels) {
                              if (prModel.prodId == product.prodId) {
                                cost.add(prModel.cost);
                                price.add(prModel.price);
                                print(' + ${prModel.cost} +  ${prModel.price}');
                              }
                            }
                            var _minCost = 0;
                            var _maxCost = 0;
                            var _minPrice = 0;
                            var _maxPrice = 0;

                            if (cost.isNotEmpty && price.isNotEmpty) {
                              var minCost = cost.reduce(
                                  (curr, next) => curr < next ? curr : next);
                              var maxCost = cost.reduce(
                                  (curr, next) => curr > next ? curr : next);
                              var minprice = price.reduce(
                                  (curr, next) => curr < next ? curr : next);
                              var maxprice = price.reduce(
                                  (curr, next) => curr > next ? curr : next);
                              _minCost = minCost;
                              _maxCost = maxCost;
                              _minPrice = minprice;
                              _maxPrice = maxprice;
                            }
                            return TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        BuyingNavShowProd(product: product)));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    height: 80,
                                    width: 400,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 90,
                                          height: 90,
                                          child: Image.file(
                                            File(product.prodImage!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  Text(
                                                    product.prodName,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor:
                                                        Color.fromRGBO(
                                                            30, 30, 49, 1.0),
                                                    child: Text(
                                                        '${NumberFormat("#,###.##").format(product.prodId)}',
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    category == null
                                                        ? "ไม่มีหมวดหมู่สินค้า"
                                                        : category
                                                            .prodCategName,
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                  'ต้นทุน ${NumberFormat("#,###.##").format(_minCost)} - ${NumberFormat("#,###.##").format(_maxCost)}',
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12)),
                                              Text(
                                                  'ราคา ${NumberFormat("#,###.##").format(_minPrice)} - ${NumberFormat("#,###.##").format(_maxPrice)}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                if (inCartIsVisible)
                                                  // ตะกร้า 1 -------------------------
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    child: Container(
                                                      height: 15,
                                                      width: 22,
                                                      color: Colors.redAccent,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Icon(
                                                              Icons
                                                                  .shopping_cart_rounded,
                                                              size: 10,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            Text(
                                                              "1",
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                // ตะกร้า 1 -------------------------
                                                if (outOfStockIsVisible)

                                                  // + เพิ่มสินค้า  -------------------------
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    child: Container(
                                                      height: 30,
                                                      width: 65,
                                                      color: Colors.greenAccent,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Center(
                                                          child: const Text(
                                                            "+ เพิ่มสินค้า",
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                // + เพิ่มสินค้า  -------------------------

                                                // สินค้าหมด Tag -------------------------------------
                                                // ClipRRect(
                                                //   borderRadius:
                                                //       BorderRadius.circular(5),
                                                //   child: Container(
                                                //     height: 15,
                                                //     width: 50,
                                                //     color: Colors.redAccent,
                                                //     child: Center(
                                                //       child: const Text(
                                                //         "สินค้าหมด",
                                                //         style: TextStyle(
                                                //             fontSize: 10,
                                                //             color: Colors.white),
                                                //       ),
                                                //     ),
                                                //   ),
                                                // )
                                                // สินค้าหมด Tag -------------------------------------
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
                          }),
                    ),
                  ),
            // ListView
            const SizedBox(
              height: 10,
            ),
          ]),
        ),
      ),
    );
  }
}

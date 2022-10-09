import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

// Model
import 'package:warehouse_mnmt/Page/Model/Product.dart';
import 'package:warehouse_mnmt/Page/Model/ProductLot.dart';
import 'package:warehouse_mnmt/Page/Model/Purchasing_item.dart';
import 'package:warehouse_mnmt/Page/Shop/Selling/nav_showProduct.dart';

import '../../../db/database.dart';
import '../../Model/ProductCategory.dart';
import '../../Model/ProductModel.dart';
import '../../Model/Selling_item.dart';
import '../../Model/Shop.dart';

class SellingNavChooseProduct extends StatefulWidget {
  final Shop shop;
  final ValueChanged<SellingItemModel> update;
  SellingNavChooseProduct({Key? key, required this.shop, required this.update})
      : super(key: key);

  @override
  State<SellingNavChooseProduct> createState() =>
      _SellingNavChooseProductState();
}

class _SellingNavChooseProductState extends State<SellingNavChooseProduct> {
  final searchController = TextEditingController();

  List<Product> products = [];
  List<ProductCategory> productCategorys = [];
  List<ProductModel> productModels = [];
  List<ProductLot> productLots = [];
  List<SellingItemModel> sellingItems = [];
  bool inCartIsVisible = false;
  bool outOfStockIsVisible = false;
  void initState() {
    super.initState();
    searchController.addListener(() => setState(() {}));
    refreshProducts();
  }

  Future refreshProducts() async {
    productCategorys = await DatabaseManager.instance
        .readAllProductCategorys(widget.shop.shopid!);
    products =
        await DatabaseManager.instance.readAllProducts(widget.shop.shopid!);
    productModels = await DatabaseManager.instance.readAllProductModels();
    productLots = await DatabaseManager.instance.readAllProductLots();
    setState(() {});
  }

  Future refreshProductLots() async {
    productLots = await DatabaseManager.instance.readAllProductLots();
    setState(() {});
  }

  addProductInCart(SellingItemModel sellingItems) {
    widget.update(sellingItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(160),
        child: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
          title: Column(
            children: const [
              Text(
                'เลือกสินค้า',
                style: TextStyle(fontSize: 25),
              )
            ],
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(30, 30, 65, 1.0),
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
                height: 70,
                child: TextFormField(
                    keyboardType: TextInputType.text,
                    onChanged: (text) async {
                      products = await DatabaseManager.instance
                          .readAllProductsByName(
                              widget.shop.shopid!, searchController.text);
                      setState(() {});
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                    controller: searchController,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    // cursorColor: primary_color,
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
                                refreshProducts();
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
                            var _amountOfProd = 0;
                            for (var prModel in productModels) {
                              if (prModel.prodId == product.prodId) {
                                cost.add(prModel.cost);
                                price.add(prModel.price);
                                for (var lot in productLots) {
                                  if (prModel.prodModelId == lot.prodModelId) {
                                    _amountOfProd += lot.amount!;
                                  }
                                }
                              }
                            }

                            var amountOfProd = _amountOfProd;
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
                              onPressed: () async {
                                amountOfProd == 0
                                    ? ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                        SnackBar(
                                          backgroundColor:
                                              Theme.of(context).backgroundColor,
                                          behavior: SnackBarBehavior.floating,
                                          content: Text("สินค้าหมด"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      )
                                    : await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SellingNavShowProd(
                                                    update: addProductInCart,
                                                    product: product)));
                                refreshProductLots();

                                setState(() {});
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
                                        amountOfProd == 0
                                            ? Row(
                                                children: [
                                                  Icon(
                                                    Icons.numbers_outlined,
                                                    color: Colors.white,
                                                  ),
                                                  Text('สินค้าหมด ',
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                      )),
                                                ],
                                              )
                                            : Container(
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
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          '${NumberFormat("#,###.##").format(amountOfProd)}',
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
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
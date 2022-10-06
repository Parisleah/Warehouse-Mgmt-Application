import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:warehouse_mnmt/Page/Component/theme/theme.dart';
import 'package:warehouse_mnmt/Page/Component/theme/theme.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel.dart';
import 'package:warehouse_mnmt/Page/Shop/Product/nav_add.dart';
import 'package:warehouse_mnmt/Page/Shop/Selling/nav_add.dart';
import 'package:warehouse_mnmt/db/database.dart';

import '../Component/TextField/CustomTextField.dart';
import '../Component/searchBox.dart';
import '../Component/searchBoxController.dart';
import '../Model/Product.dart';
import '../Model/ProductCategory.dart';
import '../Model/Shop.dart';
import 'Product/nav.edit.dart';

class ProductPage extends StatefulWidget {
  final Shop shop;
  const ProductPage({required this.shop, Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  TextEditingController searchProductController = TextEditingController();
  @override
  void initState() {
    super.initState();
    refreshProducts();
    refreshProductCategorys();

    setState(() {});
    searchProductController.addListener(() => setState(() {}));
  }

  List<Product> products = [];
  List<ProductCategory> productCategorys = [];
  List<ProductModel> productModels = [];

  bool _validate = false;
  Future refreshProducts() async {
    productModels = await DatabaseManager.instance.readAllProductModels();
    productCategorys = await DatabaseManager.instance
        .readAllProductCategorys(widget.shop.shopid!);
    products =
        await DatabaseManager.instance.readAllProducts(widget.shop.shopid!);
    setState(() {});
  }

  Future refreshProductCategorys() async {
    productCategorys = await DatabaseManager.instance
        .readAllProductCategorys(widget.shop.shopid!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(210),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Text(
                "สินค้า",
                textAlign: TextAlign.start,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: Text(
                      '${NumberFormat("#,###.##").format(products.length)}',
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Baseline(
                baseline: 120,
                baselineType: TextBaseline.alphabetic,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .background
                                .withOpacity(0.9),
                            borderRadius: BorderRadius.circular(15)),
                        width: 380,
                        height: 80,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                              keyboardType: TextInputType.text,
                              onChanged: (text) async {
                                products = await DatabaseManager.instance
                                    .readAllProductsByName(widget.shop.shopid!,
                                        searchProductController.text);
                                setState(() {});
                              },
                              // maxLength: length,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                              ],
                              controller: searchProductController,
                              //-----------------------------------------------------

                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                              cursorColor: primary_color,
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
                                    color:
                                        Theme.of(context).colorScheme.surface,
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
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                ),

                                hintText: 'ชื่อสินค้า',
                                hintStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                                prefixIcon: const Icon(Icons.search,
                                    color: Colors.white),
                                suffixIcon: searchProductController.text.isEmpty
                                    ? Container(
                                        width: 0,
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          searchProductController.clear();
                                          refreshProducts();
                                        },
                                        icon: const Icon(
                                          Icons.close_sharp,
                                          color: Colors.white,
                                        ),
                                      ),
                              )),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    productCategorys.isEmpty
                        ? Container(
                            width: 0,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  height: 50,
                                  width: 380,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .appBarTheme
                                        .backgroundColor,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Icon(
                                            //   Icons.category,
                                            //   color: Colors.white,
                                            // ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                'หมวดหมู่สินค้า',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: CircleAvatar(
                                                radius: 10,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                child: Text(
                                                    '${NumberFormat("#,###.##").format(productCategorys.length)}',
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 270,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.zero,
                                            itemCount: productCategorys.length,
                                            itemBuilder: (context, index) {
                                              final prodCateg =
                                                  productCategorys[index];
                                              return TextButton(
                                                onPressed: () async {
                                                  products = await DatabaseManager
                                                      .instance
                                                      .readAllProductsByCategory(
                                                          widget.shop.shopid!,
                                                          prodCateg
                                                              .prodCategId!);
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Center(
                                                      child: Text(
                                                        prodCateg.prodCategName,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                  ],
                )),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => ProductNavAdd(
                              shop: widget.shop,
                            )));
                refreshProducts();
              },
              icon: const Icon(
                Icons.add,
                size: 30,
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 800,
          decoration: BoxDecoration(gradient: scafBG_dark_Color),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 130,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        products.isEmpty
                            ? GestureDetector(
                                onVerticalDragStart: (detail) {
                                  refreshProducts();
                                },
                                child: Container(
                                  height: 490.0,
                                  width: 440.0,
                                  child: Center(
                                      child: Text(
                                    "(ไม่มีสินค้า${searchProductController.text.isEmpty ? '' : ' ' + searchProductController.text})",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 30),
                                  )),
                                ),
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
                                    onRefresh: refreshProducts,
                                    child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: products.length,
                                        itemBuilder: (context, index) {
                                          final product = products[index];
                                          var category;
                                          for (var prCategory
                                              in productCategorys) {
                                            if (product.prodCategId ==
                                                prCategory.prodCategId) {
                                              category = prCategory;
                                            }
                                          }

                                          var cost = [];
                                          var price = [];

                                          for (var prModel in productModels) {
                                            if (prModel.prodId ==
                                                product.prodId) {
                                              cost.add(prModel.cost);
                                              price.add(prModel.price);
                                              print(
                                                  ' + ${prModel.cost} +  ${prModel.price}');
                                            }
                                          }
                                          var _minCost = 0;
                                          var _maxCost = 0;
                                          var _minPrice = 0;
                                          var _maxPrice = 0;

                                          if (cost.isNotEmpty &&
                                              price.isNotEmpty) {
                                            var minCost = cost.reduce(
                                                (curr, next) =>
                                                    curr < next ? curr : next);
                                            var maxCost = cost.reduce(
                                                (curr, next) =>
                                                    curr > next ? curr : next);
                                            var minprice = price.reduce(
                                                (curr, next) =>
                                                    curr < next ? curr : next);
                                            var maxprice = price.reduce(
                                                (curr, next) =>
                                                    curr > next ? curr : next);
                                            _minCost = minCost;
                                            _maxCost = maxCost;
                                            _minPrice = minprice;
                                            _maxPrice = maxprice;
                                          }

                                          return Dismissible(
                                            key: Key(products[index].prodName),
                                            onDismissed: (direction) async {
                                              await DatabaseManager.instance
                                                  .deleteProduct(
                                                      product.prodId!);
                                              refreshProducts();
                                              setState(() {});
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor:
                                                    Colors.redAccent,
                                                content: Text(
                                                    "ลบสินค้า ${product.prodName}"),
                                                duration: Duration(seconds: 2),
                                              ));
                                            },
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
                                            direction:
                                                DismissDirection.endToStart,
                                            resizeDuration:
                                                Duration(seconds: 1),
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductNavEdit(
                                                              product: product,
                                                              prodCategory:
                                                                  category,
                                                              shop: widget.shop,
                                                            )));
                                              },
                                              child: Container(
                                                // decoration: BoxDecoration(
                                                //   boxShadow: [
                                                //     BoxShadow(
                                                //         color: Colors.black,
                                                //         spreadRadius: 1,
                                                //         blurRadius: 5,
                                                //         offset: Offset(0, 4))
                                                //   ],
                                                // ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    ),
                                                    height: 90,
                                                    width: 400,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          width: 90,
                                                          height: 90,
                                                          child: Image.file(
                                                            File(product
                                                                .prodImage!),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
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
                                                                product
                                                                    .prodName,
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .secondary,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          2.0),
                                                                  child: Text(
                                                                    category ==
                                                                            null
                                                                        ? "ไม่มีหมวดหมู่สินค้า"
                                                                        : category
                                                                            .prodCategName,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                  'ต้นทุน ${NumberFormat("#,###.##").format(_minCost)} - ${NumberFormat("#,###.##").format(_maxCost)}',
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          12)),
                                                              Text(
                                                                  'ราคา ${NumberFormat("#,###.##").format(_minPrice)} - ${NumberFormat("#,###.##").format(_maxPrice)}',
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12)),
                                                            ],
                                                          ),
                                                        ),
                                                        CircleAvatar(
                                                          radius: 15,
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                          child: Text(
                                                              '${NumberFormat("#,###.##").format(product.prodId)}',
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        // Delete Product
                                                        const Icon(
                                                            Icons
                                                                .more_vert_outlined,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    205,
                                                                    205,
                                                                    205)),
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
                              )
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

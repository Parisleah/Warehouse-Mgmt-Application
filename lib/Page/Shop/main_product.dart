import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:warehouse_mnmt/Page/Component/theme/theme.dart';
import 'package:warehouse_mnmt/Page/Component/theme/theme.dart';
import 'package:warehouse_mnmt/Page/Shop/Product/nav_add.dart';
import 'package:warehouse_mnmt/Page/Shop/Selling/nav_add.dart';
import 'package:warehouse_mnmt/db/database.dart';

import '../Component/TextField/CustomTextField.dart';
import '../Component/searchBox.dart';
import '../Component/searchBoxController.dart';
import '../Model/Product.dart';
import '../Model/ProductCategory.dart';
import '../Model/Shop.dart';

class ProductPage extends StatefulWidget {
  final Shop shop;
  const ProductPage({required this.shop, Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    refreshProducts();
    refreshProductCategorys();
    setState(() {});
  }

  TextEditingController searchProductController = TextEditingController();
  List<Product> products = [];
  List<ProductCategory> productCategorys = [];
  bool _validate = false;
  Future refreshProducts() async {
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
    TextTheme _textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(155),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "สินค้า",
            textAlign: TextAlign.start,
          ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Baseline(
                baseline: 120,
                baselineType: TextBaseline.alphabetic,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                                        onPressed: () =>
                                            searchProductController.clear(),
                                        icon: const Icon(
                                          Icons.close_sharp,
                                          color: Colors.white,
                                        ),
                                      ),
                              )),
                        )),
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
      body: Container(
        // decoration: BoxDecoration(gradient: scafBG_dark_Color),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 150,
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
                      products.isEmpty
                          ? RefreshIndicator(
                              onRefresh: refreshProducts,
                              child: Center(
                                  child: Text(
                                "(พื้นที่วาง Widget)",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 30),
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
                                            category = prCategory.prodCategName;
                                          }
                                        }

                                        return Dismissible(
                                          key: Key(products[index].prodName),
                                          onDismissed: (direction) async {
                                            await DatabaseManager.instance
                                                .deleteProduct(product.prodId!);
                                            refreshProducts();
                                            setState(() {});
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              backgroundColor: Colors.redAccent,
                                              content: Text(
                                                  "ลบสินค้า ${product.prodName}"),
                                              duration: Duration(seconds: 3),
                                            ));
                                          },
                                          background: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: const [
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
                                          resizeDuration: Duration(seconds: 1),
                                          child: TextButton(
                                            onPressed: () {
                                              // Navigator.of(context).push(
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             productNavEdit(
                                              //                 product: product)));
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 0.0,
                                                  horizontal: 0.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Container(
                                                  height: 90,
                                                  width: 400,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
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
                                                              product.prodName,
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
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        2.0),
                                                                child: Text(
                                                                  category ==
                                                                          null
                                                                      ? ""
                                                                      : category,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                                'ต้นทุน ${NumberFormat("#,###.##").format(product.prodId)}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        12)),
                                                            Text(
                                                                'ราคา ${NumberFormat("#,###.##").format(product.prodCategId)}',
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
                                                        backgroundColor: Theme
                                                                .of(context)
                                                            .backgroundColor,
                                                        child: Text(
                                                            '${NumberFormat("#,###.##").format(product.shopId)}',
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
                                                          color: Color.fromARGB(
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
    );
  }
}

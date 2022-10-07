import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:warehouse_mnmt/Page/Model/Dealer.dart';
import 'package:warehouse_mnmt/Page/Model/Product.dart';
import 'package:warehouse_mnmt/Page/Model/ProductLot.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel.dart';
import 'package:warehouse_mnmt/Page/Model/Purchasing.dart';
import 'package:warehouse_mnmt/Page/Model/Purchasing_item.dart';

import '../../../db/database.dart';
import '../../Model/Shop.dart';
import 'nav_choose_dealer.dart';
import 'nav_choose_product.dart';
import 'nav_choose_shipping.dart';

class BuyingNavAdd extends StatefulWidget {
  final Shop shop;
  const BuyingNavAdd({super.key, required this.shop});
  @override
  State<BuyingNavAdd> createState() => _BuyingNavAddState();
}

class _BuyingNavAddState extends State<BuyingNavAdd> {
  List<PurchasingItemsModel> cart = [];
  List<Product> products = [];
  List<ProductModel> models = [];
  DateTime date = DateTime.now();
  final df = new DateFormat('dd-MM-yyyy hh:mm a');
  DealerModel _dealer =
      DealerModel(dName: 'ยังไม่ระบุตัวแทนจำหน่าย', dAddress: '', dPhone: '');
  String _shipping = 'ระบุการจัดส่ง';
  var shippingCost = 0;
  var totalPrice = 0;
  var noShippingPrice = 0;
  var amount = 0;
  bool isReceived = false;
  final shipPricController = TextEditingController();
  final specReqController = TextEditingController();
  void initState() {
    super.initState();
    specReqController.addListener(() => setState(() {}));
    shipPricController.addListener(() => setState(() {}));
    refreshProducts();
  }

  Future refreshProducts() async {
    products =
        await DatabaseManager.instance.readAllProducts(widget.shop.shopid!);

    models = await DatabaseManager.instance.readAllProductModels();
    setState(() {});
  }

  _showDialog(title) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).backgroundColor,
      content: Text(title),
      duration: Duration(seconds: 2),
    ));
  }

  _updateDealer(DealerModel dealer) {
    setState(() {
      _dealer = dealer;
    });
  }

  _updateShipping(shipping) {
    setState(() {
      _shipping = shipping;
    });
  }

  _addProductInCart(PurchasingItemsModel product) {
    cart.add(product);
    print('Cart (${cart.length}) -> ${cart}');
  }

  _calculate(oldTotal, oldAmount, oldShippingPrice, oldNoShippingPrice) {
    oldTotal = 0;
    oldAmount = 0;
    oldNoShippingPrice = 0;
    for (var i in cart) {
      oldTotal += i.total;
      oldAmount += i.amount;
    }

    totalPrice = oldTotal + oldShippingPrice;
    amount = oldAmount;
    shippingCost = oldShippingPrice;
    noShippingPrice = oldTotal;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
          title: Column(
            children: const [
              Text(
                "เพิ่มการสั่งซื้อ",
                style: TextStyle(fontSize: 25),
              )
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert_outlined),
            )
          ],
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              const SizedBox(
                height: 90,
              ),
              // Date Picker
              Container(
                width: 440,
                height: 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(56, 48, 77, 1.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month),
                        Spacer(),
                        Text('${date.day}/${date.month}/${date.year}')
                      ],
                    ),
                  ),
                  onPressed: () async {
                    DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        builder: (context, child) => Theme(
                              data: ThemeData().copyWith(
                                colorScheme: ColorScheme.dark(
                                  primary: Colors.white,
                                  onPrimary: Theme.of(context).backgroundColor,
                                  surface: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  onSurface: Colors.white,
                                ),
                                dialogBackgroundColor:
                                    Theme.of(context).colorScheme.background,
                              ),
                              child: child!,
                            ));
                    // 'Cancel' => null
                    if (newDate == null) return;

                    // 'OK' => DateTime
                    setState(() => date = newDate);
                  },
                ),
              ),
              Row(
                children: [
                  Text(
                    "ตัวแทนจำหน่าย",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              Row(children: [
                Container(
                  width: 370,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(56, 48, 77, 1.0),
                      borderRadius: BorderRadius.circular(15)),
                  child: GestureDetector(
                    onTap: (() {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => BuyingNavChooseDealer(
                                    update: _updateDealer,
                                  )));
                    }),
                    child: Row(children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(_dealer.dName,
                            style: TextStyle(fontSize: 15, color: Colors.grey)),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ]),
                  ),
                ),
              ]),

              // Container of เลือกลูกค้า
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "รายการสั่งซื้อ",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // Container of รายการสินค้า
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(56, 48, 77, 1.0),
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).backgroundColor),
                      onPressed: () async {
                        totalPrice = 0;
                        amount = 0;
                        setState(() {});
                        await Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => BuyiingNavChooseProduct(
                                      shop: widget.shop,
                                      update: _addProductInCart,
                                    )));
                        _calculate(
                            totalPrice, amount, shippingCost, noShippingPrice);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.add), Text("เลือกสินค้า")],
                      ),
                    ),
                    // ListView
                    cart.isEmpty
                        ? Container(
                            width: 0,
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: cart.isEmpty
                                ? Container(
                                    width: 400,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: Color.fromRGBO(37, 35, 53, 1.0),
                                    ),
                                    child: Center(
                                        child: Text(
                                      'ไม่มีสินค้า',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 25),
                                    )),
                                  )
                                : Container(
                                    height: 224.0,
                                    width: 440.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: Color.fromRGBO(37, 35, 53, 1.0),
                                    ),
                                    child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: cart.length,
                                        itemBuilder: (context, index) {
                                          final purchasing = cart[index];
                                          var prodName;
                                          var prodImg;
                                          var prodModel;
                                          for (var prod in products) {
                                            if (prod.prodId ==
                                                purchasing.prodModelId) {
                                              prodImg = prod.prodImage;
                                              prodName = prod.prodName;
                                            }
                                          }

                                          var stProperty;
                                          var ndProperty;

                                          for (var model in models) {
                                            if (model.prodModelId ==
                                                purchasing.prodModelId) {
                                              stProperty = model.stProperty;
                                              ndProperty = model.ndProperty;
                                            }
                                          }

                                          return Dismissible(
                                            key: UniqueKey(),
                                            onDismissed: (direction) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor:
                                                    Colors.redAccent,
                                                content: Container(
                                                    child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      child: Container(
                                                        width: 20,
                                                        height: 20,
                                                        child: Image.file(
                                                          File(prodImg),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(" ลบสินค้า"),
                                                    Text(
                                                      ' ${prodName}',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                )),
                                                duration: Duration(seconds: 5),
                                              ));
                                              cart.remove(purchasing);
                                              setState(() {});
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
                                                // Navigator.of(context).push(MaterialPageRoute(
                                                //     builder: (context) => sellingNavShowProd(
                                                //         product: product)));
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0.0,
                                                    horizontal: 0.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    height: 80,
                                                    width: 400,
                                                    color: Color.fromRGBO(
                                                        56, 54, 76, 1.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          width: 90,
                                                          height: 90,
                                                          child: Image.file(
                                                            File(prodImg),
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
                                                                '${prodName}',
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                        // Theme.of(context)
                                                                        //       .colorScheme
                                                                        //       .background
                                                                        color: Color.fromRGBO(36, 33, 50, 1.0),
                                                                        borderRadius: BorderRadius.circular(10)),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              3.0),
                                                                      child:
                                                                          Text(
                                                                        stProperty,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Color.fromRGBO(
                                                                            36,
                                                                            33,
                                                                            50,
                                                                            1.0),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              3.0),
                                                                      child:
                                                                          Text(
                                                                        ndProperty,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Text(
                                                                  'ราคา ${NumberFormat("#,###.##").format(purchasing.total)}',
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          12)),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      30,
                                                                      30,
                                                                      49,
                                                                      1.0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: Text(
                                                                '${NumberFormat("#,###.##").format(purchasing.amount)}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .backgroundColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                        ),
                                                        const Icon(
                                                            Icons
                                                                .arrow_forward_ios,
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
                    // ListView
                    cart.isEmpty
                        ? Container(
                            width: 10,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'รายการสั่งซื้อทั้งหมด ',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(30, 30, 49, 1.0),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                      '${NumberFormat("#,###.##").format(cart.length)}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color:
                                              Theme.of(context).backgroundColor,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                  ]),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "การจัดส่ง",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ],
              ),
              // Container of รายการสินค้า
              const SizedBox(
                height: 10,
              ),
              // Container of การจัดส่ง
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(56, 48, 77, 1.0),
                    borderRadius: BorderRadius.circular(15)),
                width: 400,
                height: 70,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: const Text("การจัดส่ง",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                  Spacer(),
                  Text(_shipping,
                      style: TextStyle(fontSize: 15, color: Colors.grey)),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => ChooseShippingNav(
                                    update: _updateShipping,
                                  )));
                    },
                  ),
                ]),
              ),
              // Container of การจัดส่ง
              const SizedBox(
                height: 10,
              ),
              // Container of ค่าจัดส่ง
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(56, 48, 77, 1.0),
                    borderRadius: BorderRadius.circular(15)),
                width: 400,
                height: 70,
                child: TextField(
                    onChanged: (text) {
                      _calculate(
                          totalPrice,
                          amount,
                          int.parse(
                            shipPricController.text,
                          ),
                          noShippingPrice);
                    },
                    textAlign: TextAlign.end,
                    // inputFormatters: [DecimalFormatter()],
                    keyboardType: TextInputType.number,
                    //-----------------------------------------------------
                    style: const TextStyle(color: Colors.grey),
                    controller: shipPricController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none),
                      hintText: "ใส่ค่าจัดส่ง",
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
                      prefixIcon:
                          const Icon(Icons.local_shipping, color: Colors.white),
                      suffixIcon: !shipPricController.text.isEmpty
                          ? IconButton(
                              onPressed: () {
                                shipPricController.clear();
                                shippingCost = 0;
                                _calculate(totalPrice, amount, shippingCost,
                                    noShippingPrice);
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.close_sharp,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    )),
              ),
              // Container of ค่าจัดส่ง

              const SizedBox(
                height: 10,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "สรุปรายการสั่งซื้อ",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              // Container of จำนวน
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(56, 48, 77, 1.0),
                    borderRadius: BorderRadius.circular(15)),
                width: 400,
                height: 70,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: const Text("จำนวน",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                        '${NumberFormat("#,###,###,### ชิ้น").format(amount)}',
                        textAlign: TextAlign.left,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey)),
                  ),
                ]),
              ),
              // Container of จำนวน
              const SizedBox(
                height: 10,
              ),
              // Container of รวม
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(56, 48, 77, 1.0),
                    borderRadius: BorderRadius.circular(15)),
                width: 400,
                height: 70,
                child: Wrap(
                  children: [
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: const Text("รวม",
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                      ),
                      Spacer(),
                      Column(
                        children: [
                          shippingCost == 0
                              ? Container(
                                  width: 0,
                                )
                              : Text(
                                  'สินค้า(${NumberFormat("#,###,###,###.##").format(noShippingPrice)})',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.grey)),
                          shippingCost == 0
                              ? Container(
                                  width: 0,
                                )
                              : Text(
                                  '   + ค่าส่ง (${NumberFormat("#,###,###,###.##").format(shippingCost)})',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color:
                                          Theme.of(context).backgroundColor)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                            '${NumberFormat("#,###,###,###.##").format(totalPrice)}',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.grey)),
                      ),
                    ]),
                  ],
                ),
              ),
              // Container of รวม
              const SizedBox(
                height: 10,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: InkWell(
                    onTap: () {
                      setState(() {
                        isReceived = !isReceived;
                        if (isReceived == false) {
                          print('ยังไม่ได้รับสินค้า');
                        } else {
                          print('ได้รับสินค้าแล้ว');
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.transparent),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: isReceived
                            ? Icon(
                                Icons.check_box,
                                size: 40.0,
                                color: Theme.of(context).backgroundColor,
                              )
                            : Icon(
                                Icons.check_box_outline_blank,
                                size: 40.0,
                                color: Theme.of(context).backgroundColor,
                              ),
                      ),
                    ),
                  )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ได้รับสินค้าเรียบร้อยแล้ว",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "(สินค้าคงเหลือจะได้รับการปรับปรุง)",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(children: [
                      ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(primary: Colors.redAccent),
                        onPressed: () {},
                        child: Text(
                          "ยกเลิก",
                          style: TextStyle(fontSize: 17),
                        ),
                      )
                    ]),
                    Column(children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_dealer.dName == 'ยังไม่ระบุตัวแทนจำหน่าย') {
                            _showDialog('โปรดระบุตัวแทนจำหน่าย');
                          } else if (cart.isEmpty || cart.length == 0) {
                            _showDialog('รายการสั่งซื้อว่าง');
                          } else {
                            // Purchasing
                            final purchased = PurchasingModel(
                                orderedDate: date,
                                dealerId: _dealer.dealerId!,
                                shippingCost: shippingCost,
                                amount: amount,
                                total: totalPrice,
                                isReceive: isReceived,
                                shopId: widget.shop.shopid!);
                            await DatabaseManager.instance
                                .createPurchasing(purchased);
                            // items
                            for (var cartIndex in cart) {
                              final item = PurchasingItemsModel(
                                  prodModelId: cartIndex.prodModelId,
                                  amount: cartIndex.amount,
                                  total: cartIndex.total);
                              final productLot = ProductLot(
                                  orderedTime: date,
                                  amount: amount,
                                  remainAmount: amount,
                                  prodModelId: cartIndex.prodModelId);
                              await DatabaseManager.instance
                                  .createPurchasingItem(item);
                              await DatabaseManager.instance
                                  .createProductLot(productLot);
                            }
                            // Product Lot
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              behavior: SnackBarBehavior.floating,
                              content: Row(
                                children: [
                                  Text(
                                      "ทำรายการเสร็จสิ้น ยอด${NumberFormat("#,###,###.##").format(purchased.total)} ${df.format(date)} "),
                                ],
                              ),
                              duration: Duration(seconds: 5),
                            ));
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "เพิ่ม",
                          style: TextStyle(fontSize: 17),
                        ),
                      )
                    ]),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

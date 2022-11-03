import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:warehouse_mnmt/Page/Model/Customer.dart';
import 'package:warehouse_mnmt/Page/Model/CustomerAdress.dart';
import 'package:warehouse_mnmt/Page/Model/Product.dart';
import 'package:warehouse_mnmt/Page/Model/ProductLot.dart';
import 'package:warehouse_mnmt/Page/Model/Selling.dart';
import 'package:warehouse_mnmt/Page/Model/Selling_item.dart';
import 'package:warehouse_mnmt/Page/Shop/Buying/nav_choose_shipping.dart';
import 'package:warehouse_mnmt/Page/Shop/Selling/selling_nav_chooseCustomer.dart';
import 'package:warehouse_mnmt/Page/Shop/Selling/nav_choose_product.dart';
import 'package:warehouse_mnmt/db/database.dart';

import '../../Component/DatePicker.dart';
import '../../Model/ProductModel.dart';
import '../../Model/Shop.dart';

class SellingNavAdd extends StatefulWidget {
  final Shop shop;
  const SellingNavAdd({required this.shop, Key? key}) : super(key: key);

  @override
  State<SellingNavAdd> createState() => _SellingNavAddState();
}

class _SellingNavAddState extends State<SellingNavAdd> {
  TextEditingController shipPricController = TextEditingController();
  TextEditingController specReqController = TextEditingController();
  TextEditingController discountPercentController = TextEditingController();
  CustomerModel _customer = CustomerModel(cName: 'ยังไม่ระบุลูกค้า');
  CustomerAddressModel _address = CustomerAddressModel(
    cAddress: 'ที่อยู่',
    cPhone: 'เบอร์โทร',
  );
  String _shipping = 'ระบุการจัดส่ง';
  DateTime date = DateTime.now();
  final df = new DateFormat('dd-MM-yyyy hh:mm a');

  var shippingCost = 0;
  var showtotalPrice = 0;
  var totalPrice = 0;
  var noShippingPrice = 0;
  var amount = 0;
  var discountPercent = 0;
  var discountPercentPrice = 0;
  double vat7percent = 0.0;
  double noVatPrice = 0.0;
  bool isDelivered = false;
  List<Product> products = [];
  List<ProductModel> models = [];
  List<ProductLot> lots = [];
  List<SellingItemModel> carts = [];
  List<ProductLot> productLots = [];

  _addSellingItem(SellingItemModel product) {
    // for (var item in carts) {
    //   if (carts.isNotEmpty) {
    //     if (item.prodModelId == product.prodModelId) {
    //       carts[carts.indexWhere(
    //               (element) => element.prodModelId == product.prodModelId)]
    //           .copy(amount: item.amount + product.amount);

    //       setState(() {});
    //     }
    //   } else {
    //     carts.add(product);
    //   }
    // }
    carts.add(product);
  }

  @override
  void initState() {
    super.initState();
    refreshProducts();
    shipPricController.addListener(() => setState(() {}));
    shipPricController.addListener(() => setState(() {}));
    specReqController.addListener(() => setState(() {}));
  }

  Future refreshProducts() async {
    products =
        await DatabaseManager.instance.readAllProducts(widget.shop.shopid!);
    productLots = await DatabaseManager.instance.readAllProductLots();
    models = await DatabaseManager.instance.readAllProductModels();
    lots = await DatabaseManager.instance.readAllProductLots();
    setState(() {});
  }

  _updateCustomer(CustomerModel customer) {
    setState(() {
      _customer = customer;
    });
  }

  _updateCustomerAddress(CustomerAddressModel address) {
    setState(() {
      _address = address;
    });
  }

  _updateShipping(shipping) {
    setState(() {
      _shipping = shipping;
    });
  }

  _calculate(
      oldTotal,
      oldAmount,
      oldShippingPrice,
      oldNoShippingPrice,
      oldvat7percent,
      oldNoVatPrice,
      oldDiscountPercent,
      oldDiscountPercentPrice) {
    oldTotal = 0;
    oldAmount = 0;
    oldNoShippingPrice = 0;
    oldvat7percent = 0;
    oldNoVatPrice = 0;

    oldDiscountPercentPrice = 0;
    for (var i in carts) {
      oldTotal += i.total;
      oldAmount += i.amount;
    }
    // discount
    discountPercent = oldDiscountPercent;
    discountPercentPrice = (oldTotal * oldDiscountPercent / 100).toInt();
    print('% ${discountPercent}');
    print('Discount -> ${discountPercentPrice}');

    totalPrice = oldTotal - discountPercentPrice;
    showtotalPrice = oldTotal + oldShippingPrice - discountPercentPrice;
    amount = oldAmount;
    shippingCost = oldShippingPrice;
    noShippingPrice = oldTotal;
    vat7percent = oldTotal * 7 / 100;
    noVatPrice = oldTotal - vat7percent;

    setState(() {});
  }

  _showAlertSnackBar(title) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).backgroundColor,
      content: Text(title),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),

            // Return Back Selling Items Remaining Amount
            onPressed: () async {
              if (carts.isNotEmpty) {
                // for (var item in carts) {
                //   for (var lot in productLots) {
                //     if (item.prodLotId == lot.prodLotId) {
                //       final updateAmountSelectedProductLot = lot.copy(
                //           remainAmount: lot.remainAmount + item.amount);
                //       await DatabaseManager.instance
                //           .updateProductLot(updateAmountSelectedProductLot);
                //     }
                //   }
                // }
                for (var i = 0; carts.length > i; i++) {
                  for (var lot in productLots) {
                    if (carts[i].prodLotId == lot.prodLotId) {
                      final updateAmountSelectedProductLot = lot.copy(
                          remainAmount: lot.remainAmount + carts[i].amount);
                      await DatabaseManager.instance
                          .updateProductLot(updateAmountSelectedProductLot);
                    }
                  }
                }
                ;
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
          title: Column(
            children: [
              Text(
                "เพิ่มรายการขาย",
                style: TextStyle(fontSize: 25),
              )
            ],
          ),
          centerTitle: true,
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
              const SizedBox(
                height: 10,
              ),
              // Container of ราคาขายรวม
              Row(
                children: [
                  Text(
                    "ลูกค้า",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // Container of เลือกลูกค้า
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => SellingNavChooseCustomer(
                                shop: widget.shop,
                                updateCustomer: _updateCustomer,
                                updateCustomerAddress: _updateCustomerAddress,
                              )));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(56, 48, 77, 1.0),
                      borderRadius: BorderRadius.circular(15)),
                  width: 400,
                  height: _customer.cName == 'ยังไม่ระบุลูกค้า' ? 80 : 100,
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(_customer.cName,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          _customer.cName == 'ยังไม่ระบุลูกค้า'
                                              ? Colors.grey
                                              : Colors.white)),
                              SizedBox(
                                width: 10,
                              ),
                              _customer.cName == 'ยังไม่ระบุลูกค้า'
                                  ? Container(
                                      width: 0,
                                    )
                                  : Text(
                                      '(${_address.cPhone.replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d+)'), (Match m) => "${m[1]}-${m[2]}-${m[3]}")})',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: _customer.cName ==
                                                  'ยังไม่ระบุลูกค้า'
                                              ? Colors.grey
                                              : Colors.white)),
                            ],
                          ),
                          _customer.cName == 'ยังไม่ระบุลูกค้า'
                              ? Container(
                                  width: 0,
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_address.cAddress,
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.grey)),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    const SizedBox(
                      width: 10,
                    )
                  ]),
                ),
              ),
              // Container of เลือกลูกค้า
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "รายการสินค้า",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // Container of รายการสินค้า
              Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(56, 48, 77, 1.0),
                    borderRadius: BorderRadius.circular(15)),
                width: 440,
                height: carts.isEmpty ? 70 : 340,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => SellingNavChooseProduct(
                                      shop: widget.shop,
                                      update: _addSellingItem,
                                    )));
                        refreshProducts();

                        _calculate(
                            totalPrice,
                            amount,
                            shippingCost,
                            noShippingPrice,
                            vat7percent,
                            noVatPrice,
                            discountPercent,
                            discountPercentPrice);

                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          Text("เลือกสินค้า"),
                        ],
                      ),
                    ),
                    // ListView
                    carts.isEmpty
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              height: 224.0,
                              width: 440.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Color.fromRGBO(37, 35, 53, 1.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  carts.isEmpty
                                      ? const Text(
                                          '(ไม่มีสินค้า)',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        )
                                      : Container(
                                          height: 224.0,
                                          width: 440.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color:
                                                Color.fromRGBO(37, 35, 53, 1.0),
                                          ),
                                          child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              itemCount: carts.length,
                                              itemBuilder: (context, index) {
                                                final selling = carts[index];
                                                var prodName;
                                                var prodImg;
                                                var prodModel;
                                                for (var prod in products) {
                                                  if (prod.prodId ==
                                                      selling.prodId) {
                                                    prodImg = prod.prodImage!;
                                                    prodName = prod.prodName;
                                                  }
                                                }

                                                var stProperty;
                                                var ndProperty;

                                                for (var model in models) {
                                                  if (model.prodModelId ==
                                                      selling.prodModelId) {
                                                    stProperty =
                                                        model.stProperty;
                                                    ndProperty =
                                                        model.ndProperty;
                                                  }
                                                }

                                                return Dismissible(
                                                  key: UniqueKey(),
                                                  onDismissed:
                                                      (direction) async {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      content: Container(
                                                          child: Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            child: Container(
                                                              width: 20,
                                                              height: 20,
                                                              child: Image.file(
                                                                File(prodImg),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(" ลบสินค้า"),
                                                          Text(
                                                            ' ${prodName}',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      )),
                                                      duration:
                                                          Duration(seconds: 1),
                                                    ));
                                                    carts.remove(selling);
                                                    for (var lot in lots) {
                                                      if (lot.prodLotId ==
                                                          selling.prodLotId) {
                                                        final updateAmountDeletedProductLot =
                                                            lot.copy(
                                                                remainAmount: selling!
                                                                        .amount +
                                                                    lot.remainAmount);

                                                        await DatabaseManager
                                                            .instance
                                                            .updateProductLot(
                                                                updateAmountDeletedProductLot);
                                                      }
                                                    }
                                                    _calculate(
                                                        totalPrice,
                                                        amount,
                                                        shipPricController.text
                                                                    .isEmpty ||
                                                                shipPricController
                                                                        .text ==
                                                                    null
                                                            ? 0
                                                            : double.parse(
                                                                shipPricController
                                                                    .text,
                                                              ).toInt(),
                                                        noShippingPrice,
                                                        vat7percent,
                                                        noVatPrice,
                                                        discountPercentController
                                                                    .text
                                                                    .isEmpty ||
                                                                discountPercentController
                                                                        .text ==
                                                                    null
                                                            ? 0
                                                            : double.parse(
                                                                discountPercentController
                                                                    .text,
                                                              ).toInt(),
                                                        discountPercentPrice);

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
                                                            BorderRadius
                                                                .circular(10)),
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
                                                  direction: DismissDirection
                                                      .endToStart,
                                                  resizeDuration:
                                                      Duration(seconds: 1),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      // Navigator.of(context).push(MaterialPageRoute(
                                                      //     builder: (context) => sellingNavShowProd(
                                                      //         product: product)));
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 0.0,
                                                              horizontal: 0.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
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
                                                                child:
                                                                    Image.file(
                                                                  File(
                                                                      prodImg!),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 10),
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      '${prodName}',
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.white),
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
                                                                                const EdgeInsets.all(3.0),
                                                                            child:
                                                                                Text(
                                                                              stProperty,
                                                                              style: const TextStyle(fontSize: 12, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                              color: Color.fromRGBO(36, 33, 50, 1.0),
                                                                              borderRadius: BorderRadius.circular(10)),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(3.0),
                                                                            child:
                                                                                Text(
                                                                              ndProperty,
                                                                              style: const TextStyle(fontSize: 12, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Text(
                                                                        'ราคา ${NumberFormat("#,###.##").format(selling.total)}',
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.grey,
                                                                            fontSize: 12)),
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
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          3.0),
                                                                  child: Text(
                                                                      '${NumberFormat("#,###.##").format(selling.amount)}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color: Theme.of(context)
                                                                              .backgroundColor,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        )
                                ],
                              ),
                            ),
                          ),
                    // ListView
                    SizedBox(
                      height: 5,
                    ),
                    carts.isEmpty
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "จำนวนทั้งหมด",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor:
                                      Color.fromRGBO(30, 30, 49, 1.0),
                                  child: Text(
                                      '${NumberFormat("#,###").format(carts.length)}',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.greenAccent,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          )
                  ]),
                ),
              ),
              // Container of รายการสินค้า
              const SizedBox(
                height: 10,
              ),
              // Container of การจัดส่ง
              GestureDetector(
                onTap: (() {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => ChooseShippingNav(
                                update: _updateShipping,
                              )));
                }),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(56, 48, 77, 1.0),
                      borderRadius: BorderRadius.circular(15)),
                  width: 400,
                  height: 70,
                  child: Row(children: [
                    const Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("การจัดส่ง",
                          style: TextStyle(fontSize: 15, color: Colors.white)),
                    ),
                    const Spacer(),
                    Text(_shipping,
                        style: TextStyle(fontSize: 15, color: Colors.grey)),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    const SizedBox(
                      width: 10,
                    ),
                  ]),
                ),
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
                    onChanged: ((value) {
                      if (shipPricController.text.isNotEmpty &&
                          shipPricController.text != null) {
                        _calculate(
                            totalPrice,
                            amount,
                            double.parse(
                              shipPricController.text,
                            ).toInt(),
                            noShippingPrice,
                            vat7percent,
                            noVatPrice,
                            discountPercent,
                            discountPercentPrice);
                      } else {
                        shippingCost = 0;
                      }
                    }),
                    textAlign: TextAlign.end,
                    keyboardType: TextInputType.number,
                    onSubmitted: (context) {
                      // if (shipPricController.text.isEmpty == true) {
                      //   _calculateShip(0.0);
                      // } else {
                      //   _calculateShip(double.parse(shipPricController.text));
                      // }
                    },
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
                                shippingCost = 0;
                                shipPricController.clear();
                                _calculate(
                                    totalPrice,
                                    amount,
                                    shippingCost,
                                    noShippingPrice,
                                    vat7percent,
                                    noVatPrice,
                                    discountPercent,
                                    discountPercentPrice);
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
              // Container of ราคาสุทธิ
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(56, 48, 77, 1.0),
                    borderRadius: BorderRadius.circular(15)),
                width: 400,
                height: 70,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: const Text("ราคาสินค้า",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                        //หัก 7%(${NumberFormat("#,###.##").format(noVatPrice)})
                        '${NumberFormat("#,###.##").format(noShippingPrice - vat7percent)}',
                        textAlign: TextAlign.left,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey)),
                  ),
                ]),
              ),
              // Container of ราคาสุทธิ
              const SizedBox(
                height: 10,
              ),
              // Container of ภาษี 7 %
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(56, 48, 77, 1.0),
                    borderRadius: BorderRadius.circular(15)),
                width: 400,
                height: 70,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: const Text("ภาษี (7%)",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                        '${NumberFormat("#,###.##").format(vat7percent)}',
                        textAlign: TextAlign.left,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey)),
                  ),
                ]),
              ),
              // Container of ภาษี 7 %
              const SizedBox(
                height: 10,
              ),
              // Container of ภาษี 7 %
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(56, 48, 77, 1.0),
                    borderRadius: BorderRadius.circular(15)),
                width: 400,
                height: 70,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: const Text("ราคารวม",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                        '${NumberFormat("#,###.##").format(noShippingPrice)}',
                        textAlign: TextAlign.left,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey)),
                  ),
                ]),
              ),
              // Container of ส่วนลด
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(56, 48, 77, 1.0),
                    borderRadius: BorderRadius.circular(15)),
                width: 400,
                height: 70,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    const Icon(Icons.discount_rounded, color: Colors.white),
                    Text(" % ส่วนลด ",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    const Spacer(),
                    Container(
                      width: 150,
                      height: 70,
                      child: TextField(
                          onChanged: ((value) {
                            if (discountPercentController.text.isNotEmpty &&
                                discountPercentController.text != null) {
                              if (double.parse(discountPercentController.text)
                                      .toInt() >
                                  100) {
                                discountPercentController.clear();
                                setState(() {});
                              } else {
                                _calculate(
                                    totalPrice,
                                    amount,
                                    shipPricController.text.isEmpty
                                        ? 0
                                        : int.parse(
                                            shipPricController.text,
                                          ).toInt(),
                                    noShippingPrice,
                                    vat7percent,
                                    noVatPrice,
                                    double.parse(
                                      discountPercentController.text,
                                    ).toInt(),
                                    discountPercentPrice);
                              }
                            }
                          }),
                          textAlign: TextAlign.end,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(3),
                          ],
                          onSubmitted: (context) {
                            // if (shipPricController.text.isEmpty == true) {
                            //   _calculateShip(0.0);
                            // } else {
                            //   _calculateShip(double.parse(shipPricController.text));
                            // }
                          },
                          //-----------------------------------------------------
                          style: const TextStyle(color: Colors.grey),
                          controller: discountPercentController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide.none),
                            hintText: "%",
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                            suffixIcon: !discountPercentController.text.isEmpty
                                ? IconButton(
                                    onPressed: () {
                                      discountPercentController.clear();
                                      discountPercent = 0;
                                      _calculate(
                                          totalPrice,
                                          amount,
                                          shipPricController.text.isEmpty
                                              ? 0
                                              : double.parse(
                                                  shipPricController.text,
                                                ).toInt(),
                                          noShippingPrice,
                                          vat7percent,
                                          noVatPrice,
                                          discountPercent,
                                          discountPercentPrice);
                                    },
                                    icon: const Icon(
                                      Icons.close_sharp,
                                      color: Colors.white,
                                    ),
                                  )
                                : null,
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Container of ราคาขายรวม
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(56, 48, 77, 1.0),
                    borderRadius: BorderRadius.circular(15)),
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: const Text("ราคารวมสุทธิ",
                          style: TextStyle(fontSize: 15, color: Colors.white)),
                    ),
                    if (products.length != 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.shopping_cart_rounded,
                                  color: Colors.white, size: 15),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                    'สินค้า (${NumberFormat("#,###,###,###.##").format(noShippingPrice)})',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                              ),
                            ],
                          ),
                          if (shipPricController.text.isNotEmpty)
                            Row(
                              children: [
                                const Icon(Icons.local_shipping,
                                    color: Colors.greenAccent, size: 15),
                                Text(' ค่าจัดส่ง',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.greenAccent)),
                                Text(
                                    '+ (${NumberFormat("#,###,###,###.##").format(shippingCost)})',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.greenAccent)),
                              ],
                            ),
                          if (discountPercentController.text.isNotEmpty)
                            Row(
                              children: [
                                const Icon(Icons.discount_rounded,
                                    color: Colors.redAccent, size: 15),
                                Text(
                                    ' ${NumberFormat("#,###,###,###.##").format(discountPercent)} %',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.redAccent)),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                      '(-${NumberFormat("#,###,###,###.##").format(discountPercentPrice)})',
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.redAccent)),
                                ),
                              ],
                            )
                        ],
                      ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                          '${NumberFormat("#,###,###,###.##").format(showtotalPrice)}',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.grey)),
                    ),
                  ]),
                ),
              ),

              Row(
                children: [
                  Text(
                    "คำร้องขอพิเศษ",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ],
              ),
              // Container of คำร้องขอพิเศษ
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(56, 48, 77, 1.0),
                    borderRadius: BorderRadius.circular(15)),
                width: 400,
                height: 70,
                child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: specReqController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(56, 48, 77, 1.0),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none),
                      hintText: "เช่น ฝากวางหน้าบ้าน ตรงโต๊ะไม้หินอ่อน",
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
                      prefixIcon: const Icon(Icons.edit, color: Colors.white),
                      suffixIcon: specReqController.text.isEmpty
                          ? Container(
                              width: 0,
                            )
                          : IconButton(
                              onPressed: () => specReqController.clear(),
                              icon: const Icon(
                                Icons.close_sharp,
                                color: Colors.white,
                              ),
                            ),
                    )),
              ),
              // Container of คำร้องขอพิเศษ
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: InkWell(
                    onTap: () {
                      setState(() {
                        isDelivered = !isDelivered;
                        if (isDelivered == false) {
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
                        child: isDelivered
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
                        "จัดส่งสินค้าเรียบร้อยแล้ว",
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
                          onPressed: () async {
                            for (var selling in carts) {
                              for (var lot in lots) {
                                if (lot.prodLotId == selling.prodLotId) {
                                  final updateAmountDeletedProductLot =
                                      lot.copy(
                                          remainAmount: selling!.amount +
                                              lot.remainAmount);

                                  await DatabaseManager.instance
                                      .updateProductLot(
                                          updateAmountDeletedProductLot);
                                }
                              }
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            "ยกเลิก",
                            style: TextStyle(fontSize: 17),
                          ),
                          style: ElevatedButton.styleFrom(primary: Colors.red))
                    ]),
                    Column(children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_customer.cName == 'ยังไม่ระบุลูกค้า') {
                            _showAlertSnackBar('โปรดระบุลูกค้า');
                          } else if (carts.isEmpty) {
                            _showAlertSnackBar(
                                'โปรดเลือกสินค้าอย่างน้อย 1 รายการ');
                          } else if (_address.cAddress == 'ที่อยู่') {
                            _showAlertSnackBar('โปรดเลือกที่อยู่ลูกค้า');
                          } else {
                            _calculate(
                                totalPrice,
                                amount,
                                shipPricController.text.isEmpty ||
                                        shipPricController.text == null
                                    ? 0
                                    : double.parse(
                                        shipPricController.text,
                                      ).toInt(),
                                noShippingPrice,
                                vat7percent,
                                noVatPrice,
                                discountPercentController.text.isEmpty ||
                                        discountPercentController.text == null
                                    ? 0
                                    : double.parse(
                                        discountPercentController.text,
                                      ).toInt(),
                                discountPercentPrice);
                            setState(() {});

                            final createSelling = SellingModel(
                                orderedDate: date,
                                customerId: _customer.cusId!,
                                cAddreId: _address.cAddreId!,
                                shipping: _shipping == null ? '-' : _shipping,
                                shippingCost: shippingCost,
                                amount: amount,
                                discountPercent: discountPercent,
                                total: totalPrice,
                                speacialReq: specReqController.text.isEmpty ||
                                        specReqController.text == null
                                    ? '-'
                                    : specReqController.text,
                                isDelivered: isDelivered,
                                shopId: widget.shop.shopid!);

                            final createdSelling = await DatabaseManager
                                .instance
                                .createSelling(createSelling);

                            for (var cart in carts) {
                              final item = SellingItemModel(
                                  prodId: cart.prodId,
                                  prodModelId: cart.prodModelId,
                                  prodLotId: cart.prodLotId,
                                  amount: cart.amount,
                                  total: cart.total,
                                  selId: createdSelling.selId);

                              await DatabaseManager.instance
                                  .createSellingItem(item);
                              if (carts.isNotEmpty) {
                                if (isDelivered == true) {
                                } else {
                                  for (var i = 0; carts.length > i; i++) {
                                    for (var lot in productLots) {
                                      if (carts[i].prodLotId == lot.prodLotId) {
                                        final updateAmountSelectedProductLot =
                                            lot.copy(
                                                remainAmount: lot.remainAmount +
                                                    carts[i].amount);
                                        await DatabaseManager.instance
                                            .updateProductLot(
                                                updateAmountSelectedProductLot);
                                      }
                                    }
                                  }
                                }
                              }
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              behavior: SnackBarBehavior.floating,
                              content: Row(
                                children: [
                                  Text(
                                      "ทำรายการเสร็จสิ้น ยอด${NumberFormat("#,###,###.##").format(createSelling.total)}"),
                                  Text(
                                    " ${df.format(date)}",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              duration: Duration(seconds: 5),
                            ));
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "บันทึก",
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

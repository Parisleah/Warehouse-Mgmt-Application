import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class SellingNavEdit extends StatefulWidget {
  final Shop shop;
  final SellingModel selling;
  const SellingNavEdit({required this.selling, required this.shop, Key? key})
      : super(key: key);

  @override
  State<SellingNavEdit> createState() => _SellingNavEditState();
}

class _SellingNavEditState extends State<SellingNavEdit> {
  TextEditingController shipPricController = TextEditingController();
  TextEditingController specReqController = TextEditingController();
  CustomerModel _customer = CustomerModel(cName: 'ยังไม่ระบุลูกค้า');
  CustomerAddressModel _address = CustomerAddressModel(
    cAddress: 'ที่อยู่',
    cPhone: 'เบอร์โทร',
  );
  String _shipping = 'ระบุการจัดส่ง';
  DateTime date = DateTime.now();
  final df = new DateFormat('dd-MM-yyyy hh:mm a');

  late var shippingCost = widget.selling.shippingCost;
  late var totalPrice = widget.selling.total;
  late var noShippingPrice = widget.selling.total - shippingCost;
  late var amount = widget.selling.amount;
  late double vat7percent = widget.selling.total * 7 / 100;
  double noVatPrice = 0.0;
  bool isDelivered = false;
  List<Product> products = [];
  List<ProductModel> models = [];
  List<ProductLot> lots = [];
  List<CustomerModel> customers = [];
  List<CustomerAddressModel> addresses = [];
  List<SellingItemModel> sellingItems = [];
  _addProductInCart(SellingItemModel product) {
    sellingItems.add(product);
  }

  @override
  void initState() {
    super.initState();
    refreshPage();
    shipPricController.addListener(() => setState(() {}));
    shipPricController.addListener(() => setState(() {}));
    specReqController.addListener(() => setState(() {}));
  }

  Future refreshPage() async {
    products =
        await DatabaseManager.instance.readAllProducts(widget.shop.shopid!);
    models = await DatabaseManager.instance.readAllProductModels();
    lots = await DatabaseManager.instance.readAllProductLots();
    customers = await DatabaseManager.instance
        .readAllCustomerInShop(widget.shop.shopid!);
    addresses = await DatabaseManager.instance.readAllCustomerAddresses();
    sellingItems = await DatabaseManager.instance
        .readAllSellingItemsWhereSellID(widget.selling.selId!);
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

  _getCustomerName() {
    for (var customer in customers) {
      if (customer.cusId == widget.selling.customerId) {
        return customer.cName;
      }
    }
  }

  _getCustomerPhone() {
    for (var addresse in addresses) {
      if (addresse.cAddreId == widget.selling.cAddreId) {
        return addresse.cPhone;
      }
    }
  }

  _getCustomerAddress() {
    for (var addresse in addresses) {
      if (addresse.cAddreId == widget.selling.cAddreId) {
        return addresse.cAddress;
      }
    }
  }

  _calculate(oldTotal, oldAmount, oldShippingPrice, oldNoShippingPrice,
      oldvat7percent, oldNoVatPrice) {
    oldTotal = 0;
    oldAmount = 0;
    oldNoShippingPrice = 0;
    oldvat7percent = 0;
    oldNoVatPrice = 0;

    for (var i in sellingItems) {
      oldTotal += i.total;
      oldAmount += i.amount;
    }

    totalPrice = oldTotal + oldShippingPrice;
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

  Future<void> dialogConfirmDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (dContext, DialogSetState) {
          return AlertDialog(
            backgroundColor: Theme.of(dContext).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            title: Container(
              width: 150,
              child: Row(
                children: [
                  const Text(
                    'ต้องการลบรายการการขาย ?',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('adasdasd'),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('ยืนยัน'),
                onPressed: () {
                  Navigator.of(dContext).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          actions: [
            PopupMenuButton<int>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              itemBuilder: (context) => [
                // popupmenu item 2
                PopupMenuItem(
                  onTap: () {
                    Future.delayed(
                      const Duration(seconds: 0),
                      () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          title: const Text(
                            'ต้องการลบรายการการขาย ?',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.redAccent),
                              child: const Text('ยกเลิก'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            ElevatedButton(
                              child: const Text('ยืนยัน'),
                              onPressed: () async {
                                await DatabaseManager.instance
                                    .deleteSelling(widget.selling.selId!);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  value: 2,
                  // row has two child icon and text
                  child: Row(
                    children: [
                      Icon(Icons.delete),
                      SizedBox(
                        // sized box with width 10
                        width: 10,
                      ),
                      Text(
                        "ลบรายการการขาย",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ],
              offset: Offset(0, 80),
              color: Theme.of(context).colorScheme.onSecondary,
              elevation: 2,
            ),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
          title: Column(
            children: [
              Text(
                "แก้ไขรายการขาย",
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                      ),
                      Spacer(),
                      Text(
                        '${df.format(widget.selling.orderedDate)}',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
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
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                width: 400,
                height: 100,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('${_getCustomerName()}',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: _customer.cName == 'ยังไม่ระบุลูกค้า'
                                        ? Colors.grey
                                        : Colors.white)),
                            SizedBox(
                              width: 10,
                            ),
                            Text('(${_getCustomerPhone()})',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${_getCustomerAddress()}',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        width: 440.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            sellingItems.isEmpty
                                ? const Text(
                                    '(ไม่มีสินค้า)',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  )
                                : Container(
                                    height: sellingItems.length > 1 ? 220 : 90,
                                    width: 440.0,
                                    child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: sellingItems.length,
                                        itemBuilder: (context, index) {
                                          final selling = sellingItems[index];
                                          var prodName;
                                          var prodImg;
                                          var prodModel;
                                          for (var prod in products) {
                                            if (prod.prodId == selling.prodId) {
                                              prodImg = prod.prodImage!;
                                              prodName = prod.prodName;
                                            }
                                          }

                                          var stProperty;
                                          var ndProperty;

                                          for (var model in models) {
                                            if (model.prodModelId ==
                                                selling.prodModelId) {
                                              stProperty = model.stProperty;
                                              ndProperty = model.ndProperty;
                                            }
                                          }

                                          return Dismissible(
                                            key: UniqueKey(),
                                            onDismissed: (direction) async {
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
                                              sellingItems.remove(selling);
                                              for (var lot in lots) {
                                                if (lot.prodLotId ==
                                                    selling.prodLotId) {
                                                  final updateAmountDeletedProductLot =
                                                      ProductLot(
                                                          prodLotId: selling
                                                              ?.prodLotId,
                                                          amount:
                                                              selling?.amount,
                                                          orderedTime:
                                                              lot.orderedTime,
                                                          prodModelId: selling
                                                              ?.prodModelId,
                                                          remainAmount: selling!
                                                                  .amount +
                                                              lot.remainAmount);
                                                  await DatabaseManager.instance
                                                      .updateProductLot(
                                                          updateAmountDeletedProductLot);
                                                }
                                              }

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
                                                            File(prodImg!),
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
                                                                  'ราคา ${NumberFormat("#,###.##").format(selling.total)}',
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
                                                                '${NumberFormat("#,###.##").format(selling.amount)}',
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
                                                        SizedBox(
                                                          width: 10,
                                                        )
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
                    sellingItems.isEmpty
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'ทั้งหมด ',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(30, 30, 49, 1.0),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                      '${NumberFormat("#,###.##").format(sellingItems.length)}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color:
                                              Theme.of(context).backgroundColor,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Text(
                                'รายการ ',
                                style: const TextStyle(color: Colors.white),
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
              Row(
                children: [
                  Text(
                    "สรุปรายการ",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ],
              ),
              // Container of การจัดส่ง
              Container(
                padding: const EdgeInsets.all(5),
                width: 400,
                height: 30,
                child: Row(children: [
                  const Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text("การจัดส่ง",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                  const Spacer(),
                  Text(widget.selling.shipping!,
                      style: TextStyle(fontSize: 15, color: Colors.grey)),
                  const SizedBox(
                    width: 10,
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
                width: 400,
                height: 30,
                child: Row(children: [
                  const Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text("ค่าจัดส่ง",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                  const Spacer(),
                  Text('${NumberFormat("#,###.##").format(shippingCost)}',
                      style: TextStyle(fontSize: 15, color: Colors.grey)),
                  const SizedBox(
                    width: 10,
                  ),
                ]),
              ),
              // Container of ค่าจัดส่ง

              // Container of ราคาสุทธิ
              const SizedBox(
                height: 10,
              ),

              // Container of ราคาสุทธิ
              Container(
                padding: const EdgeInsets.all(5),
                width: 400,
                height: 30,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: const Text("ราคาสินค้าสุทธิ",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                        //หัก 7%(${NumberFormat("#,###.##").format(noVatPrice)})
                        '${NumberFormat("#,###.##").format(noShippingPrice - vat7percent)}',
                        textAlign: TextAlign.left,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey)),
                  ),
                ]),
              ),
              const SizedBox(
                height: 10,
              ),
              // Container of ภาษี 7 %
              Container(
                padding: const EdgeInsets.all(5),
                width: 400,
                height: 30,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: const Text("ภาษี (7%)",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
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

              // Container of ราคาสุทธิ
              Container(
                padding: const EdgeInsets.all(5),
                width: 400,
                height: 30,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: const Text("ราคาสินค้ารวม",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                        //หัก 7%(${NumberFormat("#,###.##").format(noVatPrice)})
                        '${NumberFormat("#,###.##").format(noShippingPrice)}',
                        textAlign: TextAlign.left,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey)),
                  ),
                ]),
              ),
              const SizedBox(
                height: 10,
              ),
              // Container of ราคาสุทธิ
              Container(
                width: 400,
                height: 30,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: const Text("ราคารวม",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                  if (products.length != 0)
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
                        if (shippingCost != 0)
                          Row(
                            children: [
                              const Icon(Icons.local_shipping,
                                  color: Colors.greenAccent, size: 15),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                    '+ (${NumberFormat("#,###,###,###.##").format(shippingCost)})',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.greenAccent)),
                              ),
                            ],
                          )
                      ],
                    ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                        '${NumberFormat("#,###,###,###.##").format(totalPrice)}',
                        textAlign: TextAlign.left,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey)),
                  ),
                ]),
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
                width: 400,
                height: 70,
                child: Text(widget.selling.speacialReq!,
                    style: TextStyle(fontSize: 15, color: Colors.white)),
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
                            for (var selling in sellingItems) {
                              for (var lot in lots) {
                                if (lot.prodLotId == selling.prodLotId) {
                                  final updateAmountDeletedProductLot =
                                      ProductLot(
                                          prodLotId: selling!.prodLotId,
                                          amount: selling!.amount,
                                          orderedTime: lot.orderedTime,
                                          prodModelId: selling!.prodModelId,
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
                            "ยกเลิกรายการ",
                            style: TextStyle(fontSize: 17),
                          ),
                          style: ElevatedButton.styleFrom(primary: Colors.red))
                    ]),
                    Column(children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_customer.cName == 'ยังไม่ระบุลูกค้า') {
                            _showAlertSnackBar('โปรดระบุลูกค้า');
                          } else if (sellingItems.isEmpty) {
                            _showAlertSnackBar(
                                'โปรดเลือกสินค้าอย่างน้อย 1 รายการ');
                          } else {
                            final createSelling = SellingModel(
                                orderedDate: date,
                                customerId: _customer.cusId!,
                                cAddreId: _address.cAddreId!,
                                shipping: _shipping == null ? '-' : _shipping,
                                shippingCost: shippingCost,
                                amount: amount,
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

                            for (var cart in sellingItems) {
                              final item = SellingItemModel(
                                  prodModelId: cart.prodModelId,
                                  prodLotId: cart.prodLotId,
                                  amount: cart.amount,
                                  total: cart.total,
                                  selId: createdSelling.selId);

                              await DatabaseManager.instance
                                  .createSellingItem(item);
                            }
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

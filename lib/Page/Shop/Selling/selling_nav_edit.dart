// Others
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:warehouse_mnmt/Page/Shop/Selling/selling_nav_chooseCustomer.dart';

// Page

import 'package:warehouse_mnmt/Page/Shop/Selling/nav_choose_product.dart';

// import 'package:warehouse_mnmt/Page/pickProduct/pickProduct_page.dart';
import 'package:warehouse_mnmt/Page/Shop/Selling/nav_choose_product.dart';

// Component
import 'package:warehouse_mnmt/Page/Component/datePicker.dart';
import 'package:warehouse_mnmt/Page/Component/styleButton.dart';

// Model
import 'package:warehouse_mnmt/Page/Model/Product.dart';

// Class for TextField Decimal Format (ex. 1,000,200.00 $)
import 'package:warehouse_mnmt/Page/Component/TextField/textField_component.dart';

class sellingNavEdit extends StatefulWidget {
  // Navigation ---------------------------------------------------

  // Navigation ---------------------------------------------------

  // customer ---------------------------------------------------------
  // final Customer customer;

  sellingNavEdit({
    Key? key,
    // required this.customer,
  }) : super(key: key);
  // customer ---------------------------------------------------------

  @override
  State<sellingNavEdit> createState() => _sellingNavEditState();
}

class _sellingNavEditState extends State<sellingNavEdit> {
  List<Product> products = [
    Product(
        prodName: "Scream Black Coat1",
        prodCategId: 1,
        prodDescription: "Leather 100%",
        prodImage: "assets/images/products/1.png",
        shopId: 1),
    Product(
        prodName: "Scream Black Coat2",
        prodCategId: 1,
        prodDescription: "Leather 100%",
        prodImage: "assets/images/products/2.png",
        shopId: 1),
  ];
  // TextField shippingPrice
  final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter();

  // Edit Detail Zone
  final shippingPrice = 50.99;
  final totalPrice = 1180.99;
  final withoutTaxPrice = 1098.3207;
  final tax = 82.6693;

  // TextField -------------------------------------------------------------
  // ShipPrice TextField
  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  final shipPricController = TextEditingController();
  // ShipPrice TextField
  // ----------------------------------------------------------------------

  final specReqController = TextEditingController();

  void initState() {
    super.initState();
    specReqController.addListener(() => setState(() {}));
    shipPricController.addListener(() => setState(() {}));
  }

// Edit Detail Zone
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
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
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete),
            )
          ],
          flexibleSpace: Center(
              child: Baseline(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircleAvatar(
                radius: 20,
                // backgroundImage: AssetImage(widget.customer.urlAvatar),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'widget.customer.username',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              )
            ]),
            baselineType: TextBaseline.alphabetic,
            baseline: 90,
          )),
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
          child:
              // Text(
              //   user.username,
              //   style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              // )
              Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              const SizedBox(
                height: 150,
              ),
              // Date Picker
              Container(
                width: 440,
                height: 70,
                child: datePicker(),
              ),
              const SizedBox(
                height: 10,
              ),
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
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(56, 48, 77, 1.0),
                    borderRadius: BorderRadius.circular(15)),
                width: 440,
                height: 310,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    ElevatedButton(
                      style: prodPickButtonStyle,
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     new MaterialPageRoute(
                        //         builder: (context) => pickProd_page()));
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        height: 224.0,
                        width: 440.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Color.fromRGBO(37, 35, 53, 1.0),
                        ),
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return TextButton(
                                onPressed: () {
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => sellingNavPickProd(
                                  //         product: product)));
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 0.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      height: 80,
                                      width: 400,
                                      color: Color.fromRGBO(56, 54, 76, 1.0),
                                      child: Row(
                                        children: <Widget>[
                                          // Container(
                                          //     width: 80,
                                          //     height: 80,
                                          //     decoration: new BoxDecoration(
                                          //         image: new DecorationImage(
                                          //       image: new AssetImage(
                                          //           product.prodImage),
                                          //       fit: BoxFit.fill,
                                          //     )
                                          //   )
                                          // ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  product.prodName,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  'product.prodCategory',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                    'ราคา/หน่วย {NumberFormat("#,###.##").format(product.prodPrice)}',
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12)),
                                                Text(
                                                    'ราคา {NumberFormat("#,###.##").format(product.prodPrice)}',
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12)),
                                              ],
                                            ),
                                          ),
                                          CircleAvatar(
                                            radius: 15,
                                            backgroundColor:
                                                Color.fromRGBO(30, 30, 49, 1.0),
                                            child: Text(
                                                '{NumberFormat("#,###.##").format(product.prodAmount)}',
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.greenAccent,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          const Icon(Icons.arrow_forward_ios,
                                              color: Color.fromARGB(
                                                  255, 205, 205, 205)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
                    // ListView
                  ]),
                ),
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
                  const Text("Flash Express",
                      style: TextStyle(fontSize: 15, color: Colors.grey)),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white),
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     new MaterialPageRoute(
                      //         builder: (context) =>
                      //             selling_nav_chooseShipping()));
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
                    textAlign: TextAlign.end,
                    inputFormatters: [DecimalFormatter()],
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
                              onPressed: () => shipPricController.clear(),
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
                    child: const Text("Vat (7%)",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                        '${NumberFormat("#,###,###,###.##").format(tax)}',
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
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(56, 48, 77, 1.0),
                    borderRadius: BorderRadius.circular(15)),
                width: 400,
                height: 70,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: const Text("ราคาสุทธิ",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                        '${NumberFormat("#,###,###,###.##").format(withoutTaxPrice)}',
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
              // Container of ราคาขายรวม
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(56, 48, 77, 1.0),
                    borderRadius: BorderRadius.circular(15)),
                width: 400,
                height: 70,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: const Text("ราคาขายรวม",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                        '${NumberFormat("#,###,###,###.##").format(totalPrice)}',
                        textAlign: TextAlign.left,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey)),
                  ),
                ]),
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
                decoration: BoxDecoration(
                    color: Color.fromRGBO(56, 48, 77, 1.0),
                    borderRadius: BorderRadius.circular(15)),
                width: 400,
                height: 70,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: const Text("ยังไม่ได้ระบุลูกค้า",
                        style: TextStyle(fontSize: 15, color: Colors.grey)),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     new MaterialPageRoute(
                      //         builder: (context) =>
                      //             SellingNavChooseCustomer()));
                    },
                  ),
                ]),
              ),
              // Container of เลือกลูกค้า
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

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(children: [
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            "ยกเลิก",
                            style: TextStyle(fontSize: 17),
                          ),
                          style: cancelButtonStyle)
                    ]),
                    Column(children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "บันทึก",
                          style: TextStyle(fontSize: 17),
                        ),
                        style: saveButtonStyle,
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

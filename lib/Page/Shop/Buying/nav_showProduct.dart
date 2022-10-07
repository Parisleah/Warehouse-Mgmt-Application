// Others
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:warehouse_mnmt/Page/Model/ProductLot.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel.dart';
import 'package:warehouse_mnmt/Page/Model/Purchasing_item.dart';

import '../../../db/database.dart';
import '../../Model/Product.dart';
import '../../Model/ProductModel_ndProperty.dart';
import '../../Model/ProductModel_stProperty.dart';

class BuyingNavShowProd extends StatefulWidget {
  final Product product;
  final ValueChanged<PurchasingItemsModel> update;

  BuyingNavShowProd({
    Key? key,
    required this.update,
    required this.product,
  }) : super(key: key);

  @override
  State<BuyingNavShowProd> createState() => _BuyingNavShowProdState();
}

class _BuyingNavShowProdState extends State<BuyingNavShowProd> {
  List<ProductModel> productModels = [];
  List<ProductLot> productLots = [];
  List<ProductModel_stProperty> stPropertys = [];
  List<ProductModel_ndProperty> ndPropertys = [];
  ProductModel? selectedValue;
  String? value;
  final prodAmountController = TextEditingController();
  final prodRequestController = TextEditingController();
  // Text Field
  void initState() {
    super.initState();
    refreshProducts();
    prodAmountController.addListener(() => setState(() {}));
    prodRequestController.addListener(() => setState(() {}));

    setState(
      () {},
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _formKeyAmount = GlobalKey<FormState>();

  Future refreshProducts() async {
    productModels = await DatabaseManager.instance
        .readAllProductModelsInProduct(widget.product.prodId!);

    setState(() {});
  }

  int ctotal = 0;
  void _calculateTotal(model, int amount) {
    if (model != null) {
      ctotal = model.cost * amount;
    } else {
      ctotal = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
          title: Column(
            children: [
              Text(
                widget.product.prodName,
                style: TextStyle(fontSize: 25),
              )
            ],
          ),
          centerTitle: true,
          actions: [
            // ?
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
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 100,
                ),
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          File(widget.product.prodImage!),
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      color: Color.fromARGB(255, 33, 36, 34),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          widget.product.prodName,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    widget.product.prodDescription!,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                  Text(
                    "คงเหลือสินค้าทั้งหมด ${NumberFormat("#,###").format(widget.product.prodId)} ชิ้น",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ]),
                // Drop Down แบบสินค้า
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: DropdownButtonFormField2(
                          validator: (value) {
                            if (value == null) {
                              return 'โปรดเลือกรูปแบบสินค้า';
                            }
                          },
                          onChanged: (value) {
                            selectedValue = value as ProductModel;
                            if (prodAmountController.text.isNotEmpty) {
                              int amount = int.parse(prodAmountController.text);
                              _calculateTotal(selectedValue, amount);
                            }

                            setState(() {});
                          },
                          onSaved: (value) {
                            selectedValue = value as ProductModel;

                            setState(() {});
                          },
                          dropdownMaxHeight: 200,
                          itemHeight: 80,
                          buttonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            color: Color.fromRGBO(66, 64, 87, 1.0),
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          isExpanded: true,
                          hint: Text(
                            productModels.isEmpty
                                ? 'ไม่มีรูปแบบสินค้า'
                                : 'โปรดเลือกรูปแบบสินค้า',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          iconSize: 30,
                          buttonHeight: 90,
                          buttonPadding:
                              const EdgeInsets.only(left: 20, right: 10),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            color: const Color.fromRGBO(56, 54, 76, 1.0),
                          ),
                          items: productModels
                              .map((item) => DropdownMenuItem<ProductModel>(
                                    value: item,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          height: 100,
                                          color:
                                              Color.fromRGBO(66, 64, 87, 1.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${item.stProperty} ${(item.ndProperty)}',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                        'ต้นทุน ${NumberFormat("#,###.##").format(item.cost)}',
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 10)),
                                                    Text(
                                                        ' ราคา ${NumberFormat("#,###.##").format(item.price)}',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10)),
                                                  ],
                                                ),
                                                Spacer(),
                                                CircleAvatar(
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          30, 30, 49, 1.0),
                                                  radius: 10,
                                                  child: Text(
                                                      '${NumberFormat("#,###.##").format(item.prodModelId)}',
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                //Container of จำนวนสินค้า
                Form(
                  key: _formKeyAmount,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "จำนวนสินค้า",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(56, 48, 77, 1.0),
                            borderRadius: BorderRadius.circular(15)),
                        width: 350,
                        height: 60,
                        child: TextFormField(
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.number,
                            onChanged: (text) {
                              if (prodAmountController.text.isNotEmpty &&
                                  prodAmountController.text != null &&
                                  prodAmountController.text != '') {
                                int amount =
                                    int.parse(prodAmountController.text);
                                _calculateTotal(selectedValue, amount);
                              }

                              setState(() {});
                            },
                            //-----------------------------------------------------
                            style: const TextStyle(color: Colors.grey),
                            controller: prodAmountController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'ใส่จำนวน';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide.none),
                              hintText: "ระบุจำนวน",
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              suffixIcon: !prodAmountController.text.isEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        prodAmountController.clear();
                                        ctotal = 0;
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
                // Container of จำนวนสินค้า
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "ค่าใช้จ่าย ${NumberFormat("#,###,###.##").format(ctotal)}",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),

                // Container of คำขอร้องพิเศษ
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "คำร้องขอพิเศษ",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(56, 48, 77, 1.0),
                          borderRadius: BorderRadius.circular(15)),
                      width: 350,
                      height: 60,
                      child: TextField(
                          textAlign: TextAlign.start,
                          //-----------------------------------------------------
                          style: const TextStyle(color: Colors.grey),
                          controller: prodRequestController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide.none),
                            hintText: "สินค้าชิ้นนี้ต้องการแบบนี้...",
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                            suffixIcon: !prodRequestController.text.isEmpty
                                ? IconButton(
                                    onPressed: () =>
                                        prodRequestController.clear(),
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
                // Container of คำขอร้องพิเศษ
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        spacing: 20,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "ยกเลิก",
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  _formKeyAmount.currentState!.validate()) {
                                _formKey.currentState!.save();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor:
                                      Theme.of(context).backgroundColor,
                                  behavior: SnackBarBehavior.floating,
                                  content: Row(
                                    children: [
                                      Icon(
                                        Icons.shopping_cart_outlined,
                                        color: Colors.white,
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          child: Image.file(
                                            File(widget.product.prodImage!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            "+${prodAmountController.text}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Text(" ${widget.product.prodName} "),
                                    ],
                                  ),
                                  duration: Duration(seconds: 5),
                                ));
                                final puritem = PurchasingItemsModel(
                                    amount:
                                        int.parse(prodAmountController.text),
                                    prodModelId: widget.product.prodId,
                                    total: ctotal);
                                widget.update(puritem);
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              "ยืนยัน",
                              style: TextStyle(fontSize: 17),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}

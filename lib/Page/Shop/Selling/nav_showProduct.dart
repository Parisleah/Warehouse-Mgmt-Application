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
import '../../Model/Selling_item.dart';

class SellingNavShowProd extends StatefulWidget {
  final Product product;
  final ValueChanged<SellingItemModel> update;

  SellingNavShowProd({
    Key? key,
    required this.update,
    required this.product,
  }) : super(key: key);

  @override
  State<SellingNavShowProd> createState() => _SellingNavShowProdState();
}

class _SellingNavShowProdState extends State<SellingNavShowProd> {
  List<ProductModel> productModels = [];
  List<ProductLot> productLots = [];
  List<ProductModel_stProperty> stPropertys = [];
  List<ProductModel_ndProperty> ndPropertys = [];
  ProductModel? modelSelectedValue;
  ProductLot? lotSelectedValue;
  final df = new DateFormat('dd-MM-yyyy');
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

  final _formKeyProdModel = GlobalKey<FormState>();
  final _formKeyProdLot = GlobalKey<FormState>();
  final _formKeyAmount = GlobalKey<FormState>();

  Future refreshProducts() async {
    productModels = await DatabaseManager.instance
        .readAllProductModelsInProduct(widget.product.prodId!);

    setState(() {});
  }

  int ptotal = 0;
  void _calculateTotal(model, int amount) {
    if (model != null) {
      ptotal = model.price * amount;
    } else {
      ptotal = 0;
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
                  key: _formKeyProdModel,
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
                          onChanged: (value) async {
                            modelSelectedValue = value as ProductModel;
                            if (prodAmountController.text.isNotEmpty) {
                              int amount = int.parse(prodAmountController.text);
                              _calculateTotal(modelSelectedValue, amount);
                            }
                            productLots = await DatabaseManager.instance
                                .readAllProductLotsByModelID(
                                    value.prodModelId!);

                            setState(() {});
                          },
                          onSaved: (value) async {
                            modelSelectedValue = value as ProductModel;

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
                          buttonHeight: 80,
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
                                                            fontSize: 11)),
                                                    Text(
                                                        ' ราคา ${NumberFormat("#,###.##").format(item.price)}',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12)),
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
                                                          fontSize: 12,
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
                // Drop Down ล็อตสินค้า
                SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKeyProdLot,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: DropdownButtonFormField2(
                          validator: (value) {
                            if (value == null) {
                              return 'โปรดเลือกล็อตสินค้า';
                            }
                          },
                          onChanged: (value) {
                            lotSelectedValue = value as ProductLot;
                            if (prodAmountController.text.isNotEmpty) {
                              int amount = int.parse(prodAmountController.text);
                              _calculateTotal(lotSelectedValue, amount);
                            }

                            setState(() {});
                          },
                          onSaved: (value) {
                            lotSelectedValue = value as ProductLot;

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
                            productLots.isEmpty
                                ? 'ไม่มีล็อตสินค้า'
                                : 'โปรดเลือกล็อตสินค้า',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          iconSize: 30,
                          buttonHeight: 80,
                          buttonPadding:
                              const EdgeInsets.only(left: 20, right: 10),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            color: const Color.fromRGBO(56, 54, 76, 1.0),
                          ),
                          items: productLots
                              .map((item) => DropdownMenuItem<ProductLot>(
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
                                                Text(
                                                  'ล็อตที่ ${item.prodLotId} วันที่ ${df.format(item.orderedTime!)}',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Spacer(),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          30, 30, 49, 1.0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Text(
                                                        'คงเหลือ ${NumberFormat("#,###.##").format(item.remainAmount)}',
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
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
                                int remainLot = int.parse(
                                    lotSelectedValue!.remainAmount.toString());
                                if (amount > remainLot) {
                                  prodAmountController.clear();
                                  ptotal = 0;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.redAccent,
                                      behavior: SnackBarBehavior.floating,
                                      content: Text("สินค้าคงเหลือไม่เพียงพอ"),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                } else {
                                  _calculateTotal(modelSelectedValue, amount);
                                }
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
                                        ptotal = 0;
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
                    "ค่าใช้จ่าย ${NumberFormat("#,###,###.##").format(ptotal)}",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),

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
                            onPressed: () async {
                              if (_formKeyProdModel.currentState!.validate() &&
                                  _formKeyAmount.currentState!.validate()) {
                                _formKeyProdModel.currentState!.save();
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
                                final puritem = SellingItemModel(
                                    amount:
                                        int.parse(prodAmountController.text),
                                    prodId: widget.product.prodId!,
                                    prodModelId:
                                        modelSelectedValue?.prodModelId,
                                    prodLotId: lotSelectedValue?.prodLotId,
                                    total: ptotal);
                                widget.update(puritem);
                                final updateAmountSelectedProductLot =
                                    ProductLot(
                                        prodLotId: lotSelectedValue?.prodLotId,
                                        amount: lotSelectedValue?.amount,
                                        orderedTime:
                                            lotSelectedValue?.orderedTime,
                                        prodModelId:
                                            lotSelectedValue?.prodModelId,
                                        remainAmount:
                                            lotSelectedValue!.remainAmount -
                                                int.parse(
                                                    prodAmountController.text));
                                await DatabaseManager.instance.updateProductLot(
                                    updateAmountSelectedProductLot);
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

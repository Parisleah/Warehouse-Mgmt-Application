// Others
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:warehouse_mnmt/Page/Model/ProductLot.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel.dart';

import '../../../db/database.dart';
import '../../Model/Product.dart';
import '../../Model/ProductModel_ndProperty.dart';
import '../../Model/ProductModel_stProperty.dart';

class BuyingNavShowProd extends StatefulWidget {
  final Product product;

  BuyingNavShowProd({
    Key? key,
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

  String? value;
  // TextField -------------------------------------------------------------
  // prodAmountController TextField
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

  Future refreshProducts() async {
    productModels = await DatabaseManager.instance
        .readAllProductModelsInProduct(widget.product.prodId!);

    setState(() {});
  }

  _get1stName(prodModel) async {
    stPropertys = await DatabaseManager.instance
        .readAll1stProperty(prodModel.prodModelId!);

    for (var st in stPropertys) {
      if (st.pmstPropId == prodModel.stProperty) {
        return '${st.pmstPropName}';
        break;
      }
    }
  }

  String? selectedValue;

  final _formKey = GlobalKey<FormState>();
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
                                          color:
                                              Color.fromRGBO(66, 64, 87, 1.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${_get1stName(item)}',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      '${(item.prodModelname)}',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white),
                                                    ),
                                                    Spacer(),
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          Color.fromRGBO(
                                                              30, 30, 49, 1.0),
                                                      radius: 10,
                                                      child: Text(
                                                          '${NumberFormat("#,###.##").format(1)}',
                                                          style: const TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'โปรดเลือกรูปแบบสินค้า';
                            }
                          },
                          onChanged: (value) {
                            //Do something when changing the item if you want.
                          },
                          onSaved: (value) {
                            selectedValue = value.toString();
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                //Container of จำนวนสินค้า
                Column(
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
                      child: TextField(
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.number,
                          //-----------------------------------------------------
                          style: const TextStyle(color: Colors.grey),
                          controller: prodAmountController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide.none),
                            hintText: "1",
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                            suffixIcon: !prodAmountController.text.isEmpty
                                ? IconButton(
                                    onPressed: () =>
                                        prodAmountController.clear(),
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
                // Container of จำนวนสินค้า
                // Container of คำขอร้องพิเศษ
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "คำขอร้องพิเศษ",
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
                          productLots.isEmpty
                              ? Container(
                                  width: 0,
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
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

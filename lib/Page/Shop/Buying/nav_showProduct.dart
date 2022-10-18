// Others
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:warehouse_mnmt/Page/Component/SearchBox.dart';
import 'package:warehouse_mnmt/Page/Component/TextField/CustomTextField.dart';
import 'package:warehouse_mnmt/Page/Model/ProductLot.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel.dart';
import 'package:warehouse_mnmt/Page/Model/Purchasing_item.dart';

import '../../../db/database.dart';
import '../../Model/Product.dart';
import '../../Model/ProductModel_ndProperty.dart';
import '../../Model/ProductModel_stProperty.dart';

class BuyingNavShowProd extends StatefulWidget {
  final Product product;
  final int? productTotalAmount;
  final ValueChanged<PurchasingItemsModel> update;
  BuyingNavShowProd({
    Key? key,
    this.productTotalAmount,
    required this.update,
    required this.product,
  }) : super(key: key);
  @override
  State<BuyingNavShowProd> createState() => _BuyingNavShowProdState();
}
// New

List<ProductModel> selectedItems = [];
final List<String> items = [
  'Item1',
  'Item2',
  'Item3',
  'Item4',
];
List<TextEditingController> amountControllers = [];
// New

class _BuyingNavShowProdState extends State<BuyingNavShowProd> {
  List<ProductModel> productModels = [];
  List<ProductLot> productLots = [];
  List<ProductModel_stProperty> stPropertys = [];
  List<ProductModel_ndProperty> ndPropertys = [];
  ProductModel? selectedValue;

  String? value;
  bool isReceived = false;
  final prodAmountController = TextEditingController();
  bool _validate = false;
  // Text Field
  void initState() {
    super.initState();
    refreshProducts();
    prodAmountController.addListener(() => setState(() {}));
    for (var controller in amountControllers) {
      controller.addListener(() => setState(() {}));
    }
    setState(() {});
  }

  final _formKey = GlobalKey<FormState>();
  final _formKeyAmount = GlobalKey<FormState>();

  Future refreshProducts() async {
    productModels = await DatabaseManager.instance
        .readAllProductModelsInProduct(widget.product.prodId!);
    productLots = await DatabaseManager.instance.readAllProductLots();

    setState(() {});
  }

  _getLotRemainAmount(prodModelId) {
    var remainAmount = 0;
    for (var lot in productLots) {
      if (lot.prodModelId == prodModelId) {
        remainAmount += lot.remainAmount;
      }
    }
    return remainAmount;
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              selectedItems.clear();
              amountControllers.clear();
              Navigator.of(context).pop();
            },
          ),
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
                    "คงเหลือสินค้าทั้งหมด ${NumberFormat("#,###").format(widget.productTotalAmount)} ชิ้น",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "Drop Down V.1",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField2(
                            validator: (value) {
                              if (value == null) {
                                return 'โปรดเลือกรูปแบบสินค้า';
                              }
                            },
                            onChanged: (value) {
                              selectedValue = value as ProductModel;
                              if (prodAmountController.text.isNotEmpty) {
                                int amount =
                                    int.parse(prodAmountController.text);
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
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
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
                                      child: StatefulBuilder(
                                          builder: (context, menuSetState) {
                                        final _isSelected =
                                            selectedItems.contains(item);

                                        return InkWell(
                                          onTap: () {
                                            _isSelected
                                                ? selectedItems.remove(item)
                                                : selectedItems.add(item);

                                            _isSelected
                                                ? amountControllers.remove(
                                                    TextEditingController())
                                                : amountControllers.add(
                                                    TextEditingController(
                                                        text: '1'));

                                            setState(() {});

                                            menuSetState(() {});
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                height: 100,
                                                color: Color.fromRGBO(
                                                    66, 64, 87, 1.0),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      _isSelected
                                                          ? Icon(
                                                              Icons
                                                                  .check_box_rounded,
                                                              color: Theme.of(
                                                                      context)
                                                                  .backgroundColor,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .check_box_outline_blank,
                                                              color: Theme.of(
                                                                      context)
                                                                  .backgroundColor,
                                                            ),
                                                      const SizedBox(width: 16),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${item.stProperty} ${(item.ndProperty)}',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                              'ต้นทุน ${NumberFormat("#,###.##").format(item.cost)}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      12)),
                                                          Text(
                                                              ' ราคา ${NumberFormat("#,###.##").format(item.price)}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      12)),
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: _getLotRemainAmount(item
                                                                        .prodModelId) ==
                                                                    0
                                                                ? Colors
                                                                    .redAccent
                                                                : Theme.of(
                                                                        context)
                                                                    .backgroundColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Row(
                                                            children: [
                                                              _getLotRemainAmount(item
                                                                          .prodModelId) ==
                                                                      0
                                                                  ? Container()
                                                                  : Text(
                                                                      'คงเหลือ ',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .white,
                                                                      )),
                                                              Text(
                                                                  _getLotRemainAmount(item
                                                                              .prodModelId) ==
                                                                          0
                                                                      ? 'สินค้าหมด'
                                                                      : '${NumberFormat("#,###.##").format(_getLotRemainAmount(item.prodModelId))}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ))
                                .toList(),
                            value: selectedItems.isEmpty
                                ? null
                                : selectedItems.last,
                            buttonWidth: 200,
                            itemPadding: EdgeInsets.zero,
                            selectedItemBuilder: (context) {
                              return items.map(
                                (item) {
                                  return Row(
                                    children: [
                                      Container(
                                        width: 250,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            padding: const EdgeInsets.all(8),
                                            itemCount: selectedItems.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final indItem =
                                                  selectedItems[index];
                                              // ??????asdsd
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    height: 100,
                                                    color: Color.fromRGBO(
                                                        66, 64, 87, 1.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .check_box_rounded,
                                                            color: Theme.of(
                                                                    context)
                                                                .backgroundColor,
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          Text(
                                                            '${indItem.stProperty} ${(indItem.ndProperty)}',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ],
                                  );
                                },
                              ).toList();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // List View SelectedItems
                selectedItems.isEmpty
                    ? Container()
                    : Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(56, 48, 77, 1.0),
                            borderRadius: BorderRadius.circular(15)),
                        width: 350,
                        height: selectedItems.length > 1
                            ? selectedItems.length * 90
                            : 200,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.all(8),
                            itemCount: selectedItems.length,
                            itemBuilder: (BuildContext context, int index) {
                              final indItem = selectedItems[index];
                              final _isSelected =
                                  selectedItems.contains(indItem);
                              var amount;
                              if (amountControllers[index].text.isEmpty ||
                                  amountControllers[index].text == null) {
                                amountControllers[index].text = '0';
                                amount = 0;
                              } else {
                                amount =
                                    int.parse(amountControllers[index].text);
                              }

                              // int.parse(TextEditingController().text);
                              var totalPrice = indItem.cost * amount;
                              return InkWell(
                                onTap: () {
                                  _isSelected
                                      ? selectedItems.remove(indItem)
                                      : selectedItems.add(indItem);

                                  _isSelected
                                      ? amountControllers
                                          .remove(TextEditingController())
                                      : amountControllers.add(
                                          TextEditingController(text: '1'));

                                  setState(() {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      height: 80,
                                      color: Color.fromRGBO(66, 64, 87, 1.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    _isSelected
                                                        ? Icon(
                                                            Icons
                                                                .check_box_rounded,
                                                            color: Theme.of(
                                                                    context)
                                                                .backgroundColor,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .check_box_outline_blank,
                                                            color: Theme.of(
                                                                    context)
                                                                .backgroundColor,
                                                          ),
                                                    Text(
                                                      '${indItem.stProperty} ${(indItem.ndProperty)}',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                        ' (${NumberFormat("#,###.##").format(totalPrice)})',
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12)),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    'ต้นทุน ${NumberFormat("#,###.##").format(indItem.cost)}',
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12)),
                                                Text(
                                                    ' ราคา ${NumberFormat("#,###.##").format(indItem.price)}',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12)),
                                              ],
                                            ),
                                            Spacer(),
                                            Container(
                                              width: 120,
                                              child: TextField(
                                                  onChanged: ((value) {
                                                    totalPrice =
                                                        indItem.cost * amount;
                                                    setState(() {});
                                                  }),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      amountControllers[index],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Color.fromARGB(
                                                        255, 46, 44, 62),
                                                    border: const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                topRight: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        20)),
                                                        borderSide:
                                                            BorderSide.none),
                                                    hintText: 'จำนวน',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14),
                                                    suffixIcon:
                                                        amountControllers[index]
                                                                .text
                                                                .isEmpty
                                                            ? IconButton(
                                                                onPressed: () {
                                                                  amountControllers[
                                                                          index]
                                                                      .clear();
                                                                  amountControllers[
                                                                          index]
                                                                      .text = '1';
                                                                  setState(
                                                                      () {});
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .close_sharp,
                                                                  size: 10,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              )
                                                            : null,
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),

                const SizedBox(
                  height: 10,
                ),

                // Container of จำนวนสินค้า
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(56, 48, 77, 1.0),
                      borderRadius: BorderRadius.circular(15)),
                  width: 350,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "ค่าใช้จ่าย",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Spacer(),
                      Text(
                        "${NumberFormat("#,###,###.##").format(ctotal)}",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ],
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
                                    prodId: widget.product.prodId!,
                                    prodModelId: selectedValue?.prodModelId,
                                    total: ctotal);
                                widget.update(puritem);
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              "บันทึก",
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

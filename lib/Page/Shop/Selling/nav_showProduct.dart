// Others
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:warehouse_mnmt/Page/Model/ProductCategory.dart';
import 'package:warehouse_mnmt/Page/Model/ProductLot.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel.dart';
import 'package:warehouse_mnmt/Page/Model/Purchasing_item.dart';
import 'package:warehouse_mnmt/Page/Shop/Buying/nav_showProduct.dart';

import '../../../db/database.dart';
import '../../Model/Product.dart';
import '../../Model/ProductModel_ndProperty.dart';
import '../../Model/ProductModel_stProperty.dart';
import '../../Model/Selling_item.dart';

class SellingNavShowProd extends StatefulWidget {
  final Product product;
  final ProductCategory prodCategory;
  final int? productTotalAmount;
  final ValueChanged<SellingItemModel> update;

  SellingNavShowProd({
    Key? key,
    required this.update,
    required this.product,
    required this.prodCategory,
    this.productTotalAmount,
  }) : super(key: key);

  @override
  State<SellingNavShowProd> createState() => _SellingNavShowProdState();
}

class _SellingNavShowProdState extends State<SellingNavShowProd> {
  List<ProductModel> productModels = [];
  List<ProductLot> productLots = [];
  List<ProductModel_stProperty> stPropertys = [];
  List<ProductModel_ndProperty> ndPropertys = [];

  List<ProductModel> ddModelSelectedItems = [];
  List<ProductLot> ddLotSelectedItems = [];
  ProductModel? modelSelectedValue;
  ProductLot? lotSelectedValue;
  List<DropdownMenuItem<ProductLot>> _dropDownProductLotItems(model) {
    List<ProductLot> lotModelItems = [];
    for (var lot in productLots) {
      if (lot.prodModelId == model.prodModelId) {
        lotModelItems.add(lot);
      }
    }

    return lotModelItems
        .map((item) => DropdownMenuItem<ProductLot>(
              value: item,
              child: StatefulBuilder(builder: (context, menuSetState) {
                final isSelectedLot = ddLotSelectedItems.contains(item);
                return InkWell(
                  onTap: () {
                    if (isSelectedLot == false) {
                      ddLotSelectedItems.add(item);
                    } else {
                      ddLotSelectedItems.remove(item);
                    }

                    setState(() {});

                    menuSetState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          height: 100,
                          color: Color.fromRGBO(66, 64, 87, 1.0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  isSelectedLot
                                      ? Icon(
                                          Icons.check_box_rounded,
                                          color:
                                              Theme.of(context).backgroundColor,
                                        )
                                      : Icon(
                                          Icons.check_box_outline_blank,
                                          color:
                                              Theme.of(context).backgroundColor,
                                        ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'ล็อตที่ ${NumberFormat("#,###.##").format(item.prodLotId)}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                      Text(
                                          '(วันที่ ${df.format(item.orderedTime!)})',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .backgroundColor,
                                              fontSize: 12)),
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(
                                      'คงเหลือ ${NumberFormat("#,###.##").format(item.remainAmount)}',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                                ]),
                          )),
                    ),
                  ),
                );
              }),
            ))
        .toList();
  }

  final List<String> modelitems = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
    'Item9',
    'Item10',
    'Item11',
    'Item12',
  ];

  final df = new DateFormat('dd-MM-yyyy');
  final prodRequestController = TextEditingController();
  // Text Field
  void initState() {
    super.initState();
    refreshProducts();

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
    productLots = await DatabaseManager.instance.readAllProductLots();
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

  _getLotRemainAmount(prodModelId) {
    var remainAmount = 0;
    for (var lot in productLots) {
      if (lot.prodModelId == prodModelId) {
        remainAmount += lot.remainAmount;
      }
    }
    return remainAmount;
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
                const SizedBox(
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
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Theme.of(context).colorScheme.secondary,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          widget.prodCategory.prodCategName,
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
                // Drop Down แบบสินค้า
                Form(
                  key: _formKeyProdModel,
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
                              modelSelectedValue = value as ProductModel;
                              // if (prodAmountController.text.isNotEmpty) {
                              //   int amount =
                              //       int.parse(prodAmountController.text);
                              //   _calculateTotal(selectedValue, amount);
                              // }

                              setState(() {});
                            },
                            onSaved: (value) {
                              modelSelectedValue = value as ProductModel;

                              setState(() {});
                            },
                            dropdownMaxHeight: 360,
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
                            buttonHeight: 70,
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
                                            ddModelSelectedItems.contains(item);
                                        final found = ddModelSelectedItems
                                            .indexWhere((e) => e == item);
                                        var remainAmt = _getLotRemainAmount(
                                            item.prodModelId);

                                        return InkWell(
                                          onTap: () {
                                            if (_isSelected == false &&
                                                remainAmt != 0) {
                                              ddModelSelectedItems.add(item);
                                            } else if (remainAmt == 0) {
                                              //Alert 0 Stock
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .backgroundColor,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content: Text(
                                                      "สินค้า ${item.stProperty} ${item.ndProperty} สินค้าหมด!"),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                            } else {
                                              ddModelSelectedItems.remove(item);
                                            }
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
                                                      remainAmt == 0
                                                          ? Icon(
                                                              Icons.close_sharp,
                                                              color: Theme.of(
                                                                      context)
                                                                  .backgroundColor,
                                                            )
                                                          : _isSelected
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
                                                      const Spacer(),
                                                      Text(
                                                          remainAmt == 0
                                                              ? 'สินค้าหมด '
                                                              : 'คงเหลือ ',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                          )),
                                                      remainAmt == 0
                                                          ? Container()
                                                          : Container(
                                                              decoration: BoxDecoration(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .backgroundColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5.0),
                                                                child: Text(
                                                                    '${NumberFormat("#,###.##").format(remainAmt)}',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
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
                            value: ddModelSelectedItems.isEmpty
                                ? null
                                : ddModelSelectedItems.last,
                            buttonWidth: 200,
                            itemPadding: EdgeInsets.zero,
                            selectedItemBuilder: (context) {
                              return ddModelSelectedItems.map(
                                (item) {
                                  final _isSelected =
                                      ddModelSelectedItems.contains(item);
                                  return Row(
                                    children: [
                                      Container(
                                        width: 280,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            padding: const EdgeInsets.all(8),
                                            itemCount:
                                                ddModelSelectedItems.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final indItem =
                                                  ddModelSelectedItems[index];
                                              // ??????asdsd
                                              return InkWell(
                                                onTap: () {
                                                  if (_isSelected == false) {
                                                    ddModelSelectedItems
                                                        .add(item);
                                                  } else {
                                                    ddModelSelectedItems
                                                        .remove(item);
                                                  }
                                                  setState(() {});
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    child: Container(
                                                      color: Theme.of(context)
                                                          .backgroundColor,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10,
                                                                right: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .check_outlined,
                                                              color:
                                                                  Colors.white,
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
                // Container of ListView ProuductLots
                Container(
                  width: 370,
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    Row(
                      children: [
                        Text(
                          "ขั้นตอนที่ 1 : ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "เลือกล็อตสินค้า",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                    Container(
                      width: 370,
                      height: 200,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: ddModelSelectedItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            final modelIndex = ddModelSelectedItems[index];

                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField2(
                                  validator: (value) {
                                    if (value == null) {
                                      return 'โปรดเลือกล็อตสินค้า';
                                    }
                                  },
                                  onChanged: (value) {
                                    lotSelectedValue = value as ProductLot;
                                    // if (prodAmountController.text.isNotEmpty) {
                                    //   int amount =
                                    //       int.parse(prodAmountController.text);
                                    //   _calculateTotal(selectedValue, amount);
                                    // }

                                    setState(() {});
                                  },
                                  onSaved: (value) {
                                    lotSelectedValue = value as ProductLot;

                                    setState(() {});
                                  },
                                  dropdownMaxHeight: 200,
                                  itemHeight: 70,
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
                                    _getLotRemainAmount(
                                                modelIndex.prodModelId) ==
                                            0
                                        ? '${modelIndex.stProperty} ${modelIndex.ndProperty} (ไม่มีล็อตสินค้า)'
                                        : '${modelIndex.stProperty} ${modelIndex.ndProperty} (${NumberFormat("#,###.##").format(_getLotRemainAmount(modelIndex.prodModelId))})',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                  iconSize: 30,
                                  buttonHeight: 70,
                                  buttonPadding: const EdgeInsets.only(
                                      left: 20, right: 10),
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.transparent,
                                    ),
                                    color:
                                        const Color.fromRGBO(56, 54, 76, 1.0),
                                  ),
                                  items: _dropDownProductLotItems(modelIndex),
                                  value: selectedItems.isEmpty
                                      ? null
                                      : selectedItems.last,
                                  buttonWidth: 200,
                                  itemPadding: EdgeInsets.zero,
                                ),
                              ),
                            );
                          }),
                    )
                  ]),
                ),

                // Container of จำนวนสินค้า

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
                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(SnackBar(
                                //   backgroundColor:
                                //       Theme.of(context).backgroundColor,
                                //   behavior: SnackBarBehavior.floating,
                                //   content: Row(
                                //     children: [
                                //       Icon(
                                //         Icons.shopping_cart_outlined,
                                //         color: Colors.white,
                                //       ),
                                //       ClipRRect(
                                //         borderRadius: BorderRadius.circular(30),
                                //         child: Container(
                                //           width: 20,
                                //           height: 20,
                                //           child: Image.file(
                                //             File(widget.product.prodImage!),
                                //             fit: BoxFit.cover,
                                //           ),
                                //         ),
                                //       ),
                                //       Container(
                                //         decoration: BoxDecoration(
                                //             color: Theme.of(context)
                                //                 .backgroundColor,
                                //             borderRadius:
                                //                 BorderRadius.circular(10)),
                                //         child: Padding(
                                //           padding: const EdgeInsets.all(3.0),
                                //           child: Text(
                                //             "+${prodAmountController.text}",
                                //             style: TextStyle(
                                //                 fontWeight: FontWeight.bold),
                                //           ),
                                //         ),
                                //       ),
                                //       Text(" ${widget.product.prodName} "),
                                //     ],
                                //   ),
                                //   duration: Duration(seconds: 5),
                                // ));
                                // final puritem = SellingItemModel(
                                //     amount:
                                //         int.parse(prodAmountController.text),
                                //     prodId: widget.product.prodId!,
                                //     prodModelId:
                                //         modelSelectedValue?.prodModelId,
                                //     prodLotId: lotSelectedValue?.prodLotId,
                                //     total: ptotal);
                                // widget.update(puritem);
                                // final updateAmountSelectedProductLot = ProductLot(

                                //         prodLotId: lotSelectedValue?.prodLotId,
                                //         amount: lotSelectedValue?.amount,
                                //         orderedTime:
                                //             lotSelectedValue?.orderedTime,
                                //         prodModelId:
                                //             lotSelectedValue?.prodModelId,
                                //         remainAmount:
                                //             lotSelectedValue!.remainAmount -
                                //                 int.parse(
                                //                     prodAmountController.text));
                                // await DatabaseManager.instance.updateProductLot(
                                //     updateAmountSelectedProductLot);
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

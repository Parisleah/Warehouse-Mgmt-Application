import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:intl/intl.dart';

import 'package:warehouse_mnmt/Page/Model/Product.dart';
import 'package:warehouse_mnmt/Page/Model/ProductCategory.dart';
import 'package:warehouse_mnmt/Page/Model/ProductLot.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel_stProperty.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel_ndProperty.dart';
import 'package:warehouse_mnmt/Page/Model/Shop.dart';
import 'package:warehouse_mnmt/Page/Shop/Buying/nav_showProduct.dart';

import '../../../db/database.dart';
import '../../Component/ImagePickerController.dart';
import '../../Component/ImagePickerWidget.dart';
import '../../Component/TextField/CustomTextField.dart';
import '../../Model/ProductModel_ndProperty.dart';

class ProductNavAdd extends StatefulWidget {
  final Shop shop;
  const ProductNavAdd({required this.shop, Key? key}) : super(key: key);

  @override
  State<ProductNavAdd> createState() => _ProductNavAddState();
}

class _ProductNavAddState extends State<ProductNavAdd> {
  ImagePickerController productImgController = ImagePickerController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productCategoryNameController = TextEditingController();
  TextEditingController productModel_stPropNameController =
      TextEditingController();
  TextEditingController productModel_ndPropNameController =
      TextEditingController();
  TextEditingController productModel_stPropListNameController =
      TextEditingController();
  TextEditingController productModel_ndPropListNameController =
      TextEditingController();
  List<TextEditingController> editCostControllers = [];
  List<TextEditingController> editPriceControllers = [];
  TextEditingController editAllCostController = TextEditingController();
  TextEditingController editAllPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshProductCategorys();

    setState(() {});
    print(
        'Welcome to ${widget.shop.name} -> Product Categorys -> ${productCategorys.length}');
    productNameController.addListener(() => setState(() {}));
    productCategoryNameController.addListener(() => setState(() {}));
    productDescriptionController.addListener(() => setState(() {}));
    productModel_stPropNameController.addListener(() => setState(() {}));
    productModel_ndPropNameController.addListener(() => setState(() {}));
    productModel_stPropListNameController.addListener(() => setState(() {}));
    productModel_ndPropListNameController.addListener(() => setState(() {}));
    editAllCostController.addListener(() => setState(() {}));
    editAllPriceController.addListener(() => setState(() {}));
  }

  // Product
  bool _validate = false;
  bool isDialogChooseFst = false;
  bool isDelete_ndProp = false;

  String stPropName = 'สี';
  String ndPropName = 'ขนาด';
  var productCategory = ProductCategory(prodCategName: 'เลือกหมวดหมู่สินค้า');
  List<ProductCategory> productCategorys = [];

  List<ProductModel> productModels = [];
  List<ProductModel_stProperty> stPropsList = [];
  List<ProductModel_ndProperty> ndPropsList = [];
  List<ProductLot> productLots = [];

  bool isFoundNullCost = false;
  bool isFoundNullPrice = false;
  showSnackBarIfEmpty(object) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating,
      content: Text("${object} ว่าง"),
      duration: Duration(seconds: 3),
    ));
  }

  Future _insertProduct(shop) async {
    if (productImgController.path == null) {
      showSnackBarIfEmpty('รูปสินค้า');
    } else if (productNameController.text.isEmpty) {
      showSnackBarIfEmpty('ชื่อสินค้า');
    } else if (productCategory.prodCategName == 'เลือกหมวดหมู่สินค้า') {
      showSnackBarIfEmpty('หมวดหมู่สินค้า');
    } else if (productNameController.text.isNotEmpty) {
      // Insert Product -> Database
      final product = Product(
          prodName: productNameController.text,
          prodDescription: productDescriptionController.text,
          prodImage: productImgController.path,
          prodCategId: productCategory.prodCategId == null
              ? null
              : productCategory.prodCategId,
          shopId: widget.shop.shopid!);
      // Inserted Get Product ID
      final prodInserted =
          await DatabaseManager.instance.createProduct(product);
      productModels.clear();
      var i = 0;
      for (var st in stPropsList) {
        for (var nd in ndPropsList) {
          final model = ProductModel(
              prodModelname: '${stPropName},${ndPropName}',
              stProperty: '${st.pmstPropName}',
              ndProperty: '${nd.pmndPropName}',
              cost: int.parse(editCostControllers[i].text),
              price: int.parse(editPriceControllers[i].text),
              prodId: prodInserted.prodId);
          productModels.add(model);
          editCostControllers.add(TextEditingController());
          editPriceControllers.add(TextEditingController());
          i++;
        }
      }
      setState(
        () {},
      );
      if (productModels.isEmpty) {
        print('Product Models is Empty');
      } else {
        print(
            '===================================================================\n MODEL');
        // Insert Product Models -> Database
        for (var model in productModels) {
          // Inserted Get Product Models ID
          final modelInserted =
              await DatabaseManager.instance.createProductModel(model);
          print(
              'MODEL INSERTED ->${modelInserted.prodModelId} ${modelInserted.prodModelname} ${modelInserted.stProperty} ${modelInserted.ndProperty}  ${modelInserted.cost} ${modelInserted.price} WHERE PRODUCT ID = ${modelInserted.prodId}');
          // Insert Product 1st Property -> Database
          print(
              '===================================================================\n 1st PROPERTY ');
          for (var st in stPropsList) {
            final new_st = ProductModel_stProperty(
                pmstPropName: st.pmstPropName,
                prodModelId: modelInserted.prodModelId);
            print(
                '${st.pmstPropName}   Product 1st Property (AFTER) ->${st.pmstPropId} ${new_st.pmstPropName} , ${new_st.prodModelId}');
            final get1stId =
                await DatabaseManager.instance.create1stProperty(new_st);
            print(
                'INSERTED | 1st Property -> [${get1stId.pmstPropId}, ${get1stId.pmstPropName}, ${get1stId.prodModelId}]');
          }

          print(
              'Product 1st Property ALL (${stPropsList.length}) : ${stPropsList}');
          print(
              '=======================================================================================================================================');

          // Insert Product 2nd Property -> Database
          print(
              '===================================================================\n 2nd PROPERTY ');
          for (var nd in ndPropsList) {
            final new_nd = ProductModel_ndProperty(
                pmndPropName: nd.pmndPropName,
                prodModelId: modelInserted.prodModelId);
            print(
                '${nd.pmndPropName}   Product 1st Property (AFTER) ->${nd.pmndPropId} ${new_nd.pmndPropName} , ${new_nd.prodModelId}');
            final get2ndId =
                await DatabaseManager.instance.create2ndProperty(new_nd);
            print(
                'INSERTED | 2nd Property -> [${get2ndId.pmndPropId}, ${get2ndId.pmndPropName}, ${get2ndId.prodModelId}]');
          }

          print(
              'Product 2nd Property ALL (${ndPropsList.length}) : ${ndPropsList}');
          print(
              '===================================================================\n 2nd PROPERTY');
        }
      }
      Navigator.pop(context);
    }
  }

  // Product
  _invalidationPriceController() {
    var found = 1;
    for (var c in editCostControllers) {
      for (var p in editPriceControllers) {
        if (c.text.isEmpty || p.text.isEmpty) {
          if (c.text.isEmpty) {
            print('[Cost ] Found Null in (${found})');
            isFoundNullCost = true;
            return found;
          } else {
            print('[Price] Found Null in (${found})');
            isFoundNullPrice = true;
            return found;
          }
        } else if (int.parse(c.text) > int.parse(p.text)) {
          isFoundNullCost = true;
          isFoundNullPrice = true;
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
            content: Text("ราคาขายน้อยกว่าต้นทุน (${found})"),
            duration: Duration(seconds: 3),
          ));
        } else {
          found++;
          isFoundNullCost = false;
          isFoundNullPrice = false;
          setState(() {});
        }
      }
    }
  }

  _addCostPriceInProdModel(stPropsList, ndPropsList) {
    setState(() {
      productModels.clear();
      var i = 0;
      for (var st in stPropsList) {
        for (var nd in ndPropsList) {
          final model = ProductModel(
              prodModelname: '${stPropName},${ndPropName}',
              stProperty: '${st.pmstPropName}',
              ndProperty: '${nd.pmndPropName}',
              cost: int.parse(editCostControllers[i].text),
              price: int.parse(editPriceControllers[i].text));
          productModels.add(model);
          editCostControllers.add(TextEditingController());
          editPriceControllers.add(TextEditingController());
          i++;
        }
      }
    });
  }

  // Product Model
  Future refreshProductCategorys() async {
    productCategorys = await DatabaseManager.instance
        .readAllProductCategorys(widget.shop.shopid!);
    productLots = await DatabaseManager.instance.readAllProductLots();
    setState(() {});
  }

  // Product
  _updateChooseProductCateg(ProductCategory _productCategory) {
    print(productCategory.prodCategName);

    setState(() {
      productCategory = _productCategory;
    });
  }

  _createProductModeltoSetPrice(stPropsList, ndPropsList) {
    for (var st in stPropsList) {
      if (stPropsList.isNotEmpty) {
        for (var nd in ndPropsList) {
          final model = ProductModel(
              prodModelname: '${stPropName},${ndPropName}',
              stProperty: '${st.pmstPropName}',
              ndProperty: '${nd.pmndPropName}',
              cost: 0,
              price: 0);
          productModels.add(model);
          editCostControllers.add(TextEditingController());
          editPriceControllers.add(TextEditingController());
        }
      } else {
        final model = ProductModel(
            prodModelname: '${stPropName}',
            stProperty: '${st.pmstPropName}',
            cost: 0,
            price: 0);
        productModels.add(model);
        editCostControllers.add(TextEditingController());
        editPriceControllers.add(TextEditingController());
      }
    }

    setState(() {});
  }

  // ราคาทั้งหมด
  Future<void> dialogEdit_PropCostPrice(TextEditingController pController,
      TextEditingController cController) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, Edit_st_PropDialogSetState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            title: Row(
              children: [
                Text(
                  'กำหนดราคาทั้งหมด',
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ))
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${stPropName}',
                          style: TextStyle(color: Colors.white),
                        ),
                        MultiSelectContainer(
                            textStyles: const MultiSelectTextStyles(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 255, 255, 255))),
                            prefix: MultiSelectPrefix(
                              selectedPrefix: const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                            itemsDecoration: MultiSelectDecorations(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    const Color.fromRGBO(56, 54, 76, 1.0),
                                    const Color.fromRGBO(56, 54, 76, 1.0),
                                  ]),
                                  borderRadius: BorderRadius.circular(20)),
                              selectedDecoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Theme.of(context).backgroundColor,
                                    Theme.of(context).backgroundColor,
                                  ]),
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            items: stPropsList
                                .map((item) => MultiSelectCard(
                                    value: '${item.pmstPropName}',
                                    label: '${item.pmstPropName}'))
                                .toList(),
                            onChange: (allSelectedItems, selectedItem) {}),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${ndPropName}',
                          style: TextStyle(color: Colors.white),
                        ),
                        MultiSelectContainer(
                            textStyles: const MultiSelectTextStyles(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 255, 255, 255))),
                            prefix: MultiSelectPrefix(
                              selectedPrefix: const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                            itemsDecoration: MultiSelectDecorations(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    const Color.fromRGBO(56, 54, 76, 1.0),
                                    const Color.fromRGBO(56, 54, 76, 1.0),
                                  ]),
                                  borderRadius: BorderRadius.circular(20)),
                              selectedDecoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Theme.of(context).backgroundColor,
                                    Theme.of(context).backgroundColor,
                                  ]),
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            items: ndPropsList
                                .map((item) => MultiSelectCard(
                                    value: '${item.pmndPropName}',
                                    label: '${item.pmndPropName}'))
                                .toList(),
                            onChange: (allSelectedItems, selectedItem) {}),
                      ],
                    ),
                  ),
                  ListBody(
                    children: <Widget>[
                      CustomTextField.textField(
                        context,
                        'ราคาต้นทุน',
                        _validate,
                        length: 30,
                        isNumber: true,
                        textController: cController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField.textField(
                        context,
                        'ราคาขาย',
                        _validate,
                        length: 30,
                        isNumber: true,
                        textController: pController,
                      )
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('ยืนยัน'),
                onPressed: () {
                  var cPrice = cController.text;
                  var pPrice = pController.text;
                  for (var c in editCostControllers) {
                    c.text = cPrice;
                  }
                  for (var p in editPriceControllers) {
                    p.text = pPrice;
                  }
                  setState(() {});

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  //CostPrice_Product_Dialog
  dialogProduct_CostPrice() async {
    await showDialog(
        context: context,
        builder: (BuildContext dContext2) {
          return StatefulBuilder(builder: (dContext2, DialogSetState) {
            return Dialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)), //th
              child: SizedBox(
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              // color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 300,
                                child: Row(
                                  children: [
                                    Text(
                                      'กำหนดราคา',
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 25,
                                        // fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          dialogEdit_PropCostPrice(
                                              editAllCostController,
                                              editAllPriceController);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.mode_edit_outline_sharp),
                                            Text('ทั้งหมด')
                                          ],
                                        )),
                                    Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          amountControllers.clear();
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // สี

                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              productModels.isEmpty
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background
                                              .withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height: 320,
                                      child: Expanded(
                                        child: Center(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.note_alt_outlined,
                                              color: Colors.grey,
                                              size: 20,
                                            ),
                                            Text(
                                              'ไม่มีรูปแบบสินค้า',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13),
                                            ),
                                          ],
                                        )),
                                      ),
                                    )
                                  : Stack(children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background
                                                .withOpacity(0.9),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        height: 320,
                                        child: ListView.builder(
                                            // scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.zero,
                                            itemCount: productModels.length,
                                            itemBuilder: (context, index) {
                                              final productModelInd =
                                                  productModels[index];

                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Column(children: [
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            '${index + 1}',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Theme.of(
                                                                        context)
                                                                    .backgroundColor),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .backgroundColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          3.0),
                                                                  child: Text(
                                                                      '${productModelInd.stProperty}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .white,
                                                                      )),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .backgroundColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          3.0),
                                                                  child: Text(
                                                                    '${productModelInd.ndProperty}',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Spacer(),
                                                          Positioned(
                                                            top: 0.0,
                                                            right: 0,
                                                            child: IconButton(
                                                              icon: const Icon(
                                                                  Icons.close,
                                                                  size: 25,
                                                                  color: Colors
                                                                      .grey),
                                                              onPressed: () {
                                                                DialogSetState(
                                                                  () {
                                                                    productModels.removeWhere((item) =>
                                                                        item.ndProperty ==
                                                                        productModelInd
                                                                            .ndProperty);
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            height: 60,
                                                            width: 130,
                                                            child:
                                                                CustomTextField
                                                                    .textField(
                                                              context,
                                                              'ต้นทุน',
                                                              _validate,
                                                              length: 10,
                                                              isNumber: true,
                                                              textController:
                                                                  editCostControllers[
                                                                      index],
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            height: 60,
                                                            width: 130,
                                                            child:
                                                                CustomTextField
                                                                    .textField(
                                                              context,
                                                              'ขาย',
                                                              _validate,
                                                              isNumber: true,
                                                              length: 10,
                                                              textController:
                                                                  editPriceControllers[
                                                                      index],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                    ]),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'รูปแบบสินค้าทั้งหมด',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:
                                              Theme.of(context).backgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            '${NumberFormat("#,###").format(productModels.length)}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Row(
                          mainAxisAlignment: productModels.isEmpty
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.redAccent,
                                    fixedSize: const Size(80, 40)),
                                onPressed: () {
                                  amountControllers.clear();
                                  productModels.clear();
                                  editCostControllers.clear();
                                  editPriceControllers.clear();

                                  Navigator.pop(context);

                                  setState(() {});
                                },
                                child: Text('ยกเลิก')),
                            productModels.isEmpty
                                ? Container(
                                    width: 0,
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(80, 40)),
                                    onPressed: () {
                                      var foundNullIndex =
                                          _invalidationPriceController();
                                      DialogSetState(
                                        () {},
                                      );

                                      if (isFoundNullCost || isFoundNullPrice) {
                                        ScaffoldMessenger.of(dContext2)
                                            .showSnackBar(SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.redAccent,
                                          content: Text(
                                              "ราคารูปแบบสินค้าที่(${foundNullIndex}) ว่าง"),
                                          duration: Duration(seconds: 3),
                                        ));
                                      } else {
                                        _addCostPriceInProdModel(
                                            stPropsList, ndPropsList);

                                        Navigator.pop(dContext2);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('ยืนยัน')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  Future<void> dialogEdit_PropName(TextEditingController controller) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, Edit_st_PropDialogSetState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            title: const Text(
              'แก้ไข',
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  CustomTextField.textField(
                    context,
                    isDialogChooseFst == true ? stPropName : ndPropName,
                    _validate,
                    length: 30,
                    textController: controller,
                  )
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('ยืนยัน'),
                onPressed: () {
                  Edit_st_PropDialogSetState(() {
                    if (controller.text.isEmpty) {
                    } else {
                      isDialogChooseFst == true
                          ? stPropName = controller.text
                          : ndPropName = controller.text;
                    }
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  dialogProductModel() async {
    await showDialog(
        context: context,
        useRootNavigator: false,
        builder: (BuildContext dContext1) {
          return StatefulBuilder(builder: (dContext1, DialogSetState) {
            return Dialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)), //th
              child: SizedBox(
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              // color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 300,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'สร้างรูปแบบสินค้า',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 25,
                                          // fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.grey,
                                          size: 25,
                                        ),
                                        onPressed: () {
                                          productModels.clear();
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // สี

                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      stPropName,
                                      style: const TextStyle(
                                          fontSize: 25, color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          DialogSetState(
                                            () {
                                              isDialogChooseFst = true;
                                            },
                                          );
                                          await dialogEdit_PropName(
                                              productModel_stPropNameController);
                                          DialogSetState(
                                            () {
                                              isDialogChooseFst = false;
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height: 60,
                                      width: 200,
                                      child: CustomTextField.textField(
                                        context,
                                        'ระบุ${stPropName}',
                                        _validate,
                                        length: 30,
                                        textController:
                                            productModel_stPropListNameController,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (productModel_stPropListNameController
                                            .text.isEmpty) {
                                          ScaffoldMessenger.of(dContext1)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.redAccent,
                                              content: Text(
                                                  "โปรดระบุชื่อรูปแบบ ${stPropName} สินค้า"),
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                        } else {
                                          final stProp =
                                              ProductModel_stProperty(
                                            pmstPropName:
                                                productModel_stPropListNameController
                                                    .text,
                                          );

                                          DialogSetState(
                                            () {
                                              stPropsList.add(stProp);
                                            },
                                          );
                                          // print(
                                          //     'Add Prod Prod Model Property 1st : [${prodCategory.prodCategId}, ${prodCategory.prodCategName} ${prodCategory.shopId}] Data Type? -> ${prodCategory.shopId.runtimeType}');

                                          productModel_stPropListNameController
                                              .clear();

                                          DialogSetState(() {
                                            refreshProductCategorys();
                                          });
                                        }
                                      },
                                      child: Row(children: const [
                                        Icon(
                                          Icons.add_rounded,
                                          color: Colors.white,
                                        ),
                                        Text('เพิ่ม'),
                                      ]),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                stPropsList.isEmpty
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background
                                                .withOpacity(0.9),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        height: 160,
                                        child: Expanded(
                                          child: Center(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.note_alt_outlined,
                                                color: Colors.grey,
                                                size: 20,
                                              ),
                                              Text(
                                                'ไม่มี ${stPropName} สินค้า',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 13),
                                              ),
                                            ],
                                          )),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background
                                                .withOpacity(0.9),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        height: 160,
                                        child: ListView.builder(
                                            // scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.zero,
                                            itemCount: stPropsList.length,
                                            itemBuilder: (context, index) {
                                              final stPropsListInd =
                                                  stPropsList[index];
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Container(
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Row(children: [
                                                        Text(
                                                          stPropsListInd
                                                              .pmstPropName,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        const Spacer(),
                                                        IconButton(
                                                            onPressed: () {
                                                              stPropsList.removeWhere((item) =>
                                                                  item.pmstPropName ==
                                                                  stPropsListInd
                                                                      .pmstPropName);
                                                              DialogSetState(
                                                                  () {
                                                                stPropsList =
                                                                    stPropsList;
                                                              });
                                                            },
                                                            icon: const Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.white,
                                                            ))
                                                      ]),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        // ขนาด
                        isDelete_ndProp == true
                            ? ElevatedButton(
                                child: Row(
                                  children: [
                                    Icon(Icons.add_rounded,
                                        size: 25,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                    Text(
                                      'เพิ่มอีกรูปแบบ',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  DialogSetState(
                                    () {
                                      isDelete_ndProp = false;
                                    },
                                  );
                                },
                              )
                            : Stack(children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 300,
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              ndPropName,
                                              style: const TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            IconButton(
                                                onPressed: () async {
                                                  DialogSetState(
                                                    () {
                                                      isDialogChooseFst ==
                                                          false;
                                                    },
                                                  );
                                                  await dialogEdit_PropName(
                                                      productModel_ndPropNameController);
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                ))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              height: 60,
                                              width: 200,
                                              child: CustomTextField.textField(
                                                context,
                                                'ระบุ${ndPropName}',
                                                _validate,
                                                length: 30,
                                                textController:
                                                    productModel_ndPropListNameController,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                if (productModel_ndPropListNameController
                                                    .text.isEmpty) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      content: Text(
                                                          "โปรดระบุชื่อรูปแบบ ${ndPropName} สินค้า"),
                                                      duration:
                                                          Duration(seconds: 3),
                                                    ),
                                                  );
                                                } else {
                                                  final ndProp =
                                                      ProductModel_ndProperty(
                                                    pmndPropName:
                                                        productModel_ndPropListNameController
                                                            .text,
                                                  );

                                                  DialogSetState(
                                                    () {
                                                      ndPropsList.add(ndProp);
                                                    },
                                                  );
                                                  // print(
                                                  //     'Add Prod Prod Model Property 1st : [${prodCategory.prodCategId}, ${prodCategory.prodCategName} ${prodCategory.shopId}] Data Type? -> ${prodCategory.shopId.runtimeType}');

                                                  productModel_ndPropListNameController
                                                      .clear();

                                                  DialogSetState(() {});
                                                }
                                              },
                                              child: Row(children: const [
                                                Icon(
                                                  Icons.add_rounded,
                                                  color: Colors.white,
                                                ),
                                                Text('เพิ่ม'),
                                              ]),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ndPropsList.isEmpty
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .background
                                                        .withOpacity(0.9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                height: 160,
                                                child: Expanded(
                                                  child: Center(
                                                      child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.note_alt_outlined,
                                                        color: Colors.grey,
                                                        size: 20,
                                                      ),
                                                      Text(
                                                        'ไม่มี ${ndPropName} สินค้า',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 13),
                                                      ),
                                                    ],
                                                  )),
                                                ),
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .background
                                                        .withOpacity(0.9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                height: 160,
                                                child: ListView.builder(
                                                    // scrollDirection: Axis.horizontal,
                                                    padding: EdgeInsets.zero,
                                                    itemCount:
                                                        ndPropsList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final ndPropsListInd =
                                                          ndPropsList[index];
                                                      return GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Container(
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
                                                              child: Row(
                                                                  children: [
                                                                    Text(
                                                                      ndPropsListInd
                                                                          .pmndPropName,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    const Spacer(),
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          ndPropsList.removeWhere((item) =>
                                                                              item.pmndPropName ==
                                                                              ndPropsListInd.pmndPropName);
                                                                          DialogSetState(
                                                                              () {
                                                                            ndPropsList =
                                                                                ndPropsList;
                                                                          });
                                                                        },
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color:
                                                                              Colors.white,
                                                                        ))
                                                                  ]),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0.0,
                                  right: 0,
                                  child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              spreadRadius: 0,
                                              blurRadius: 5,
                                              offset: Offset(0, 4))
                                        ],
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.close,
                                            size: 25,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)),
                                        onPressed: () {
                                          DialogSetState(
                                            () {
                                              ndPropsList.clear();
                                              isDelete_ndProp = true;
                                            },
                                          );
                                        },
                                      )),
                                ),
                              ]),
                        SizedBox(
                          height: 20,
                        ),
                        Wrap(
                          spacing: 10,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.redAccent,
                                    fixedSize: const Size(80, 40)),
                                onPressed: () {
                                  productModels.clear();
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: Text('ยกเลิก')),
                            stPropsList.isEmpty
                                ? Container(
                                    width: 0,
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(80, 40)),
                                    onPressed: () {
                                      productModels.clear();
                                      editCostControllers.clear();
                                      editPriceControllers.clear();
                                      DialogSetState(
                                        () {},
                                      );

                                      _createProductModeltoSetPrice(
                                          stPropsList, ndPropsList);

                                      DialogSetState(
                                        () {},
                                      );
                                      // Setprice
                                      dialogProduct_CostPrice();
                                    },
                                    child: Text('สร้าง')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  dialogProductCategory() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (prodCategContext, DialogSetState) {
            return Dialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)), //th
              child: SizedBox(
                height: 350,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              // color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'เลือกหมวดหมู่สินค้า',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 25,
                                  // fontWeight: FontWeight.bold),
                                ),
                              ),
                              Spacer(),
                              // IconButton(
                              //   icon: const Icon(
                              //     Icons.add_rounded,
                              //     color: Colors.white,
                              //     size: 25,
                              //   ),
                              //   onPressed: () {},
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              height: 60,
                              width: 200,
                              child: CustomTextField.textField(
                                context,
                                'เช่น เสื้อ กางเกง...',
                                _validate,
                                length: 20,
                                textController: productCategoryNameController,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (productCategoryNameController
                                    .text.isEmpty) {
                                  ScaffoldMessenger.of(prodCategContext)
                                      .showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.redAccent,
                                      content:
                                          Text("โปรดตั้งชื่อหมวดหมู่สินค้า"),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                } else {
                                  final prodCategory = ProductCategory(
                                    prodCategName:
                                        productCategoryNameController.text,
                                    shopId: widget.shop.shopid!,
                                  );

                                  await DatabaseManager.instance
                                      .createProductCategory(prodCategory);
                                  productCategoryNameController.clear();
                                  setState(() {});
                                  refreshProductCategorys();

                                  DialogSetState(() {});
                                }
                              },
                              child: Row(children: const [
                                Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                ),
                                Text('เพิ่ม'),
                              ]),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        productCategorys.isEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background
                                        .withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(10)),
                                height: 200,
                                child: Expanded(
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.note_alt_outlined,
                                        color: Colors.grey,
                                        size: 35,
                                      ),
                                      Text(
                                        'ไม่มีหมวดหมู่สินค้า',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 30),
                                      ),
                                    ],
                                  )),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background
                                        .withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(10)),
                                height: 200,
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: productCategorys.length,
                                    itemBuilder: (context, index) {
                                      final productCategory =
                                          productCategorys[index];
                                      return GestureDetector(
                                        onTap: () {
                                          _updateChooseProductCateg(
                                              productCategory);
                                          print(productCategory.prodCategName);
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .backgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Row(children: [
                                                Text(
                                                  productCategory.prodCategName,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const Spacer(),
                                                IconButton(
                                                    onPressed: () async {
                                                      await DatabaseManager
                                                          .instance
                                                          .deleteProductCategory(
                                                              productCategory
                                                                  .prodCategId!);
                                                      DialogSetState(() {
                                                        refreshProductCategorys();
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                    ))
                                              ]),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            title: const Text(
              "เพิ่มสินค้า",
              textAlign: TextAlign.start,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            // decoration: BoxDecoration(
            //     gradient: scafBG_dark_Color),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 10,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: ImagePickerWidget(controller: productImgController),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'ชื่อสินค้า',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  CustomTextField.textField(
                    context,
                    'ระบุชื่อสินค้า',
                    _validate,
                    length: 30,
                    textController: productNameController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'หมวดหมู่สินค้า',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      dialogProductCategory();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0.9),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(children: [
                        Text(
                          productCategory.prodCategName,
                          style: TextStyle(color: Colors.grey),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        )
                      ]),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'รายละเอียดสินค้า',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  CustomTextField.textField(
                    context,
                    'ระบุรายละเอียดสินค้า',
                    _validate,
                    length: 100,
                    textController: productDescriptionController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'รูปแบบสินค้า',
                        style: TextStyle(color: Colors.white),
                      ),
                      Spacer(),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent,
                          ),
                          onPressed: () {
                            productModels.clear();
                            setState(() {});
                          },
                          child: Icon(Icons.delete_sweep_rounded)),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            dialogProductModel();
                          },
                          child: Icon(Icons.add_rounded))
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15)),
                    width: 400,
                    height: 240,
                    child: Column(
                      children: [
                        productModels.isEmpty
                            ? Expanded(
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.note_alt_outlined,
                                      color: Colors.grey,
                                      size: 35,
                                    ),
                                    Text(
                                      'ไม่มีรูปแบบสินค้า',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 30),
                                    ),
                                  ],
                                )),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background
                                        .withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(10)),
                                height: 200,
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: productModels.length,
                                    itemBuilder: (context, index) {
                                      final productModel = productModels[index];
                                      var _amountOfProd = 0;
                                      for (var lot in productLots) {
                                        if (productModel.prodModelId ==
                                            lot.prodModelId) {
                                          _amountOfProd +=
                                              int.parse(lot.amount!);
                                        }
                                      }
                                      var amountOfProd = _amountOfProd;
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Row(children: [
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${index + 1}',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Theme.of(
                                                                      context)
                                                                  .backgroundColor),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .background,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: Text(
                                                              '${productModel.stProperty}',
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .background,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: Text(
                                                              '${productModel.ndProperty}',
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      'ต้นทุน ${NumberFormat("#,###,###.##").format(productModel.cost)} ฿',
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      'ราคาขาย ${NumberFormat("#,###,###.##").format(productModel.price)} ฿',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                amountOfProd == 0
                                                    ? Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .numbers_outlined,
                                                            color: Colors.white,
                                                          ),
                                                          Text('สินค้าหมด ',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        ],
                                                      )
                                                    : Container(
                                                        decoration: BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .background,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Row(
                                                            children: [
                                                              Text('คงเหลือ ',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                              Text(
                                                                  '${NumberFormat("#,###.##").format(amountOfProd)}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                              ]),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'จำนวนสินค้าทั้งหมด',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background
                                        .withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                    '${NumberFormat("#,###").format(productModels.length)}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 200,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent,
                              fixedSize: const Size(80, 40)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('ยกเลิก')),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(80, 40)),
                          onPressed: () async {
                            _insertProduct(widget.shop);
                          },
                          child: Text('ยืนยัน')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

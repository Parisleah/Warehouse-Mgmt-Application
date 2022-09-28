import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:warehouse_mnmt/Page/Component/ImagePicker.dart';
import 'package:warehouse_mnmt/Page/Model/ProductCategory.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel_stProperty.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel_stPropertyList.dart';
import 'package:warehouse_mnmt/Page/Model/Shop.dart';

import '../../../db/database.dart';
import '../../Component/ImagePickerController.dart';
import '../../Component/TextField/CustomTextField.dart';
import '../../Component/searchBox.dart';
import '../../Model/ProductModel_ndProperty.dart';
import '../../Model/ProductModel_ndPropertyList.dart';

class ProductNavAdd extends StatefulWidget {
  final Shop shop;
  const ProductNavAdd({required this.shop, Key? key}) : super(key: key);

  @override
  State<ProductNavAdd> createState() => _ProductNavAddState();
}

class _ProductNavAddState extends State<ProductNavAdd> {
  ImagePickerController controller = ImagePickerController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDetailController = TextEditingController();
  TextEditingController productCategoryNameController = TextEditingController();
  // First Property
  TextEditingController productModel_stPropNameController =
      TextEditingController();
  TextEditingController productModel_ndPropNameController =
      TextEditingController();
// Second Property
  TextEditingController productModel_stPropListNameController =
      TextEditingController();
  TextEditingController productModel_ndPropListNameController =
      TextEditingController();

  TextEditingController editAllCostController = TextEditingController();
  TextEditingController editAllPriceController = TextEditingController();

  // @override
  // void initState() {
  //   // super.initState();
  //   // refreshProductCategorys();
  //   productNameController.addListener(() => setState(() {}));
  //   productCategoryNameController.addListener(() => setState(() {}));
  // }
  bool _validate = false;
  bool isDialogChooseFst = false;
  bool isDelete_ndProp = false;

  // Product
  String stPropName = 'สี';
  String ndPropName = 'ขนาด';
  List<ProductCategory> productCategorys = [];
  // Product Model

  List<ProductModel> productModels = [];

  List<ProductModel_stPropertyList> stPropsList = [];
  List<ProductModel_ndPropertyList> ndPropsList = [];

  Future<void> _showEdit_PropCostPrice_Dialog(TextEditingController pController,
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
              child: ListBody(
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
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('ยืนยัน'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  _addTempProductModel(stProperty, ndProperty, stPropsList, ndPropsList) {
    int round;
    if (ndProperty == null) {
      round = stPropsList.length;
    } else {
      round = stPropsList.length * ndPropsList.length;
      print(stPropsList);
      print(ndPropsList);
      for (var i = 0; i < round; i++) {
        final stPropsInd = stPropsList[i];
        for (var j = 0; j < ndPropsList.length; j++) {
          final ndPropsInd = ndPropsList[j];
          final model = ProductModel(
              prodModelname:
                  '${stPropsInd.pmstPropListName} + ${ndPropsInd.pmndPropListName}',
              stProperty: i,
              ndProperty: j,
              cost: 0,
              price: 0);
          productModels.add(model);
        }
      }
      setState(() {
        productModels = productModels;
      });
    }
  }

  // Product Model

  Future refreshProductCategorys() async {
    productCategorys = await DatabaseManager.instance.readAllProductCategorys();
    setState(() {});
  }
  // Product

  String productCategory = 'เลือกประเภทสินค้า';
  _updateChooseProductCateg(txt) {
    setState(() {
      productCategory = txt;
    });
  }

  //_showSet_CostPrice_Product_Dialog
  _showSet_CostPrice_Product_Dialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, DialogSetState) {
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
                              const SizedBox(
                                width: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'กำหนดราคา',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 25,
                                      // fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      )),
                                ],
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
                                      height: 450,
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
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background
                                              .withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height: 450,
                                      child: ListView.builder(
                                          // scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.zero,
                                          itemCount: productModels.length,
                                          itemBuilder: (context, index) {
                                            final productModelInd =
                                                productModels[index];
                                            return GestureDetector(
                                              onTap: () {
                                                // _updateChooseProductCateg(
                                                //     productCategory.prodCategName);
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
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Column(children: [
                                                    Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          productModelInd
                                                              .prodModelname
                                                              .split('+')[0],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          productModelInd
                                                              .prodModelname
                                                              .split('+')[1],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          height: 60,
                                                          width: 110,
                                                          child: CustomTextField
                                                              .textField(
                                                            context,
                                                            'ต้นทุน',
                                                            _validate,
                                                            length: 30,
                                                            isNumber: true,
                                                            textController:
                                                                productModel_stPropListNameController,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 1,
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          height: 60,
                                                          width: 110,
                                                          child: CustomTextField
                                                              .textField(
                                                            context,
                                                            'ขาย',
                                                            _validate,
                                                            isNumber: true,
                                                            length: 30,
                                                            textController:
                                                                productModel_stPropListNameController,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ]),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 20,
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
                                onPressed: () {
                                  // Setprice
                                  _showSet_CostPrice_Product_Dialog();
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

  Future<void> _showEdit_PropName_Dialog(
      TextEditingController controller) async {
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

  showProductModelDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, DialogSetState) {
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
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'สร้างรูปแบบสินค้า',
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
                                          await _showEdit_PropName_Dialog(
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
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.redAccent,
                                              content: Text(
                                                  "โปรดระบุชื่อรูปแบบ ${stPropName} สินค้า"),
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                        } else {
                                          final stPropList =
                                              ProductModel_stPropertyList(
                                            pmstPropListName:
                                                productModel_stPropListNameController
                                                    .text,
                                          );

                                          DialogSetState(
                                            () {
                                              stPropsList.add(stPropList);
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
                                                  // _updateChooseProductCateg(
                                                  //     productCategory.prodCategName);
                                                  Navigator.pop(context);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Container(
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
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
                                                              .pmstPropListName,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        const Spacer(),
                                                        IconButton(
                                                            onPressed: () {
                                                              stPropsList.removeWhere((item) =>
                                                                  item.pmstPropListName ==
                                                                  stPropsListInd
                                                                      .pmstPropListName);
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
                                                  await _showEdit_PropName_Dialog(
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
                                                  final ndPropList =
                                                      ProductModel_ndPropertyList(
                                                    pmndPropListName:
                                                        productModel_ndPropListNameController
                                                            .text,
                                                  );

                                                  DialogSetState(
                                                    () {
                                                      ndPropsList
                                                          .add(ndPropList);
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
                                                          // _updateChooseProductCateg(
                                                          //     productCategory.prodCategName);
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
                                                                color:
                                                                    Colors.red,
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
                                                                          .pmndPropListName,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    const Spacer(),
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          ndPropsList.removeWhere((item) =>
                                                                              item.pmndPropListName ==
                                                                              ndPropsListInd.pmndPropListName);
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
                                      _addTempProductModel(stPropName,
                                          ndPropName, stPropsList, ndPropsList);
                                      DialogSetState(
                                        () {},
                                      );
                                      // Setprice
                                      _showSet_CostPrice_Product_Dialog();
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

  showProductCategoryDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, DialogSetState) {
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
                                'เลือกประเภทสินค้า',
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
                                'ระบุชื่อประเภทสินค้า',
                                _validate,
                                length: 30,
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.redAccent,
                                      content: Text("โปรดตั้งชื่อประเภทสินค้า"),
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
                                        'ไม่มีประเภทสินค้า',
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
                                              productCategory.prodCategName);
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
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
                    child: ImagePickerWidget(controller: controller),
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
                        'ประเภทสินค้า',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      showProductCategoryDialog();
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
                          productCategorys.isEmpty
                              ? 'โปรดเลือกประเภทสินค้า'
                              : productCategory,
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
                    textController: productDetailController,
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
                            setState(() {
                              productModels.clear();
                            });
                          },
                          child: Icon(Icons.delete_sweep_rounded)),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            showProductModelDialog();
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
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Row(children: [
                                                Text(
                                                  productModel.prodModelname,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Spacer(),
                                                IconButton(
                                                    onPressed: () {
                                                      productModels.removeWhere(
                                                          (item) =>
                                                              item.prodModelname ==
                                                              productModel
                                                                  .prodModelname);
                                                    },
                                                    icon: Icon(
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
                          onPressed: () {
                            Navigator.pop(context);
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

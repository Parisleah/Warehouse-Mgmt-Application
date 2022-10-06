import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:warehouse_mnmt/Page/Model/Product.dart';
import 'package:warehouse_mnmt/Page/Model/ProductCategory.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel_stProperty.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel_ndProperty.dart';
import 'package:warehouse_mnmt/Page/Model/Shop.dart';

import '../../../db/database.dart';
import '../../Component/ImagePickerController.dart';
import '../../Component/TextField/CustomTextField.dart';
import '../../Model/ProductModel_ndProperty.dart';

class ProductNavEdit extends StatefulWidget {
  final Shop shop;
  final Product product;
  final ProductCategory prodCategory;

  const ProductNavEdit(
      {required this.product,
      required this.prodCategory,
      required this.shop,
      Key? key})
      : super(key: key);

  @override
  State<ProductNavEdit> createState() => _ProductNavEditState();
}

class _ProductNavEditState extends State<ProductNavEdit> {
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
  List<ProductModel> productModels = [];
  @override
  void initState() {
    super.initState();
    refreshProductCategorys();
    refreshProductModels();
    setState(() {});
    print(
        'Welcome to ${widget.shop.name} -> Product Categorys -> ${productCategorys.length}');
    productNameController.addListener(() => setState(() {}));

    productCategoryNameController.addListener(() => setState(() {}));
  }

  // Product
  bool _validate = false;
  bool isDialogChooseFst = false;
  bool isDelete_ndProp = false;
  File? _image;
  String stPropName = 'สี';
  String ndPropName = 'ขนาด';
  var productCategory = ProductCategory(prodCategName: 'เลือกประเภทสินค้า');
  List<ProductCategory> productCategorys = [];
  // Product Model

  List<ProductModel_stProperty> stPropsList = [];
  // Product Model
  Future refreshProductModels() async {
    productModels = await DatabaseManager.instance
        .readAllProductModelsInProduct(widget.product.prodId!);
    print(productModels);
    setState(() {});
  }

  List<ProductModel_ndProperty> ndPropsList = [];

  bool isFoundNullCost = false;
  bool isFoundNullPrice = false;
  showSnackBarIfEmpty(object) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text("${object} ว่าง"),
      duration: Duration(seconds: 3),
    ));
  }

  Future getImage(isChange) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;
    final imageTemporary = File(image.path);
    print(_image);
    print(_image.runtimeType);
    isChange = true;
    setState(() {
      _image = imageTemporary;
    });
  }

  Future _updateProduct(shop) async {
    final product = Product(
        prodName: productNameController.text,
        prodDescription: productDescriptionController.text,
        prodImage: productImgController.path,
        prodCategId: productCategory.prodCategId == null
            ? null
            : productCategory.prodCategId,
        shopId: widget.shop.shopid!);
    print(
        'UPDATE PRODUCT -> [${product.prodId}, ${product.prodName}, ${product.prodDescription}, ${product.prodCategId} WHERE ${product.shopId}]');
    await DatabaseManager.instance.updateProduct(product);
    Navigator.pop(context);
  }

  // Product
  _checkNullPriceController() {
    var cIndex = 1;
    var pIndex = 1;
    for (var i in editCostControllers) {
      if (i.text.isEmpty) {
        print('Found Null in Cost -> ${i} ');
        isFoundNullCost = true;
        return cIndex;

        break;
      } else {
        cIndex++;
        isFoundNullCost = false;
      }
    }
    for (var i in editPriceControllers) {
      if (i.text.isEmpty) {
        print('Found Null in Price ->  ${i}');
        isFoundNullPrice = true;
        return pIndex;
        break;
      } else {
        pIndex++;
        isFoundNullPrice = false;
      }
    }
  }

  _addCostPriceInProdModel(stPropsList, ndPropsList) {
    setState(() {
      productModels.clear();
      var i = 0;
      for (var st in stPropsList) {
        for (var nd in ndPropsList) {
          print('st ->${st.pmstPropName} nd -> ${nd.pmndPropName}');
          final model = ProductModel(
              prodModelname: '${stPropName},${ndPropName}',
              stProperty: '${st.pmstPropName}',
              ndProperty: '${nd.pmndPropName}',
              cost: int.parse(editCostControllers[i].text),
              price: int.parse(editPriceControllers[i].text));
          productModels.add(model);
          editCostControllers.add(TextEditingController());
          editPriceControllers.add(TextEditingController());
          print(' Add [${model.prodModelname}]');
          print(' Add [${productModels}]');
          print(
              'UPDATE -> [${i}, ${productModels[i].cost}, ${productModels[i].price}]');
          i++;
        }
      }
    });
  }

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

  _addTempProductModel(stPropsList, ndPropsList) {
    for (var st in stPropsList) {
      if (ndPropsList.isNotEmpty) {
        for (var nd in ndPropsList) {
          print('st ->${st.pmstPropName} nd -> ${nd.pmndPropName}');
          final model = ProductModel(
              prodModelname: '${stPropName},${ndPropName}',
              stProperty: '${st.pmstPropName}',
              ndProperty: '${nd.pmndPropName}',
              cost: 0,
              price: 0);
          productModels.add(model);
          editCostControllers.add(TextEditingController());
          editPriceControllers.add(TextEditingController());
          print(' Add [${model.prodModelname}]');
          print(' Add [${productModels}]');
        }
      } else {
        final model = ProductModel(
            prodModelname: '${st.pmstPropName}',
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

  // Product Model
  Future refreshProductCategorys() async {
    productCategorys = await DatabaseManager.instance
        .readAllProductCategorys(widget.shop.shopid!);
    setState(() {});
  }

  // Product
  _updateChooseProductCateg(ProductCategory _productCategory) {
    print(productCategory.prodCategName);

    setState(() {
      productCategory = _productCategory;
    });
  }

  //_showSet_CostPrice_Product_Dialog
  _showSet_CostPrice_Product_Dialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext dContext) {
          return StatefulBuilder(builder: (context, DialogSetState) {
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
                                          _showEdit_PropCostPrice_Dialog(
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
                                                          Text(
                                                            productModelInd
                                                                .prodModelname,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white),
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
                                                                        item.prodModelname ==
                                                                        productModelInd
                                                                            .prodModelname);
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
                                              BorderRadius.circular(10)),
                                      child: Text(
                                          '${NumberFormat("#,###").format(productModels.length)}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
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
                                  productModels.clear();

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
                                      // Setprice
                                      var foundNull =
                                          _checkNullPriceController();
                                      print(isFoundNullCost);
                                      print(isFoundNullPrice);

                                      if (isFoundNullCost || isFoundNullPrice) {
                                        ScaffoldMessenger.of(dContext)
                                            .showSnackBar(SnackBar(
                                          backgroundColor: Colors.redAccent,
                                          content: Text(
                                              "รูปแบบสินค้าที่ (${foundNull}) ว่าง"),
                                          duration: Duration(seconds: 3),
                                        ));
                                      } else {
                                        _addCostPriceInProdModel(
                                            stPropsList, ndPropsList);
                                        isFoundNullCost = false;
                                        isFoundNullPrice = false;
                                        DialogSetState(() {});
                                        Navigator.pop(dContext);
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
        useRootNavigator: false,
        builder: (BuildContext createProdModelDialogcontext) {
          return StatefulBuilder(
              builder: (createProdModelDialogcontext, DialogSetState) {
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
                                          Navigator.pop(context);
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
                                          ScaffoldMessenger.of(
                                                  createProdModelDialogcontext)
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
                                              ProductModel_stProperty(
                                            pmstPropName:
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
                                                      ProductModel_ndProperty(
                                                    pmndPropName:
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
                                },
                                child: Text('ยกเลิก')),
                            stPropsList.isEmpty
                                ? Container(
                                    width: 0,
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(80, 40)),
                                    onPressed: () async {
                                      productModels.clear();

                                      _addTempProductModel(
                                          stPropsList, ndPropsList);

                                      DialogSetState(
                                        () {},
                                      );
                                      // Setprice
                                      await _showSet_CostPrice_Product_Dialog();
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

  showProductCategoryDialog() async {
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
                                  Navigator.pop(context);

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
              "แก้ไขสินค้า",
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
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Stack(
                        children: [
                          if (_image != null)
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  _image!,
                                  width: 180,
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          else
                            Center(
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
                          Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.7),
                                        spreadRadius: 0,
                                        blurRadius: 5,
                                        offset: Offset(0, 4))
                                  ],
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 25,
                                      color: Color.fromARGB(255, 94, 94, 94)),
                                  onPressed: () async {
                                    // await getImage(isChange);
                                    // DialogSetState(() {
                                    //   isChange = !isChange;
                                    // });
                                    // if (_image!.path != null) {}
                                  },
                                )),
                          ),
                        ],
                      ),
                    ),
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
                    widget.product.prodName,
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
                          widget.prodCategory.prodCategName,
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
                    widget.product.prodDescription == null ||
                            widget.product.prodDescription == ''
                        ? 'เพิ่มรายละเอียดสินค้า'
                        : widget.product.prodDescription!,
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
                                                Text(
                                                  '${index + 1}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Theme.of(context)
                                                          .backgroundColor),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .background,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Text(
                                                      '${productModel.stProperty}',
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .background,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Text(
                                                      '${productModel.ndProperty}',
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  '${NumberFormat("#,###,###.##").format(productModel.cost)} ฿',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  '${NumberFormat("#,###,###.##").format(productModel.price)} ฿',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Spacer(),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: Colors
                                                                .transparent),
                                                    onPressed: () {
                                                      productModels.removeWhere(
                                                          (item) =>
                                                              item.ndProperty ==
                                                              productModel
                                                                  .ndProperty);
                                                      setState(() {});
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                    )),
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
                            _updateProduct(widget.shop);
                          },
                          child: Text('บันทึก')),
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

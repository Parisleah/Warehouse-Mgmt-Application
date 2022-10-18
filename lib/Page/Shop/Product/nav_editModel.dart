import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warehouse_mnmt/Page/Component/TextField/CustomTextField.dart';
import 'package:warehouse_mnmt/Page/Model/Dealer.dart';
import 'package:warehouse_mnmt/Page/Model/ProductLot.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel.dart';
import 'package:warehouse_mnmt/db/database.dart';

import '../../Model/Shop.dart';

class ProductEditModel extends StatefulWidget {
  final ProductModel model;
  const ProductEditModel({required this.model, Key? key}) : super(key: key);

  @override
  State<ProductEditModel> createState() => _ProductEditModelState();
}

class _ProductEditModelState extends State<ProductEditModel> {
  // Text Field
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  // Model Edit
  TextEditingController propertyName = TextEditingController();
  TextEditingController stProperty = TextEditingController();
  TextEditingController ndPropertty = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<ProductModel> productModels = [];
  List<ProductLot> productLots = [];
  bool _validate = false;
  final df = new DateFormat('dd-MM-yyyy');
  Future refreshProductModels() async {
    productModels = await DatabaseManager.instance.readAllProductModels();
    setState(() {});
  }

  Future refreshProductLot() async {
    productLots = await DatabaseManager.instance
        .readAllProductLotsByModelID(widget.model.prodModelId!);

    setState(() {});
  }

  bool _validateController = false;
  void initState() {
    super.initState();
    refreshProductLot();
    nameController.addListener(() => setState(() {}));
    addressController.addListener(() => setState(() {}));
    phoneController.addListener(() => setState(() {}));
  }

  // Text Field
  _alertNullTextController(title) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
        content: Text("${title} ว่าง"),
        duration: Duration(seconds: 3)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
          title: Column(
            children: [
              Text(
                "แก้ไขแบบสินค้า",
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
          child: Column(children: [
            SizedBox(height: 80),
            Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.model.prodModelname.split(',')[0]}',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                CustomTextField.textField(
                  context,
                  '${widget.model.stProperty}',
                  _validate,
                  length: 30,
                  textController: stProperty,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.model.prodModelname.split(',')[1]}',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                CustomTextField.textField(
                  context,
                  '${widget.model.ndProperty}',
                  _validate,
                  length: 30,
                  textController: ndPropertty,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'ต้นทุน',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                CustomTextField.textField(
                  context,
                  '${widget.model.cost}',
                  _validate,
                  length: 20,
                  textController: costController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'ราคาขาย',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                CustomTextField.textField(
                  context,
                  '${widget.model.price}',
                  _validate,
                  length: 20,
                  textController: priceController,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            productLots.isEmpty
                ? Container(
                    height: (MediaQuery.of(context).size.height * 0.5),
                    child: Center(
                      child: Text(
                        'ไม่มีล็อต',
                        style: TextStyle(color: Colors.grey, fontSize: 25),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10)),
                    height: 300,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: productLots.length,
                        itemBuilder: (context, index) {
                          final lot = productLots[index];

                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) async {
                              // await DatabaseManager.instance
                              //     .deleteProduct(product.prodId!);
                              // showAlertDeleteProductModel(
                              //     productModel);
                              refreshProductModels();
                              setState(() {});
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.redAccent,
                                content: Text("ลบสินค้า???????"),
                                duration: Duration(seconds: 2),
                              ));
                            },
                            direction: DismissDirection.endToStart,
                            resizeDuration: Duration(seconds: 1),
                            background: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
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
                                margin: EdgeInsets.only(
                                    left: 0, top: 10, right: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(10))),
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     new MaterialPageRoute(
                                //         builder: (context) => ProductEditModel()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
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
                                                      const EdgeInsets.all(3.0),
                                                  child: Text(
                                                    'ล็อตที่ ${index + 1}',
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
                                                      const EdgeInsets.all(3.0),
                                                  child: Text(
                                                    '${df.format(lot.orderedTime!)}',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'เพิ่ม ${NumberFormat("#,###,###.##").format(lot.amount)} ชิ้น',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'ขายแล้ว ${NumberFormat("#,###,###.##").format(lot.amount! - lot.remainAmount)} ชิ้น',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      lot.remainAmount == 0
                                          ? Row(
                                              children: [
                                                Icon(
                                                  Icons.numbers_outlined,
                                                  color: Colors.greenAccent,
                                                ),
                                                Text('ขายสินค้าหมดแล้ว',
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.greenAccent,
                                                    )),
                                              ],
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .background,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Row(
                                                  children: [
                                                    Text('คงเหลือ ',
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white,
                                                        )),
                                                    Text(
                                                        '${NumberFormat("#,###.##").format(lot.remainAmount)}',
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
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
                            ),
                          );
                        }),
                  ),
            const SizedBox(
              height: 10,
            ),

            // ยกเลิก Button
            productLots.isEmpty
                ? Container()
                : Padding(
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
                              onPressed: () {},
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
            // บันทึก Button
          ]),
        ),
      ),
    );
  }
}

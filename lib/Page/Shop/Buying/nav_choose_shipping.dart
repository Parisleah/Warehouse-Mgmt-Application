import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_mnmt/Page/Model/DeliveryCompany.dart';
import 'package:warehouse_mnmt/Page/Model/DeliveryRate.dart';
import 'package:warehouse_mnmt/Page/Model/Shop.dart';
import 'package:warehouse_mnmt/Page/Shop/Buying/nav_create_shipping.dart';
import 'package:warehouse_mnmt/Page/Shop/Buying/nav_edit_deliveryCompany.dart';
import 'package:warehouse_mnmt/db/database.dart';

import '../../Component/TextField/CustomTextField.dart';

class ChooseShippingNav extends StatefulWidget {
  final Shop shop;
  final ValueChanged<DeliveryCompanyModel> update;

  const ChooseShippingNav(
      {super.key, required this.shop, required this.update});
  @override
  State<ChooseShippingNav> createState() => _ChooseShippingNavState();
}

class _ChooseShippingNavState extends State<ChooseShippingNav> {
  List<DeliveryCompanyModel> companys = [
    DeliveryCompanyModel(
      dcName: 'รับสินค้าเอง',
    )
  ];
  @override
  void initState() {
    super.initState();
    refreshPage();
  }

  Future refreshPage() async {
    companys = await DatabaseManager.instance
        .readDeliveryCompanys(widget.shop.shopid!);

    setState(() {});
  }

  TextEditingController controller = TextEditingController();
  bool _validate = false;
  Future<void> dialog(TextEditingController controller) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (dContext, DialogSetState) {
          return AlertDialog(
            backgroundColor: Theme.of(dContext).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            title: Container(
              width: 150,
              child: Row(
                children: [
                  const Text(
                    'ระบุการจัดส่งอื่น ๆ ',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  CustomTextField.textField(
                    dContext,
                    'ระบุการจัดส่ง',
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
                  // widget.update(controller.text);
                  Navigator.of(dContext).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool _validate = false;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        title: Column(
          children: [
            Text(
              "เลือกการจัดส่ง",
              style: TextStyle(fontSize: 25),
            )
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => CreateShippingPage(
                            shop: widget.shop!,
                          )));
              refreshPage();
              setState(() {});
            },
            icon: const Icon(
              Icons.add,
              size: 30,
            ),
          )
        ],
        backgroundColor: Color.fromRGBO(30, 30, 65, 1.0),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: (MediaQuery.of(context).size.height),
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
            const SizedBox(
              height: 80,
            ),
            companys.isEmpty
                ? Expanded(
                    child: Container(
                      child: Center(
                        child: Text(
                          'ไม่มีการจัดส่ง',
                          style: TextStyle(color: Colors.grey, fontSize: 25),
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: 440,
                    height: 510,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: companys.length,
                        itemBuilder: (context, index) {
                          final company = companys[index];
                          List<DeliveryRateModel> rates = [];
                          return // Choose Customer Button
                              Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) async {
                                rates = await DatabaseManager.instance
                                    .readDeliveryRatesWHEREdcId(company.dcId!);
                                for (var rate in rates) {
                                  await DatabaseManager.instance
                                      .deleteDeliveryRate(rate.rId!);
                                }
                                await DatabaseManager.instance
                                    .deleteDeliveryCompany(company.dcId!);

                                refreshPage();
                                setState(() {});
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.redAccent,
                                  content: Text("ลบ ${company.dcName}"),
                                  duration: Duration(seconds: 1),
                                ));
                              },
                              background: Container(
                                margin: EdgeInsets.only(
                                    left: 0, top: 10, right: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(10)),
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
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary:
                                        const Color.fromRGBO(56, 54, 76, 1.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                onPressed: () {
                                  //  if (shipping == 'อื่นๆ') {
                                  //   dialog(controller);
                                  // } else {
                                  //   Navigator.of(context).pop();
                                  //   widget.update(shipping);
                                  // }
                                  Navigator.of(context).pop();
                                  widget.update(company);
                                  refreshPage();
                                },
                                child: Row(children: [
                                  Icon(Icons.local_shipping_rounded),
                                  Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Text(company.dcName,
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white)),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () async {
                                      await Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  EditShippingPage(
                                                    shop: widget.shop!,
                                                    company: company,
                                                  )));
                                      refreshPage();
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  )
                                ]),
                              ),
                            ),
                          );
                          // Choose Customer Button;
                        }),
                  ),
          ]),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:warehouse_mnmt/Page/Component/change_theme_btn.dart';
import 'package:warehouse_mnmt/Page/Model/DeliveryCompany.dart';
import 'package:warehouse_mnmt/Page/Model/DeliveryRate.dart';
import 'package:warehouse_mnmt/Page/Model/Shop.dart';

import 'package:warehouse_mnmt/Page/Provider/theme_provider.dart';
import 'package:warehouse_mnmt/db/database.dart';
import 'package:warehouse_mnmt/main.dart';

class EditShippingPage extends StatefulWidget {
  final Shop shop;
  final DeliveryCompanyModel company;
  const EditShippingPage({required this.company, required this.shop, Key? key})
      : super(key: key);

  @override
  State<EditShippingPage> createState() => _EditShippingPageState();
}

class _EditShippingPageState extends State<EditShippingPage> {
  List<DeliveryRateModel> deliveryRates = [];
  List<TextEditingController> startControllers = [];
  List<TextEditingController> endControllers = [];
  List<TextEditingController> costControllers = [];
  @override
  void initState() {
    super.initState();
    refreshPage();
  }

  Future refreshPage() async {
    deliveryRates = await DatabaseManager.instance
        .readDeliveryRatesWHEREdcId(widget.company.dcId!);
    print(deliveryRates.length);
    for (var i = 0; i < deliveryRates.length; i++) {
      startControllers.add(TextEditingController(
          text: deliveryRates[i].weightRange.split('-')[0]));
      endControllers.add(TextEditingController(
          text: deliveryRates[i].weightRange.split('-')[1]));
      costControllers
          .add(TextEditingController(text: '${deliveryRates[i].cost}'));
    }

    setState(() {});
  }

  final _formDcNameKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  late final nameController =
      TextEditingController(text: widget.company.dcName);
  String? deliveryOptions;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: Color.fromRGBO(30, 30, 65, 1.0),
            automaticallyImplyLeading: true,
            actions: [],
            title: Text(
              "${widget.company.dcName}",
              textAlign: TextAlign.start,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: (MediaQuery.of(context).size.height),
            decoration: BoxDecoration(gradient: scafBG_dark_Color),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Form(
                    key: _formDcNameKey,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15)),
                      width: 400,
                      height: 70,
                      child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'โปรดระบุชื่อ';
                            }
                            return null;
                          },
                          style: const TextStyle(color: Colors.white),
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'ชื่อบริษัท',
                            filled: true,
                            fillColor: Colors.transparent,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide.none),
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                            suffixIcon: nameController.text.isEmpty
                                ? Container(
                                    width: 0,
                                  )
                                : IconButton(
                                    onPressed: () => nameController.clear(),
                                    icon: const Icon(
                                      Icons.close_sharp,
                                      color: Colors.white,
                                    ),
                                  ),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Container(
                  //   padding: const EdgeInsets.all(5),
                  //   decoration: BoxDecoration(
                  //       color: Colors.transparent,
                  //       borderRadius: BorderRadius.circular(15)),
                  //   height: 70,
                  //   child: Row(
                  //     children: [
                  //       SizedBox(
                  //         width: 180,
                  //         child: RadioListTile(
                  //           title: Text(
                  //             "กำหนดราคา",
                  //             style: TextStyle(fontSize: 14),
                  //           ),
                  //           value: "onlyOne",
                  //           groupValue: deliveryOptions,
                  //           onChanged: (value) {
                  //             setState(() {
                  //               deliveryOptions = value.toString();
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: SizedBox(
                  //           child: RadioListTile(
                  //             title: Text("คำนวณตามน้ำหนัก",
                  //                 style: TextStyle(fontSize: 14)),
                  //             value: "range",
                  //             groupValue: deliveryOptions,
                  //             onChanged: (value) {
                  //               setState(() {
                  //                 deliveryOptions = value.toString();
                  //               });
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15)),
                    height: (MediaQuery.of(context).size.height) / 2,
                    child: Expanded(
                        child: Column(
                      children: [
                        Row(
                          children: [
                            Text('ช่วงน้ำหนัก (${deliveryRates.length})'),
                            Text(
                              ' หน่วยเป็นกรัม',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(
                              width: 400 / 9,
                            ),
                            Text('ค่าจัดส่ง'),
                          ],
                        ),
                        Form(
                          key: _formKey,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(15)),
                            padding: EdgeInsets.all(5),
                            height: 250,
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: deliveryRates.length,
                                itemBuilder: (context, index) {
                                  final rate = deliveryRates[index];

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Expanded(
                                        child: Row(children: [
                                          Text('${index + 1}',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white)),
                                          SizedBox(
                                            height: 80,
                                            width: 80,
                                            child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'โปรดระบุช่วง';
                                                  } else if (startControllers[
                                                              index]
                                                          .text
                                                          .isNotEmpty &&
                                                      value.isNotEmpty &&
                                                      value != null) {
                                                    if (double.parse(
                                                                startControllers[
                                                                        index]
                                                                    .text
                                                                    .replaceAll(
                                                                        RegExp(
                                                                            '[^0-9]'),
                                                                        ''))
                                                            .toInt() >
                                                        double.parse(endControllers[
                                                                    index]
                                                                .text
                                                                .replaceAll(
                                                                    RegExp(
                                                                        '[^0-9]'),
                                                                    ''))
                                                            .toInt()) {
                                                      return 'ช่วงน้อยกว่า';
                                                    } else if ((startControllers
                                                                    .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .text ==
                                                                      startControllers[
                                                                              index]
                                                                          .text,
                                                                ) ==
                                                                startControllers[
                                                                    index] &&
                                                            endControllers
                                                                    .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .text ==
                                                                      endControllers[
                                                                              index]
                                                                          .text,
                                                                ) ==
                                                                endControllers[
                                                                    index]) ==
                                                        false) {
                                                      return 'ช่วง ${startControllers[index].text} มีอยู่แล้ว';
                                                    }
                                                  }
                                                  return null;
                                                },
                                                textAlign: TextAlign.start,
                                                keyboardType:
                                                    TextInputType.number,
                                                // maxLength: length,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      10),
                                                ],
                                                controller:
                                                    startControllers[index],
                                                //-----------------------------------------------------

                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                                cursorColor: Theme.of(context)
                                                    .backgroundColor,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  // labelText: title,
                                                  fillColor: Theme.of(context)
                                                      .colorScheme
                                                      .background,

                                                  hoverColor: Theme.of(context)
                                                      .backgroundColor,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10.0),
                                                    ),
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                    ),
                                                  ),

                                                  hintText: 'กรัม',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14),
                                                  // prefixIcon: const Icon(Icons.local_shipping, color: Colors.white),
                                                )),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Text('-'),
                                          ),
                                          SizedBox(
                                            height: 80,
                                            width: 80,
                                            child: TextFormField(
                                                // validator: (value) {
                                                //   if (value == null ||
                                                //       value.isEmpty) {
                                                //     return 'โปรดระบุช่วง';
                                                //   } else if (startController
                                                //           .text
                                                //           .isNotEmpty &&
                                                //       value.isNotEmpty &&
                                                //       value != null) {
                                                //     if (double.parse(
                                                //                 startController[
                                                //                         index]
                                                //                     .text)
                                                //             .toInt() <
                                                //         double.parse(
                                                //                 startController[
                                                //                         index]
                                                //                     .text)
                                                //             .toInt()) {
                                                //       return 'ช่วงน้อยกว่า';
                                                //     }
                                                //   }
                                                //   return null;
                                                // },
                                                textAlign: TextAlign.start,
                                                keyboardType:
                                                    TextInputType.number,
                                                // maxLength: length,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      10),
                                                ],
                                                controller:
                                                    endControllers[index],
                                                //-----------------------------------------------------

                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                                cursorColor: Theme.of(context)
                                                    .backgroundColor,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  // labelText: title,
                                                  fillColor: Theme.of(context)
                                                      .colorScheme
                                                      .background,

                                                  hoverColor: Theme.of(context)
                                                      .backgroundColor,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10.0),
                                                    ),
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                    ),
                                                  ),

                                                  hintText: 'กรัม',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14),
                                                  // prefixIcon: const Icon(Icons.local_shipping, color: Colors.white),
                                                )),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Text('='),
                                          ),
                                          // Cost
                                          Expanded(
                                            child: SizedBox(
                                              height: 80,
                                              child: TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'โปรดระบุค่าจัดส่ง';
                                                    }
                                                    return null;
                                                  },
                                                  textAlign: TextAlign.start,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  // maxLength: length,
                                                  inputFormatters: [
                                                    LengthLimitingTextInputFormatter(
                                                        10),
                                                  ],
                                                  controller:
                                                      costControllers[index],
                                                  //-----------------------------------------------------

                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                  cursorColor: Theme.of(context)
                                                      .backgroundColor,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    // labelText: title,
                                                    fillColor: Theme.of(context)
                                                        .colorScheme
                                                        .background,

                                                    hoverColor:
                                                        Theme.of(context)
                                                            .backgroundColor,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                      borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                      ),
                                                    ),

                                                    hintText: 'ราคา',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14),
                                                    // prefixIcon: const Icon(Icons.local_shipping, color: Colors.white),
                                                    suffixIcon: costControllers[
                                                                index]
                                                            .text
                                                            .isEmpty
                                                        ? Container(
                                                            width: 0,
                                                          )
                                                        : IconButton(
                                                            onPressed: () =>
                                                                costControllers[
                                                                        index]
                                                                    .clear(),
                                                            icon: const Icon(
                                                              Icons.close_sharp,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                  )),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              if (rate.rId == null) {
                                                deliveryRates.remove(rate);
                                                setState(() {});
                                              } else {
                                                await DatabaseManager.instance
                                                    .deleteDeliveryRate(
                                                        rate.rId!);
                                                refreshPage();

                                                setState(() {});
                                              }
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          )
                                        ]),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    var cost = 50;
                                    final rate = DeliveryRateModel(
                                        weightRange: deliveryRates.isEmpty
                                            ? '0.0-500.0'
                                            : '${double.parse(endControllers.last.text)}-${double.parse(endControllers.last.text) * 2}',
                                        cost: costControllers.isEmpty
                                            ? cost
                                            : int.parse(
                                                    costControllers.last.text) +
                                                int.parse(
                                                    costControllers.last.text));
                                    TextEditingController startController =
                                        TextEditingController(
                                            text: (double.parse(rate.weightRange
                                                            .split('-')[0])
                                                        .toInt() +
                                                    (deliveryRates.isEmpty ==
                                                            true
                                                        ? 0
                                                        : 1))
                                                .toString());
                                    TextEditingController endController =
                                        TextEditingController(
                                            text: double.parse(rate.weightRange
                                                    .split('-')[1])
                                                .toInt()
                                                .toString());
                                    TextEditingController costController =
                                        TextEditingController(
                                            text: '${rate.cost}');
                                    // Add DeliveryRates, StartController, EndController, CostController
                                    deliveryRates.add(rate);
                                    startControllers.add(startController);
                                    endControllers.add(endController);
                                    costControllers.add(costController);
                                    ++cost;
                                    print(
                                        'Delivery Rate (${deliveryRates.length}) - ${deliveryRates}');

                                    setState(() {});
                                  },
                                  child: Text('เพิ่มช่วง')),
                            ),
                          ],
                        )
                      ],
                    )),
                  ),

                  deliveryRates.isEmpty
                      ? Container()
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate() &&
                                _formDcNameKey.currentState!.validate()) {
                              final updatedCompany = widget.company
                                  .copy(dcName: nameController.text);

                              await DatabaseManager.instance
                                  .updateDeliveryCompany(updatedCompany);
                              for (var i = 0; i < deliveryRates.length; i++) {
                                if (deliveryRates[i].rId == null) {
                                  final reatedRate = deliveryRates[i].copy(
                                      weightRange:
                                          '${double.parse(startControllers[i].text)}-${double.parse(endControllers[i].text)}',
                                      cost: double.parse(costControllers[i]
                                              .text
                                              .replaceAll(RegExp('[^0-9]'), ''))
                                          .toInt(),
                                      dcId: widget.company.dcId!);
                                  await DatabaseManager.instance
                                      .createDeliveryRate(reatedRate);
                                } else {
                                  final updatedRate = deliveryRates[i].copy(
                                      weightRange:
                                          '${double.parse(startControllers[i].text)}-${double.parse(endControllers[i].text)}',
                                      cost: double.parse(costControllers[i]
                                              .text
                                              .replaceAll(RegExp('[^0-9]'), ''))
                                          .toInt());
                                  await DatabaseManager.instance
                                      .updateDeliveryRate(updatedRate);
                                }
                              }
                              Navigator.pop(context);
                            }
                          },
                          child: Text('บันทึก')),
                  const SizedBox(
                    height: 10,
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

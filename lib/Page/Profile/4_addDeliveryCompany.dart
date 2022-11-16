import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sqflite/sqflite.dart';
import 'package:warehouse_mnmt/Page/Component/Dialog/CustomDialog.dart';
import 'package:warehouse_mnmt/Page/Model/DeliveryCompany.dart';
import 'package:warehouse_mnmt/Page/Model/DeliveryRate.dart';
import 'package:warehouse_mnmt/Page/Model/Profile.dart';
import 'package:warehouse_mnmt/Page/Profile/AllShop.dart';

import '../../../main.dart';

import 'package:warehouse_mnmt/Page/Component/TextField/CustomTextField.dart';

import '../Model/Shop.dart';
import 'package:warehouse_mnmt/db/database.dart';

class AddShopDeliveryCompanyPage extends StatefulWidget {
  final Profile profile;
  final Shop shop;

  const AddShopDeliveryCompanyPage({
    Key? key,
    required this.profile,
    required this.shop,
  }) : super(key: key);

  @override
  State<AddShopDeliveryCompanyPage> createState() =>
      _AddShopDeliveryCompanyPageState();
}

class _AddShopDeliveryCompanyPageState
    extends State<AddShopDeliveryCompanyPage> {
  late File _image = File(widget.shop.image);
  Profile? profile;
  void initState() {
    super.initState();
  }

  bool _isSelected = false;

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);
    print(_image);
    print(_image.runtimeType);

    setState(() {
      _image = imageTemporary;
    });
    return imageTemporary;
  }

  List<TextEditingController> startControllers = [];
  List<TextEditingController> endControllers = [];
  List<TextEditingController> costControllers = [];
  final _formOnlyOneKey = GlobalKey<FormState>();
  final _formDcNameKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final onlyOneController = TextEditingController();
  String? deliveryOptions = 'onlyOne';
  List<DeliveryRateModel> deliveryRates = [
    // DeliveryRateModel(weightRange: '0 - 1 kg', cost: 150)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          '4/4',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: deliveryOptions == 'onlyOne'
              ? (MediaQuery.of(context).size.height)
              : null,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            // ignore: prefer_const_literals_to_create_immutables
            colors: [
              Color.fromRGBO(29, 29, 65, 1.0),
              Color.fromRGBO(31, 31, 31, 1.0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: const Text(
                        "สร้างบริษัทขนส่ง",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Stack(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _image != null
                                  ? Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.file(
                                          _image!,
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Color.fromARGB(
                                                  255, 202, 202, 202),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              fixedSize: const Size(180, 180)),
                                          onPressed: () {
                                            getImage();
                                            setState(() {});
                                          },
                                          child: const Text(
                                            'เลือกรูป',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 94, 94, 94)),
                                          )),
                                    ),
                              Positioned(
                                top: 0.0,
                                right: 0.0,
                                child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.7),
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
                                          size: 15,
                                          color:
                                              Color.fromARGB(255, 94, 94, 94)),
                                      onPressed: () {
                                        getImage();
                                        setState(() {});
                                      },
                                    )),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person_pin,
                                  color: Colors.white,
                                ),
                                Text(widget.shop.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone_in_talk_rounded,
                                  color: Colors.white,
                                ),
                                Text(
                                    widget.shop.phone.replaceAllMapped(
                                        RegExp(r'(\d{3})(\d{3})(\d+)'),
                                        (Match m) => "${m[1]}-${m[2]}-${m[3]}"),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    )),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(spacing: 5, runSpacing: 5, children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              nameController.text = 'Kerry Express';
                            });
                          },
                          child: Text(
                            '+Kerry Express',
                            style: TextStyle(color: Colors.grey),
                          )),
                      InkWell(
                          onTap: () {
                            setState(() {
                              nameController.text = 'DHL';
                            });
                          },
                          child: Text('+DHL',
                              style: TextStyle(color: Colors.grey))),
                      InkWell(
                          onTap: () {
                            setState(() {
                              nameController.text = 'Flash Express';
                            });
                          },
                          child: Text('+Flash Express',
                              style: TextStyle(color: Colors.grey))),
                      InkWell(
                          onTap: () {
                            setState(() {
                              nameController.text = 'ไปรษณีย์ไทย';
                            });
                          },
                          child: Text('+ไปรษณีย์ไทย',
                              style: TextStyle(color: Colors.grey))),
                      InkWell(
                          onTap: () {
                            setState(() {
                              nameController.text = 'SCG Express';
                            });
                          },
                          child: Text('+SCG Express',
                              style: TextStyle(color: Colors.grey))),
                    ]),
                    Form(
                      key: _formDcNameKey,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(15)),
                        width: 400,
                        height: 70,
                        child: Row(
                          children: [
                            Text(
                              "ชื่อ",
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(
                              width: 320,
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
                                    hintText:
                                        'ชื่อบริษัทขนส่ง เช่น Kerry Express, Flash...',
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide.none),
                                    hintStyle: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                    suffixIcon: nameController.text.isEmpty
                                        ? Container(
                                            width: 0,
                                          )
                                        : IconButton(
                                            onPressed: () =>
                                                nameController.clear(),
                                            icon: const Icon(
                                              Icons.close_sharp,
                                              color: Colors.white,
                                            ),
                                          ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15)),
                      height: 70,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 180,
                            child: RadioListTile(
                              title: Text(
                                "กำหนดราคา",
                                style: TextStyle(fontSize: 14),
                              ),
                              value: "onlyOne",
                              groupValue: deliveryOptions,
                              onChanged: (value) {
                                setState(() {
                                  deliveryOptions = value.toString();
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              child: RadioListTile(
                                title: Text("คำนวณตามน้ำหนัก",
                                    style: TextStyle(fontSize: 14)),
                                value: "range",
                                groupValue: deliveryOptions,
                                onChanged: (value) {
                                  setState(() {
                                    deliveryOptions = value.toString();
                                    onlyOneController.clear();
                                  });
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
                    deliveryOptions == 'range'
                        ? Container(
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
                                    Text(
                                        'ช่วงน้ำหนัก (${deliveryRates.length})'),
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
                                  child: Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      padding: EdgeInsets.all(5),
                                      child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: deliveryRates.length,
                                          itemBuilder: (context, index) {
                                            final dr = deliveryRates[index];
                                            print('${dr.weightRange}');

                                            return deliveryRates.isEmpty
                                                ? Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                            onPressed: () {
                                                              // Add StartController, EndController, CostController
                                                              final rate =
                                                                  DeliveryRateModel(
                                                                      weightRange:
                                                                          '0-1',
                                                                      cost: 50);
                                                              TextEditingController
                                                                  startController =
                                                                  TextEditingController(
                                                                      text: rate
                                                                          .weightRange
                                                                          .split(
                                                                              '-')[0]);
                                                              TextEditingController
                                                                  endController =
                                                                  TextEditingController(
                                                                      text: rate
                                                                          .weightRange
                                                                          .split(
                                                                              '-')[1]);
                                                              TextEditingController
                                                                  costController =
                                                                  TextEditingController();
                                                              deliveryRates
                                                                  .add(rate);

                                                              startControllers.add(
                                                                  startController);
                                                              endControllers.add(
                                                                  endController);
                                                              costControllers.add(
                                                                  costController);
                                                            },
                                                            child: Text(
                                                                'เพิ่มช่วง')),
                                                      ),
                                                    ],
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Container(
                                                      height: 80,
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Expanded(
                                                        child: Row(children: [
                                                          Text('${index + 1}',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .white)),
                                                          SizedBox(
                                                            height: 80,
                                                            width: 110,
                                                            child:
                                                                TextFormField(
                                                                    validator:
                                                                        (value) {
                                                                      if (value ==
                                                                              null ||
                                                                          value
                                                                              .isEmpty) {
                                                                        return 'โปรดระบุช่วง';
                                                                      } else if (startControllers[index]
                                                                              .text
                                                                              .isNotEmpty &&
                                                                          value
                                                                              .isNotEmpty &&
                                                                          value !=
                                                                              null) {
                                                                        if (double.parse(startControllers[index].text.replaceAll(RegExp('[^0-9]'), '')).toInt() >
                                                                            double.parse(endControllers[index].text.replaceAll(RegExp('[^0-9]'), '')).toInt()) {
                                                                          return 'ช่วงมากกว่า';
                                                                        } else if ((startControllers.firstWhere(
                                                                                      (element) => element.text == startControllers[index].text,
                                                                                    ) ==
                                                                                    startControllers[index] &&
                                                                                endControllers.firstWhere(
                                                                                      (element) => element.text == endControllers[index].text,
                                                                                    ) ==
                                                                                    endControllers[index]) ==
                                                                            false) {
                                                                          return 'ช่วง ${startControllers[index].text} มีอยู่แล้ว';
                                                                        }
                                                                      }
                                                                      return null;
                                                                    },
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    // maxLength: length,
                                                                    inputFormatters: [
                                                                      LengthLimitingTextInputFormatter(
                                                                          10),
                                                                    ],
                                                                    controller:
                                                                        startControllers[
                                                                            index],
                                                                    //-----------------------------------------------------

                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12),
                                                                    cursorColor:
                                                                        Theme.of(context)
                                                                            .backgroundColor,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      contentPadding:
                                                                          EdgeInsets.all(
                                                                              10),
                                                                      // labelText: title,
                                                                      fillColor: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .background,

                                                                      hoverColor:
                                                                          Theme.of(context)
                                                                              .backgroundColor,
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                          Radius.circular(
                                                                              10.0),
                                                                        ),
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .surface,
                                                                        ),
                                                                      ),

                                                                      hintText:
                                                                          'กรัม',
                                                                      hintStyle: const TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              14),
                                                                      // prefixIcon: const Icon(Icons.local_shipping, color: Colors.white),
                                                                    )),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 5,
                                                                    right: 5),
                                                            child: Text('-'),
                                                          ),
                                                          SizedBox(
                                                            height: 80,
                                                            width: 70,
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
                                                                keyboardType: TextInputType.number,
                                                                // maxLength: length,
                                                                inputFormatters: [
                                                                  LengthLimitingTextInputFormatter(
                                                                      10),
                                                                ],
                                                                controller: endControllers[index],
                                                                //-----------------------------------------------------

                                                                style: const TextStyle(color: Colors.white, fontSize: 12),
                                                                cursorColor: Theme.of(context).backgroundColor,
                                                                decoration: InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  // labelText: title,
                                                                  fillColor: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .background,

                                                                  hoverColor: Theme.of(
                                                                          context)
                                                                      .backgroundColor,
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          10.0),
                                                                    ),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .surface,
                                                                    ),
                                                                  ),

                                                                  hintText:
                                                                      'กรัม',
                                                                  hintStyle: const TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          14),
                                                                  // prefixIcon: const Icon(Icons.local_shipping, color: Colors.white),
                                                                )),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 5,
                                                                    right: 5),
                                                            child: Text('='),
                                                          ),
                                                          // Cost
                                                          Expanded(
                                                            child: SizedBox(
                                                              height: 80,
                                                              width: 120,
                                                              child:
                                                                  TextFormField(
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return 'โปรดระบุค่าจัดส่ง';
                                                                        }
                                                                        return null;
                                                                      },
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      // maxLength: length,
                                                                      inputFormatters: [
                                                                        LengthLimitingTextInputFormatter(
                                                                            10),
                                                                      ],
                                                                      controller:
                                                                          costControllers[
                                                                              index],
                                                                      //-----------------------------------------------------

                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              12),
                                                                      cursorColor:
                                                                          Theme.of(context)
                                                                              .backgroundColor,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        contentPadding:
                                                                            EdgeInsets.all(10),
                                                                        // labelText: title,
                                                                        fillColor: Theme.of(context)
                                                                            .colorScheme
                                                                            .background,

                                                                        hoverColor:
                                                                            Theme.of(context).backgroundColor,
                                                                        focusedBorder:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(10.0),
                                                                          ),
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Theme.of(context).colorScheme.surface,
                                                                          ),
                                                                        ),

                                                                        hintText:
                                                                            'ราคา',
                                                                        hintStyle: const TextStyle(
                                                                            color:
                                                                                Colors.grey,
                                                                            fontSize: 14),
                                                                        // prefixIcon: const Icon(Icons.local_shipping, color: Colors.white),
                                                                        suffixIcon: costControllers[index].text.isEmpty
                                                                            ? Container(
                                                                                width: 0,
                                                                              )
                                                                            : IconButton(
                                                                                onPressed: () => costControllers[index].clear(),
                                                                                icon: const Icon(
                                                                                  Icons.close_sharp,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                      )),
                                                            ),
                                                          ),
                                                          IconButton(
                                                            onPressed: () {
                                                              deliveryRates
                                                                  .remove(dr);
                                                              startControllers
                                                                  .removeAt(
                                                                      index);
                                                              endControllers
                                                                  .removeAt(
                                                                      index);
                                                              costControllers
                                                                  .removeAt(
                                                                      index);
                                                              setState(() {});
                                                            },
                                                            icon: Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.white,
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
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            var cost = 32;
                                            final rate = DeliveryRateModel(
                                                weightRange: deliveryRates
                                                        .isEmpty
                                                    ? '0.0-50.0'
                                                    : '${double.parse(endControllers.last.text)}-${double.parse(endControllers.last.text) * 2}',
                                                cost: costControllers.isEmpty
                                                    ? cost
                                                    : int.parse(costControllers
                                                            .last.text) +
                                                        (int.parse(costControllers
                                                                    .last
                                                                    .text) /
                                                                5)
                                                            .toInt());
                                            TextEditingController
                                                startController =
                                                TextEditingController(
                                                    text: (double.parse(rate
                                                                    .weightRange
                                                                    .split(
                                                                        '-')[0])
                                                                .toInt() +
                                                            (deliveryRates
                                                                        .isEmpty ==
                                                                    true
                                                                ? 0
                                                                : 1))
                                                        .toString());
                                            TextEditingController
                                                endController =
                                                TextEditingController(
                                                    text: double.parse(rate
                                                            .weightRange
                                                            .split('-')[1])
                                                        .toInt()
                                                        .toString());
                                            TextEditingController
                                                costController =
                                                TextEditingController(
                                                    text: '${rate.cost}');
                                            // Add DeliveryRates, StartController, EndController, CostController
                                            deliveryRates.add(rate);
                                            startControllers
                                                .add(startController);
                                            endControllers.add(endController);
                                            costControllers.add(costController);
                                            ++cost;
                                            print(
                                                'Delivery Rate (${deliveryRates.length}) - ${deliveryRates}');

                                            setState(() {});
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.add),
                                              Text('เพิ่มช่วง'),
                                            ],
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            )),
                          )
                        : Form(
                            key: _formOnlyOneKey,
                            child: Container(
                              child: Row(
                                children: [
                                  Text(
                                    "ราคาการจัดส่ง",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(
                                    width: 250,
                                    height: 70,
                                    child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'โปรดระบุราคา';
                                          }
                                          return null;
                                        },
                                        style: const TextStyle(
                                            color: Colors.white),
                                        controller: onlyOneController,
                                        decoration: InputDecoration(
                                          hintText: 'ราคา',
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide.none),
                                          hintStyle: const TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                          suffixIcon: onlyOneController
                                                  .text.isEmpty
                                              ? Container(
                                                  width: 0,
                                                )
                                              : IconButton(
                                                  onPressed: () =>
                                                      onlyOneController.clear(),
                                                  icon: const Icon(
                                                    Icons.close_sharp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    deliveryRates.isEmpty
                        ? Container()
                        : ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  _formDcNameKey.currentState!.validate()) {
                                final createdShop = await DatabaseManager
                                    .instance
                                    .createShop(widget.shop);
                                final company = DeliveryCompanyModel(
                                    dcName: nameController.text,
                                    shopId: createdShop.shopid!);
                                final createdCompany = await DatabaseManager
                                    .instance
                                    .createDeliveryCompany(company);
                                for (var i = 0; i < deliveryRates.length; i++) {
                                  final reatedRate = deliveryRates[i].copy(
                                      weightRange:
                                          '${double.parse(startControllers[i].text)}-${double.parse(endControllers[i].text)}',
                                      cost: double.parse(costControllers[i]
                                              .text
                                              .replaceAll(RegExp('[^0-9]'), ''))
                                          .toInt(),
                                      dcId: createdCompany.dcId!);
                                  await DatabaseManager.instance
                                      .createDeliveryRate(reatedRate);
                                }
                                int count = 0;
                                Navigator.of(
                                  context,
                                ).popUntil((_) => count++ >= 4);
                              }
                            },
                            child: Text('บันทึก')),
                    onlyOneController.text.isEmpty
                        ? Container()
                        : ElevatedButton(
                            onPressed: () async {
                              if (_formDcNameKey.currentState!.validate() &&
                                  _formOnlyOneKey.currentState!.validate()) {
                                final createdShop = await DatabaseManager
                                    .instance
                                    .createShop(widget.shop);
                                final company = DeliveryCompanyModel(
                                    dcName: nameController.text,
                                    shopId: createdShop.shopid!);
                                final createdCompany = await DatabaseManager
                                    .instance
                                    .createDeliveryCompany(company);
                                final reatedRate = DeliveryRateModel(
                                    weightRange: 'only-one',
                                    cost: double.parse(onlyOneController.text
                                            .replaceAll(RegExp('[^0-9]'), ''))
                                        .toInt(),
                                    dcId: createdCompany.dcId!);
                                await DatabaseManager.instance
                                    .createDeliveryRate(reatedRate);

                                int count = 0;
                                Navigator.of(
                                  context,
                                ).popUntil((_) => count++ >= 4);
                              }
                            },
                            child: Text('บันทึก')),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

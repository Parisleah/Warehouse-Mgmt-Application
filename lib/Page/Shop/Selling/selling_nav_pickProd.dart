// Others
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

// Page
import 'package:warehouse_mnmt/Page/Shop/Selling/selling_page.dart';

// Model
import 'package:warehouse_mnmt/Page/Model/Product.dart';

// Component
import 'package:warehouse_mnmt/Page/Component/styleButton.dart';

// Class for TextField Decimal Format (ex. 1,000,200.00 $)
import 'package:warehouse_mnmt/Page/Component/TextField/textField_component.dart';

class sellingNavPickProd extends StatefulWidget {
  final Product product;

  sellingNavPickProd({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<sellingNavPickProd> createState() => _sellingNavPickProdState();
}

class _sellingNavPickProdState extends State<sellingNavPickProd> {
  final prodType = ["type1", "type2", "type3", "type4", "type5"];
  final prodSlot = ["slot1", "slot2", "slot3", "slot4", "slot5"];

  String? value;
  // TextField -------------------------------------------------------------
  // prodAmountController TextField
  final prodAmountController = TextEditingController();
  final prodRequestController = TextEditingController();
  // Text Field
  void initState() {
    super.initState();

    prodAmountController.addListener(() => setState(() {}));
    prodRequestController.addListener(() => setState(() {}));
  }
  // TextField -------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
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
                  height: 90,
                ),
                // Padding(
                //   padding: const EdgeInsets.all(5.0),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(20),
                //     child: Image(
                //       height: 150,
                //       image: AssetImage(widget.product.prodImage),
                //     ),
                //   ),
                // ),
                Column(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      color: Color.fromARGB(255, 33, 36, 34),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'widget.product.prodCategory',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'widget.product.prodDetail',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                  Text(
                    "คงเหลือสินค้าทั้งหมด 1 ZX ชิ้น",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                ]),
                // Drop Down แบบสินค้า
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 350,
                    height: 60,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        hint: Text(
                          "เลือกแบบสินค้า",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        value: value,
                        isExpanded: true,
                        iconSize: 30,
                        buttonPadding:
                            const EdgeInsets.only(left: 14, right: 14),
                        buttonDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                          color: Color.fromRGBO(56, 54, 76, 1.0),
                        ),
                        buttonElevation: 2,
                        itemHeight: 72,
                        itemPadding: const EdgeInsets.only(left: 8, right: 8),
                        dropdownMaxHeight: 350,
                        dropdownWidth: 350,
                        dropdownPadding: null,
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Color.fromRGBO(66, 64, 87, 1.0),
                        ),
                        dropdownElevation: 8,
                        scrollbarRadius: const Radius.circular(40),
                        scrollbarThickness: 6,
                        scrollbarAlwaysShow: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                        items: prodType.map(buildMenuItemType).toList(),
                        onChanged: (value) =>
                            setState(() => this.value = value),
                      ),
                    ),
                  ),
                ),
                // Drop Down ล็อตสินค้า
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 350,
                    height: 60,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        hint: const Text(
                          "เลือกล็อตสินค้า",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        value: value,
                        isExpanded: true,
                        iconSize: 30,
                        buttonPadding:
                            const EdgeInsets.only(left: 14, right: 14),
                        buttonDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                          color: Color.fromRGBO(56, 54, 76, 1.0),
                        ),
                        buttonElevation: 2,
                        itemHeight: 72,
                        itemPadding: const EdgeInsets.only(left: 8, right: 8),
                        dropdownMaxHeight: 350,
                        dropdownWidth: 350,
                        dropdownPadding: null,
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Color.fromRGBO(66, 64, 87, 1.0),
                        ),
                        dropdownElevation: 8,
                        scrollbarRadius: const Radius.circular(40),
                        scrollbarThickness: 6,
                        scrollbarAlwaysShow: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                        items: prodSlot.map(buildMenuItemSlot).toList(),
                        onChanged: (value) =>
                            setState(() => this.value = value),
                      ),
                    ),
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
                          inputFormatters: [DecimalFormatter()],
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: [
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              "ยกเลิก",
                              style: TextStyle(fontSize: 17),
                            ),
                            style: cancelButtonStyle)
                      ]),
                      Column(children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "บันทึก",
                            style: TextStyle(fontSize: 17),
                          ),
                          style: saveButtonStyle,
                        )
                      ]),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  // DropDown Product Types
  DropdownMenuItem<String> buildMenuItemType(String item) => DropdownMenuItem(
        value: item,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 100,
              width: 400,
              color: Color.fromRGBO(56, 54, 76, 1.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    Spacer(),
                    CircleAvatar(
                      backgroundColor: Color.fromRGBO(30, 30, 49, 1.0),
                      radius: 15,
                      child: Text('${NumberFormat("#,###.##").format(1)}',
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  // DropDown Product Slots
  // ???
  DropdownMenuItem<String> buildMenuItemSlot(String item) => DropdownMenuItem(
        value: item,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 100,
              width: 400,
              color: Color.fromRGBO(56, 54, 76, 1.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Spacer(),
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(30, 30, 49, 1.0),
                          radius: 15,
                          child: Text('${NumberFormat("#,###.##").format(1)}',
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Text(
                      "เมื่อวันที่ 14 มิ.ย. 2022",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
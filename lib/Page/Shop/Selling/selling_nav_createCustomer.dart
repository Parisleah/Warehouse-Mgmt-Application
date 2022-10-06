import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

// Components ?
import 'package:warehouse_mnmt/Page/Component/styleButton.dart';

class selling_nav_createCustomer extends StatefulWidget {
  const selling_nav_createCustomer({Key? key}) : super(key: key);

  @override
  State<selling_nav_createCustomer> createState() =>
      _selling_nav_createCustomerState();
}

class _selling_nav_createCustomerState
    extends State<selling_nav_createCustomer> {
  // Text Field
  final cusNameController = TextEditingController();
  final cusAddressController = TextEditingController();
  final cusPhoneController = TextEditingController();

  void initState() {
    super.initState();
    cusNameController.addListener(() => setState(() {}));
    cusAddressController.addListener(() => setState(() {}));
    cusPhoneController.addListener(() => setState(() {}));
  }
  // Text Field

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
                "เพิ่มลูกค้าใหม่",
                style: TextStyle(fontSize: 25),
              )
            ],
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(30, 30, 65, 1.0),
        ),
      ),
      body: Container(
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
          // Text & Container Text Field of ชื่อ - นามสกุล
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "ชื่อ - นามสกุล",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(56, 48, 77, 1.0),
                borderRadius: BorderRadius.circular(15)),
            width: 400,
            height: 70,
            child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: cusNameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromRGBO(56, 48, 77, 1.0),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  suffixIcon: cusNameController.text.isEmpty
                      ? Container(
                          width: 0,
                        )
                      : IconButton(
                          onPressed: () => cusNameController.clear(),
                          icon: const Icon(
                            Icons.close_sharp,
                            color: Colors.white,
                          ),
                        ),
                )),
          ),
          // Text & Container Text Field of ชื่อ - นามสกุล

          // Text & Container Text Field of ที่อยู่
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "สถานที่จัดส่ง",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(56, 48, 77, 1.0),
                borderRadius: BorderRadius.circular(15)),
            width: 400,
            height: 100,
            child: SizedBox(
              height: 120,
              width: 100.0,
              child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  controller: cusAddressController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(8),
                    filled: true,
                    fillColor: const Color.fromRGBO(56, 48, 77, 1.0),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none),
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                    suffixIcon: cusAddressController.text.isEmpty
                        ? Container(
                            width: 0,
                          )
                        : IconButton(
                            onPressed: () => cusAddressController.clear(),
                            icon: const Icon(
                              Icons.close_sharp,
                              color: Colors.white,
                            ),
                          ),
                  )),
            ),
          ),
          // Text & Container Text Field of ที่อยู่

          // Text & Container Text Field of หมายเลขโทรศัพท์
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "หมายเลขเบอร์โทรศัพท์",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(56, 48, 77, 1.0),
                borderRadius: BorderRadius.circular(15)),
            width: 400,
            height: 70,
            child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                controller: cusPhoneController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromRGBO(56, 48, 77, 1.0),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  suffixIcon: cusPhoneController.text.isEmpty
                      ? Container(
                          width: 0,
                        )
                      : IconButton(
                          onPressed: () => cusPhoneController.clear(),
                          icon: const Icon(
                            Icons.close_sharp,
                            color: Colors.white,
                          ),
                        ),
                )),
          ),
          // Text & Container Text Field of หมายเลขโทรศัพท์

          // ยกเลิก Button
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
          // บันทึก Button
        ]),
      ),
    );
  }
}
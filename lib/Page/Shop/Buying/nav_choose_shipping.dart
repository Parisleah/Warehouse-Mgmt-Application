import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import '../../Component/TextField/CustomTextField.dart';

class ChooseShippingNav extends StatefulWidget {
  final ValueChanged<String> update;

  const ChooseShippingNav({super.key, required this.update});
  @override
  State<ChooseShippingNav> createState() => _ChooseShippingNavState();
}

class _ChooseShippingNavState extends State<ChooseShippingNav> {
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
                  widget.update(controller.text);
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

    List<String> shippingList = [
      "Flash Express",
      "Kerry Express",
      "J&T Express",
      "ไปรษณีย์ธรรมดา",
      "ไปรษณีย์ด่วนพิเศษ (EMS)",
      "อื่นๆ",
    ];

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
        actions: [],
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
            Container(
              width: 440,
              height: 510,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: shippingList.length,
                  itemBuilder: (context, index) {
                    final shipping = shippingList[index];
                    return // Choose Customer Button
                        Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color.fromRGBO(56, 54, 76, 1.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        onPressed: () {
                          if (shipping == 'อื่นๆ') {
                            dialog(controller);
                          } else {
                            Navigator.of(context).pop();
                            widget.update(shipping);
                          }
                        },
                        child: Row(children: [
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Text(shipping,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white)),
                          ),
                          const Spacer(),
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: Icon(
                          //     Icons.delete,
                          //     color: Colors.white,
                          //   ),
                          // )
                        ]),
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

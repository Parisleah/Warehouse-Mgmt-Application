import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sqflite/sqflite.dart';
import 'package:warehouse_mnmt/Page/Component/Dialog/CustomDialog.dart';
import 'package:warehouse_mnmt/Page/Model/Profile.dart';
import 'package:warehouse_mnmt/Page/Profile/AllShop.dart';

import '../../../main.dart';

import 'package:warehouse_mnmt/Page/Component/TextField/CustomTextField.dart';

import '../Model/Shop.dart';
import 'package:warehouse_mnmt/db/database.dart';

class AddShopImgPage extends StatefulWidget {
  final Profile profile;
  final String shopName;
  final String shopPhone;

  const AddShopImgPage({
    Key? key,
    required this.profile,
    required this.shopName,
    required this.shopPhone,
  }) : super(key: key);

  @override
  State<AddShopImgPage> createState() => _AddShopImgPageState();
}

class _AddShopImgPageState extends State<AddShopImgPage> {
  final profilePhoneController = TextEditingController();
  File? _image;
  Profile? profile;
  void initState() {
    super.initState();
    // profile = widget.profile;
    profilePhoneController.addListener(() => setState(() {}));
  }

  _addNewShop() {
    print("สร้าง ${widget.shopName} Successfully!!");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("สร้าง ${widget.shopName} เสร็จสิ้น! "),
        duration: Duration(seconds: 1),
      ),
    );

    int count = 0;
    Navigator.of(
      context,
    ).popUntil((_) => count++ >= 4);
  }

  Future addShop(Shop shop) async {
    print(
        "Add New Shop -> ID [${shop.shopid}, ${shop.name}, ${shop.phone}], Where ${shop.profileId} ${widget.profile.name}");
    await DatabaseManager.instance.createShop(shop);
  }

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

  showAlert(Shop shop) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)), //this right here
            child: SizedBox(
              width: 300,
              height: 360,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.done,
                            color: Colors.greenAccent,
                            size: 50,
                          ),
                          Text(
                            'สร้างโปรไฟล์เสร็จแล้ว',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 25,
                              // fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        _image!,
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(shop.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(shop.phone,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                )),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(80, 40)),
                        onPressed: () {
                          addShop(shop);
                          _addNewShop();

                          // addShop();
                        },
                        child: Text('ยืนยัน'))
                  ],
                ),
              ),
            ),
          );
        });
    // Alert(
    //   context: context,
    //   type: AlertType.success,
    //   title:
    //       "สร้างโปรไฟล์เสร็จแล้ว \n ${widget.profileName} ${widget.profilePhone}",
    //   buttons: [
    //     DialogButton(
    //       radius: BorderRadius.circular(18),
    //       gradient: LinearGradient(
    //         colors: [
    //           Color.fromRGBO(29, 29, 65, 1.0),
    //           // Color.fromARGB(255, 90, 70, 136),
    //           Theme.of(context).backgroundColor,
    //         ],
    //         begin: Alignment.bottomLeft,
    //         end: Alignment.topRight,
    //         stops: [0.1, 0.8],
    //         tileMode: TileMode.clamp,
    //       ),
    //       // ignore: sort_child_properties_last
    //       child: Text(
    //         "ตกลง",
    //         style: TextStyle(color: Colors.white, fontSize: 20),
    //       ),
    //       onPressed: () {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(builder: (context) => MyHomePage()),
    //         );
    //       },
    //       color: Color.fromRGBO(50, 224, 119, 1.0),
    //       width: 120,
    //     )
    //   ],
    // ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_pin,
                            color: Colors.white,
                          ),
                          Text(widget.shopName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone_in_talk_rounded,
                            color: Colors.white,
                          ),
                          Text(
                              widget.shopPhone.replaceAllMapped(
                                  RegExp(r'(\d{3})(\d{3})(\d+)'),
                                  (Match m) => "${m[1]}-${m[2]}-${m[3]}"),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                  "รูปโปรไฟล์",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 200,
                width: 200,
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
                                width: 180,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Center(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 202, 202, 202),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    fixedSize: const Size(180, 180)),
                                onPressed: () {
                                  getImage();
                                  setState(() {});
                                },
                                child: const Text(
                                  'เลือกรูป',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 94, 94, 94)),
                                )),
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
                            icon: const Icon(Icons.add_photo_alternate_outlined,
                                size: 25,
                                color: Color.fromARGB(255, 94, 94, 94)),
                            onPressed: () {
                              getImage();
                              setState(() {});
                            },
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(80, 40)),
                  onPressed: () {
                    if (_image != null) {
                      final shop = Shop(
                          name: widget.shopName,
                          phone: widget.shopPhone,
                          image: _image!.path,
                          profileId: widget.profile.id!);
                      showAlert(shop);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text("โปรดเพิ่มรุปภาพ"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  child: Text('ยืนยัน'))
            ]),
          ),
        ),
      ),
    );
  }
}

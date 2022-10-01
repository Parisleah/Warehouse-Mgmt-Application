import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:warehouse_mnmt/Page/Component/change_theme_btn.dart';

import 'package:warehouse_mnmt/Page/Provider/theme_provider.dart';
import 'package:warehouse_mnmt/main.dart';

import '../../db/database.dart';
import '../Component/Dialog/EditShopDialog.dart';
import '../Model/Shop.dart';

class ShopPage extends StatefulWidget {
  final Shop shop;
  const ShopPage({required this.shop, Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  // TextField
  bool _validate = false;
  final shopNameController = TextEditingController();
  final shopPhoneController = TextEditingController();
  // TextField

  File? _image;

  bool isChange = false;
  Shop? shop;
  @override
  void initState() {
    shop = widget.shop;
    super.initState();
    shopNameController.addListener(() => setState(() {}));
    shopPhoneController.addListener(() => setState(() {}));
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

  @override
  Widget build(BuildContext context) {
    Future refreshShop() async {
      shop = await DatabaseManager.instance.readShop(widget.shop.shopid!);
      setState(() {});
    }

    Future updateShop() async {
      final shop = widget.shop.copy(
          name: shopNameController.text.isEmpty
              ? widget.shop.name
              : shopNameController.text,
          phone: shopPhoneController.text.isEmpty
              ? widget.shop.phone
              : shopPhoneController.text,
          image: _image?.path == null ? widget.shop.image : _image!.path);
      await DatabaseManager.instance.updateShop(shop);
    }

    showAlert(shop) async {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, DialogSetState) {
              return Dialog(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30.0)), //this right here
                child: SizedBox(
                  height: 400,
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
                              children: const [
                                Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                Text(
                                  'แก้ไขร้านค้า',
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
                          Container(
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
                                        File(widget.shop.image),
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
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              spreadRadius: 0,
                                              blurRadius: 5,
                                              offset: Offset(0, 4))
                                        ],
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                            Icons.add_photo_alternate_outlined,
                                            size: 25,
                                            color: Color.fromARGB(
                                                255, 94, 94, 94)),
                                        onPressed: () async {
                                          await getImage(isChange);
                                          DialogSetState(() {
                                            isChange = !isChange;
                                          });
                                          if (_image!.path != null) {}
                                        },
                                      )),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
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
                              height: 80,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.text,
                                    // maxLength: length,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(30),
                                    ],
                                    controller: shopNameController,
                                    //-----------------------------------------------------
                                    onFieldSubmitted: (context) {
                                      DialogSetState(() {
                                        isChange = true;
                                        print(isChange);
                                      });
                                    },
                                    style: const TextStyle(color: Colors.white),
                                    cursorColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    decoration: InputDecoration(
                                      errorText:
                                          _validate ? 'โปรดระบุ' : null, //
                                      contentPadding: EdgeInsets.only(
                                          top: 25,
                                          bottom: 10,
                                          left: 10,
                                          right: 10),
                                      // labelText: title,
                                      filled: true,
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      counterStyle:
                                          TextStyle(color: Colors.white),
                                      // fillColor: Theme.of(context).colorScheme.background,
                                      focusColor:
                                          Color.fromARGB(255, 255, 0, 0),
                                      hoverColor: Colors.white,

                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                      ),
                                      hintText: shop.name,
                                      hintStyle: const TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                      prefixIcon: const Icon(Icons.person_pin,
                                          color: Colors.white),
                                      suffixIcon:
                                          shopNameController.text.isEmpty
                                              ? Container(
                                                  width: 0,
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    shopNameController.clear();
                                                    if (shopPhoneController
                                                            .text.isNotEmpty ||
                                                        _image != null) {
                                                      DialogSetState(() {
                                                        isChange = true;
                                                      });
                                                    } else {
                                                      DialogSetState(() {
                                                        isChange = false;
                                                      });
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.close_sharp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                    )),
                              )),
                          const SizedBox(
                            height: 10,
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
                              height: 80,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.number,
                                    // maxLength: 10,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    controller: shopPhoneController,
                                    //-----------------------------------------------------
                                    onFieldSubmitted: (context) {
                                      DialogSetState(() {
                                        isChange = true;
                                      });
                                    },
                                    style: const TextStyle(color: Colors.white),
                                    cursorColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    decoration: InputDecoration(
                                      errorText:
                                          _validate ? 'โปรดระบุ' : null, //
                                      contentPadding: EdgeInsets.only(
                                          top: 25,
                                          bottom: 10,
                                          left: 10,
                                          right: 10),
                                      // labelText: title,
                                      filled: true,
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      counterStyle:
                                          TextStyle(color: Colors.white),
                                      // fillColor: Theme.of(context).colorScheme.background,
                                      focusColor:
                                          Color.fromARGB(255, 255, 0, 0),
                                      hoverColor: Colors.white,

                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                      ),
                                      hintText: shop.phone,
                                      hintStyle: const TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                      prefixIcon: const Icon(
                                          Icons.phone_in_talk,
                                          color: Colors.white),
                                      suffixIcon:
                                          shopPhoneController.text.isEmpty
                                              ? Container(
                                                  width: 0,
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    shopPhoneController.clear();
                                                    if (shopNameController
                                                            .text.isNotEmpty ||
                                                        _image != null) {
                                                      DialogSetState(() {
                                                        isChange = true;
                                                      });
                                                    } else {
                                                      DialogSetState(() {
                                                        isChange = false;
                                                      });
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.close_sharp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                    )),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isChange == true
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          fixedSize: const Size(80, 40)),
                                      onPressed: () {
                                        updateShop();
                                        shopNameController.clear();
                                        shopPhoneController.clear();
                                        Navigator.pop(context);
                                        DialogSetState(() {
                                          refreshShop();
                                          isChange = false;
                                        });
                                      },
                                      child: Text('ยืนยัน'))
                                  : Container(
                                      width: 0,
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.redAccent,
                                      fixedSize: const Size(80, 40)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('ยกเลิก')),
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

    ThemeProvider themeProvider;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ChangeThemeButtonWidget(),
                  Container(
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
                        icon: Icon(Icons.edit,
                            size: 25,
                            color: Theme.of(context).colorScheme.background),
                        onPressed: () => showAlert(shop),
                      )),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            ],
            title: Text(
              "ร้านของฉัน",
              textAlign: TextAlign.start,
              // style: _textTheme.headline4?.copyWith(
              //     color: isDark ? Colors.white : Colors.black,
              //     fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Container(
          // decoration: BoxDecoration(gradient: scafBG_dark_Color),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 90,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0, top: 10, right: 10, bottom: 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          File(shop!.image),
                          width: 170,
                          height: 170,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(1.0),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('ชื่อร้าน',
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(shop!.name,
                                        style: TextStyle(color: Colors.white)),
                                  )
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(1.0),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('เบอร์โทรศัพท์',
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                        shop!.phone.replaceAllMapped(
                                            RegExp(r'(\d{3})(\d{3})(\d+)'),
                                            (Match m) =>
                                                "${m[1]}-${m[2]}-${m[3]}"),
                                        style: TextStyle(color: Colors.white)),
                                  )
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.exit_to_app),
                      Text("ร้านอื่น ๆ"),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

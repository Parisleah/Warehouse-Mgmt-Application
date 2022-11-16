import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Components

// Models
import 'package:warehouse_mnmt/Page/Model/Shop.dart';
import 'package:warehouse_mnmt/Page/Profile/1_addShopName.dart';
import 'package:warehouse_mnmt/Page/Provider/theme_provider.dart';
import 'package:warehouse_mnmt/db/database.dart';
import 'package:warehouse_mnmt/main.dart';

import '../Model/Profile.dart';
import '3_addShopImg.dart';
import 'EditProfile.dart';

class AllShopPage extends StatefulWidget {
  final Profile profile;
  const AllShopPage({
    required this.profile,
    Key? key,
  }) : super(key: key);

  @override
  State<AllShopPage> createState() => _AllShopPageState();
}

class _AllShopPageState extends State<AllShopPage> {
  bool isLoading = false;
  List<Shop> shops = [];
  Profile? profile;

  @override
  void initState() {
    profile = widget.profile;
    super.initState();
    refreshProfile();
    refreshAllShops();
  }

  Future refreshProfile() async {
    profile = await DatabaseManager.instance.readProfile(1);

    setState(() {});
  }

  Future refreshAllShops() async {
    shops = await DatabaseManager.instance.readAllShops();
    setState(() {});
  }

  @override
  void dispose() {
    DatabaseManager.instance.close();
    super.dispose();
  }

  showAlertDeleteShop(Shop shop) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)), //this right here
            child: SizedBox(
              width: 300,
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          // Theme.of(context).colorScheme.background
                          // color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                            size: 50,
                          ),
                          Text(
                            'คุณต้องการลบร้าน?',
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
                        File(shop.image),
                        width: 50,
                        height: 50,
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
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(80, 40)),
                            onPressed: () async {
                              await DatabaseManager.instance
                                  .deleteShop(shop.shopid!);
                              Navigator.pop(context);
                              refreshAllShops();
                            },
                            child: Text('ลบร้าน')),
                        const SizedBox(
                          width: 20,
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
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  // Future<bool> _onWillPop() async {
  //   return (await showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(30.0)),
  //           title: new Text('คุณแน่ใจ ?'),
  //           content: new Text('ต้องการออกจากแอปพลิเคชัน'),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () =>
  //                   Navigator.of(context).pop(false), //<-- SEE HERE
  //               child: Text(
  //                 'ไม่',
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop(true);
  //               }, // <-- SEE HERE
  //               child: Text('ออก', style: TextStyle(color: Colors.white)),
  //             ),
  //           ],
  //         ),
  //       )) ??
  //       false;
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(false);
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: (MediaQuery.of(context).size.height),
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
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              "ร้านของฉัน",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: (() async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfilePage(
                                      profile: profile!,
                                    ),
                                  ));
                              refreshProfile();
                              setState(() {});
                            }),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: profile?.image == null
                                          ? Icon(
                                              Icons.image,
                                              color: Colors.white,
                                            )
                                          : Image.file(
                                              File(profile!.image),
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  )),
                            ),
                          ),
                          Text(
                            profile!.name,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      shops.isEmpty
                          ? Container(
                              width: 0,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(110, 30),
                                    primary: Theme.of(context).backgroundColor,
                                  ),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddShopPage(
                                                profile: profile!,
                                              )),
                                    );
                                    refreshAllShops();
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_business_rounded,
                                            size: 20,
                                          ),
                                          Text(
                                            'เพิ่มร้านค้าใหม่',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 400,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              shops.isEmpty
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(250, 40),
                                        primary:
                                            Theme.of(context).backgroundColor,
                                      ),
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddShopPage(
                                                    profile: widget.profile,
                                                  )),
                                        );
                                        refreshAllShops();
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(
                                                Icons.add_business_rounded,
                                                size: 20,
                                              ),
                                              Text(
                                                'เพิ่มร้านค้าใหม่',
                                                style: TextStyle(fontSize: 13),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(
                                      height: 500.0,
                                      child: RefreshIndicator(
                                        onRefresh: refreshAllShops,
                                        child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: shops.length,
                                            itemBuilder: (context, index) {
                                              final shop = shops[index];
                                              return TextButton(
                                                onPressed: () async {
                                                  await Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyHomePage(
                                                                shop: shop,
                                                              )));
                                                  setState(() {
                                                    refreshAllShops();
                                                  });
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 0.0,
                                                      horizontal: 0.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            color: Colors.black,
                                                            // color: Theme.of(context)
                                                            //     .backgroundColor
                                                            //     .withOpacity(0.5),
                                                            spreadRadius: 2,
                                                            blurRadius: 5,
                                                            offset:
                                                                Offset(0, 4))
                                                      ],
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Container(
                                                            height: 90,
                                                            width: 400,
                                                            // color: Theme.of(context)
                                                            //     .colorScheme
                                                            //     .background,
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: [
                                                                  Color
                                                                      .fromRGBO(
                                                                          29,
                                                                          29,
                                                                          65,
                                                                          1.0),
                                                                  // Color.fromARGB(255, 90, 70, 136),
                                                                  Theme.of(
                                                                          context)
                                                                      .backgroundColor,
                                                                ],
                                                                begin: Alignment
                                                                    .bottomLeft,
                                                                end: Alignment
                                                                    .topRight,
                                                                stops: [
                                                                  0.1,
                                                                  0.8
                                                                ],
                                                                tileMode:
                                                                    TileMode
                                                                        .clamp,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  width: 90,
                                                                  height: 90,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          10,
                                                                          10,
                                                                          10,
                                                                          1.0),

                                                                  child: Image
                                                                      .file(
                                                                    File(shop
                                                                        .image),
                                                                    width: 40,
                                                                    height: 40,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                  // decoration:
                                                                  //     new BoxDecoration(
                                                                  //         image:
                                                                  //             new DecorationImage(
                                                                  //   image: new AssetImage(
                                                                  //       shop.image),
                                                                  //   fit: BoxFit.fill,
                                                                  // ))
                                                                ),
                                                                const SizedBox(
                                                                    width: 10),
                                                                Expanded(
                                                                  child: Row(
                                                                    children: [
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                            'ร้าน ${shop.name}',
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18,
                                                                                color: Colors.white),
                                                                          ),
                                                                          Text(
                                                                            shop.phone,
                                                                            style:
                                                                                const TextStyle(fontSize: 13, color: Colors.white),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const Spacer(),
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            showAlertDeleteShop(shop);
                                                                          },
                                                                          icon:
                                                                              const Icon(
                                                                            Icons.more_vert_outlined,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                25,
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

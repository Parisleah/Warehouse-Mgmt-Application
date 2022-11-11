import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:warehouse_mnmt/Page/Component/change_theme_btn.dart';
import 'package:warehouse_mnmt/Page/Model/Shop.dart';

import 'package:warehouse_mnmt/Page/Provider/theme_provider.dart';
import 'package:warehouse_mnmt/main.dart';

class CreateShippingPage extends StatefulWidget {
  final Shop shop;
  const CreateShippingPage({required this.shop, Key? key}) : super(key: key);

  @override
  State<CreateShippingPage> createState() => _CreateShippingPageState();
}

class _CreateShippingPageState extends State<CreateShippingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            automaticallyImplyLeading: true ,
            actions: [],
            title: const Text(
              "บริษัทขนส่ง",
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
                    height: 90,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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

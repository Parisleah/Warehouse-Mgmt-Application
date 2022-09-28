// Main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Theme
import 'package:warehouse_mnmt/Page/Component/theme/theme.dart';
import 'package:warehouse_mnmt/Page/Model/Shop.dart';
import 'package:warehouse_mnmt/Page/Profile/NewUser/2_addName.dart';
import 'package:warehouse_mnmt/Page/Shop/main_selling.dart';
import 'package:warehouse_mnmt/Page/Shop/main_shop.dart';
import 'package:warehouse_mnmt/Page/Provider/theme_provider.dart';
import 'package:warehouse_mnmt/db/database.dart';

// Import Page
import 'Page/Model/Profile.dart';
import 'Page/Profile/AllShop.dart';
import 'Page/Shop/main_buying.dart';
import 'Page/Shop/main_dashboard.dart';
import 'Page/Shop/main_product.dart';

void main() {
  var app = const MyApp();
  runApp(app);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Profile? profile;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Future getProfile() async {
    profile = await DatabaseManager.instance.readProfile(1);
    setState(() {});
  }

  _decideMainPage(profile) {
    if (profile != null) {
      return AllShopPage(profile: profile);
    } else {
      return const AddNamePage();
    }
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          //    _decideMainPage(profile)
          //    AddNamePage()
          home: _decideMainPage(profile),
        );
      });
}

class MyHomePage extends StatefulWidget {
  final Shop shop;

  const MyHomePage({required this.shop, Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  Widget build(BuildContext context) {
    final screens = [
      DashboardPage(shop: widget.shop),
      const SellingPage(),
      const BuyingPage(),
      ProductPage(shop: widget.shop),
      ShopPage(shop: widget.shop),
    ];

    return Scaffold(
      extendBody: true,
      body: screens[currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.add_chart_rounded),
              label: "ภาพรวม",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.back_hand),
              label: "ขายสินค้า",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.handshake_outlined),
              label: "สั่งซื้อสินค้า",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.warehouse),
              label: "สินค้า",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.store_mall_directory_rounded),
                label: "ร้านของฉัน"),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  bool get isDark => _themeMode == ThemeMode.dark;
}

////////////////////////////////////////////////////////////////////////////////////

const scafBG_light_Color = LinearGradient(
  colors: [
    Color.fromARGB(255, 255, 255, 255),
    Color.fromARGB(255, 255, 255, 255),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const scafBG_dark_Color = LinearGradient(
  colors: [
    Color.fromRGBO(29, 29, 65, 1.0),
    Color.fromRGBO(31, 31, 31, 1.0),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const COLOR_PRIMARY_Light = Colors.white;

const COLOR_ACCENT_Light = Color.fromRGBO(30, 30, 65, 1.0);

ThemeData purple_light_Theme = ThemeData(
    // Colors
    brightness: Brightness.light,
    primaryColor: COLOR_PRIMARY_Light,
    splashColor: Colors.transparent,
    scaffoldBackgroundColor: Colors.red,
    // Tabbar
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.white,
      indicator: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 5,
            offset: Offset(0, 3))
      ], borderRadius: BorderRadius.circular(15), color: Colors.greenAccent),
      indicatorSize: TabBarIndicatorSize.tab,
    ),
    // App Bar
    appBarTheme: const AppBarTheme(
      toolbarHeight: 70,
      titleTextStyle: TextStyle(
        fontSize: 30,
        fontFamily: 'NotoSansThai',
      ),
      elevation: 10.0,
      backgroundColor: COLOR_ACCENT_Light,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
    ),

    // Font
    fontFamily: 'NotoSansThai',
    // ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(COLOR_ACCENT_Light),
      shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0)),
    )));

// Dark Mode
const COLOR_PRIMARY_Dark = Colors.blue;

const COLOR_ACCENT_Dark = Color.fromRGBO(30, 30, 65, 1.0);

ThemeData purple_dark_Theme = ThemeData(

    // Colors
    primaryColor: COLOR_PRIMARY_Dark,
    brightness: Brightness.light,
    splashColor: Colors.transparent,
    scaffoldBackgroundColor: Colors.red,

    // Tabbar
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.white,
      indicator: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 5,
            offset: Offset(0, 3))
      ], borderRadius: BorderRadius.circular(15), color: Colors.greenAccent),
      indicatorSize: TabBarIndicatorSize.tab,
    ),
    // App Bar
    appBarTheme: const AppBarTheme(
      toolbarHeight: 70,
      titleTextStyle: TextStyle(
        fontSize: 30,
        fontFamily: 'NotoSansThai',
      ),
      elevation: 10.0,
      backgroundColor: COLOR_ACCENT_Dark,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
    ),

    // Font
    fontFamily: 'NotoSansThai',
    // ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(COLOR_ACCENT_Dark),
      shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0)),
    )),
    
    );


// Profile Theme


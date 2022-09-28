import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  bool get isDark => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

const scafBG_light_Color = LinearGradient(
  stops: [
    0.1,
    0.4,
    0.6,
    0.9,
  ],
  colors: [
    Color.fromARGB(255, 255, 255, 255),
    Color.fromARGB(255, 255, 255, 255),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const scafBG_dark_Color = LinearGradient(
  stops: [
    0.1,
    0.4,
    0.6,
    0.9,
  ],
  colors: [
    Color.fromRGBO(29, 29, 65, 1.0),
    Color.fromRGBO(31, 31, 31, 1.0),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);
const dark_primary_accent_color = Color.fromARGB(255, 141, 106, 225);

const light_primary_accent_color = Color.fromARGB(255, 72, 179, 127);

class MyThemes {
  static final darkTheme = ThemeData(
    // Font
    fontFamily: 'NotoSansThai',

    // Main Colors
    backgroundColor: dark_primary_accent_color,
    scaffoldBackgroundColor: Color.fromRGBO(10, 10, 10, 1.0),

    colorScheme: const ColorScheme.dark(
      secondary: const Color.fromRGBO(56, 48, 77, 1.0),
      surface: dark_primary_accent_color,
      // Search TextField
      background: Color.fromRGBO(20, 20, 20, 1.0),
      error: Colors.green,
      onPrimary: Colors.white,
      onSecondary: Color.fromRGBO(29, 29, 65, 1.0),
      // Icon Color
      onSurface: Colors.white,
      onBackground: Colors.brown,
      onError: dark_primary_accent_color,
      brightness: Brightness.dark,
      primary: Color.fromRGBO(17, 17, 17, 1.0),
    ),

    textTheme: const TextTheme(
      headline2: TextStyle(color: dark_primary_accent_color, fontSize: 20),
    ),

    // App bar
    appBarTheme: const AppBarTheme(
      toolbarHeight: 70,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontFamily: 'NotoSansThai',
      ),
      elevation: 10.0,
      backgroundColor: Color.fromARGB(255, 16, 16, 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
    ),

    // Tabbar
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.white,
      indicator: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 5,
                offset: Offset(0, 3))
          ],
          borderRadius: BorderRadius.circular(15),
          color: dark_primary_accent_color),
      indicatorSize: TabBarIndicatorSize.tab,
    ),

    // BottomAppBar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      unselectedItemColor: Colors.white,
      selectedItemColor: dark_primary_accent_color,
      backgroundColor: Color.fromARGB(255, 16, 16, 16),
      type: BottomNavigationBarType.fixed,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(dark_primary_accent_color),
      trackColor: MaterialStateProperty.all(Color.fromARGB(255, 104, 76, 171)),
    ),
    // ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(dark_primary_accent_color),
      shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
      // padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
      //     const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0)),
    )),
  );

  static final lightTheme = ThemeData(
    // Main Colors
    scaffoldBackgroundColor: Color.fromARGB(255, 19, 19, 44),
    colorScheme: const ColorScheme.dark(
        secondary: const Color.fromRGBO(56, 48, 77, 1.0),
        surface: light_primary_accent_color,
        // Search TextField
        background: Color.fromARGB(255, 22, 22, 50),
        error: light_primary_accent_color,
        // Elevated Button Theme Text Color
        onPrimary: Colors.white,
        onSecondary: Color.fromRGBO(29, 29, 65, 1.0),
        onSurface: light_primary_accent_color,
        onBackground: light_primary_accent_color,
        onError: light_primary_accent_color,
        brightness: Brightness.light,
        primary: Color.fromARGB(255, 16, 16, 41)),

    backgroundColor: light_primary_accent_color,

    // Text Theme
    textTheme: const TextTheme(
      headline2: TextStyle(color: light_primary_accent_color, fontSize: 20),
    ),

    // Font
    fontFamily: 'NotoSansThai',

    // App bar
    appBarTheme: const AppBarTheme(
      toolbarHeight: 70,
      titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontFamily: 'NotoSansThai',
          textBaseline: TextBaseline.alphabetic),
      elevation: 10.0,
      backgroundColor: Color.fromRGBO(30, 30, 65, 1.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
    ),

    // Tabbar
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.white,
      indicator: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 5,
                offset: Offset(0, 3))
          ],
          borderRadius: BorderRadius.circular(15),
          color: light_primary_accent_color),
      indicatorSize: TabBarIndicatorSize.tab,
    ),
    // BottomAppBar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: Colors.white,
      selectedItemColor: light_primary_accent_color,
      backgroundColor: const Color.fromRGBO(30, 30, 65, 1.0),
      type: BottomNavigationBarType.fixed,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(light_primary_accent_color),
      trackColor: MaterialStateProperty.all(Color.fromARGB(255, 255, 255, 255)),
    ),
    // ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(light_primary_accent_color),
      shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
      // padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
      //     const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0)),
    )),
  );
}

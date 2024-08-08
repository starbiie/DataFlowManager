import 'package:data_flow_manager/provider/theme_Provider.dart';
import 'package:data_flow_manager/utilis/themedata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'screens/continueAs.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider()..loadThemePreference(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:realestateapp/mainscreen.dart';
import 'package:realestateapp/mapscreen.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // This line sets the app to full-screen mode.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Real Estate App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
        useMaterial3: true,
      ),
      home: MainScreen(),
    );
  }
}

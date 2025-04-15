import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motiwalajewels/Colors/appcolor.dart';
import 'package:motiwalajewels/provider.dart';

import 'package:motiwalajewels/test.dart';
import 'package:motiwalajewels/web_view.dart';

import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("Starting app...");
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.theme, // ✅ Green status bar
      // ✅ Green status bar
      statusBarIconBrightness: Brightness.light, // Keep icons light
      systemNavigationBarColor: Colors.transparent,
      // ✅ Green bottom bar
      systemNavigationBarDividerColor: Colors.transparent, // ✅ Green divider
      systemNavigationBarIconBrightness: Brightness.light, // Keep icons light
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Future<Position> getUserCurrentLocation() async {
  //   await Geolocator.requestPermission()
  //       .then((value) {})
  //       .onError((error, stackTrace) {
  //     print("error" + error.toString());
  //   });
  //   return await Geolocator.getCurrentPosition();
  // }

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff9F0055)),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xfff1f5f9),
        ),
        home: WebViewStack(), // Replace with your actual home widg
      ),
    );
  }
}

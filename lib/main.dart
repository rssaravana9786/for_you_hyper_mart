import 'dart:async';
import 'package:flutter/material.dart';
import 'package:for_you_hyper_mart/app/modules/cart/cart_view.dart';
import 'package:for_you_hyper_mart/app/modules/home/home_view.dart';
import 'package:for_you_hyper_mart/app/modules/home/product_details_view.dart';
import 'package:for_you_hyper_mart/app/modules/user/user.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: Get.key,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/home', page: () => HomeView()),
        GetPage(name: '/cart', page: () => CartPage()),
        GetPage(
          name: '/product_details',
          page: () => ProductDetailsView(product: Get.arguments),
        ),
        GetPage(name: '/user', page: () => UserManagementPage()),
      ],
    );
  }
}

/// ✅ Fix: `Get.offNamed()` Replaces Splash Screen (Prevents Back Navigation)
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), () {
      Get.offAllNamed("/home"); // ✅ Fix: Replaces Splash, no back button issue
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/logo.jpeg",
            width: 150, height: 150), // Your splash logo
      ),
    );
  }
}

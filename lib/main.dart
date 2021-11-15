import 'package:App/screens/HomeScreen/HomeScreen.dart';
import 'package:App/screens/LoginScreen/LoginScreen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'constants/firebase.dart';
import 'controllers/appController.dart';
import 'controllers/authController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialization.then((value){
    Get.put(AppController());
    Get.put(UserController());
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Order System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

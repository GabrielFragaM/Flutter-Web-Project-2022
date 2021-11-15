import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:App/screens/LoginScreen/widgets/bottom_text.dart';
import 'package:App/screens/LoginScreen/widgets/create_account.dart';
import 'package:App/screens/LoginScreen/widgets/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:App/controllers/appController.dart';


class LoginScreen extends StatelessWidget {

  final AppController _appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Visibility(
                visible: _appController.isLoginWidgetDisplayed.value,
                child: LoginWidget()),
            Visibility(
                visible: !_appController.isLoginWidgetDisplayed.value,
                child: CreateAccountWidget()),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: _appController.isLoginWidgetDisplayed.value,
              child: BottomTextWidget(
                onTap: () async {
                  _appController.changeDIsplayedAuthWidget();
                },
                text1: "Ainda não tem uma conta ?",
                text2: "Crie sua conta",
              ),
            ),
            Visibility(
              visible: !_appController.isLoginWidgetDisplayed.value,
              child: BottomTextWidget(
                onTap: () async {
                  _appController.changeDIsplayedAuthWidget();
                },
                text1: "Já tem uma conta ?",
                text2: "Entrar",
              ),
            ),
          ],
        ),
      ),)
    );
  }
}

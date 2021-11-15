import 'package:App/constants/json_language.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showLoading(){
  Get.defaultDialog(
    title: "${json_language['Loading...']}",
    content: CircularProgressIndicator(),
    barrierDismissible: false
  );
}

dismissLoadingWidget(){
  Get.back();
}
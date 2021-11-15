import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:App/screens/HomeScreen/HomeScreen.dart';
import 'package:App/screens/LoginScreen/widgets/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:App/constants/app_constants.dart';
import 'package:App/constants/firebase.dart';
import 'package:App/models/user.dart';
import 'package:App/utils/helpers/showLoading.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();
  Rx<User> firebaseUser;
  RxBool isLoggedIn = false.obs;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String usersCollection = "users";
  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User user) {
    if (user == null) {
      Get.offAll(() => LoginWidget());
    } else {
      userModel.bindStream(listenToUser());
      Get.offAll(() => HomeScreen());
    }
  }

  void signIn() async {
    try {
      showLoading();
      await auth
          .signInWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) async {
        _clearControllers();

      });
      var body = jsonEncode({
        "email": "${email.text}",
        "password": "${password.text}"
      });

      var url = 'https://ygyoza-api.herokuapp.com/pawaresoftwares/api/ygyoza/auth/login/';

      var response = await http.post(Uri.parse(url),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Access-Control_Allow_Origin": "*"
          },
          body: body,
          encoding: Encoding.getByName("utf-8"));

      final Storage _localStorage = window.localStorage;

      Future save(String token) async {
        _localStorage['token'] = token;
      }
      save(response.body);

    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar("Não foi possível entrar", "Tente novamente");
    }
  }

  void signUp() async {
    showLoading();
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) {
        String _userId = result.user.uid;
        _addUserToFirestore(_userId);
        _clearControllers();
      });
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar("Não foi possível cadastrar", "Tente novamente");
    }
  }

  void signOut() async {
    auth.signOut();
  }

  _addUserToFirestore(String userId) {
    firebaseFirestore.collection(usersCollection).doc(userId).set({
      "name": name.text.trim(),
      "email": email.text.trim(),
      "isAdmin": false,
    });
  }

  _clearControllers() {
    name.clear();
    email.clear();
    password.clear();
  }

  updateUserData(Map<String, dynamic> data) {
    logger.i("UPDATED");
    firebaseFirestore
        .collection(usersCollection)
        .doc(firebaseUser.value.uid)
        .update(data);
  }

  Stream<UserModel> listenToUser() => firebaseFirestore
      .collection(usersCollection)
      .doc(firebaseUser.value.uid)
      .snapshots()
      .map((snapshot) => UserModel.fromSnapshot(snapshot));
}

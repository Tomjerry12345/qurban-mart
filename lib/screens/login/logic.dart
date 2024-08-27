import 'package:admin_qurban_mart/services/firebase_services.dart';
import 'package:admin_qurban_mart/values/output_utils.dart';
import 'package:flutter/material.dart';

class Logic {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  final fs = FirebaseServices();

  Future<void> onLogin() async {
    final username = this.username.text;
    final password = this.password.text;

    final data = await fs.getDataCollection("admin");

    final admin = data[0].data();

    logO("admin", m: admin);

    final fsUsername = admin["username"];
    final fsPassword = admin["password"];

    if (fsUsername == username && fsPassword == password) {
      await fs.updateIsLoggin(true);
    } else {
      showToast("Username atau kata sandi salah");
    }

    // if (username == "admin" && password == "55555") {
    //   // navigatePush(context, MainScreen(), isRemove: true);
    // } else {
    //   showToast("Username atau kata sandi salah");
    // }
  }
}

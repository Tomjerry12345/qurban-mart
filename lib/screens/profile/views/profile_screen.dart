import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:qurban_mart/constants.dart';
import 'package:flutter/material.dart';
import 'package:qurban_mart/components/network_image_with_loader.dart';
import 'package:qurban_mart/controller/auth_controller.dart';
import 'package:qurban_mart/models/user_model.dart';
import 'package:qurban_mart/route/route_constants.dart';
import 'package:qurban_mart/services/firebase_services.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    final fs = FirebaseServices();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: fs.getDataQueryStream(
            "user", "username", authController.currentUser.value),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final user = UserModel.fromMap(snapshot.data!.docs[0].data());

            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      child: NetworkImageWithLoader(
                        user.image.toString(),
                        radius: 100,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Edit foto",
                      style: TextStyle(
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(
                        height: 32), // Space between the photo and the text
                    Text(
                      user.namaLengkap.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                        height:
                            4), // Space between the full name and the username
                    Text(
                      user.username.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      width: 180,
                      child: ElevatedButton(
                          onPressed: () {
                            authController.onLogout();
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                logInScreenRoute,
                                ModalRoute.withName(entryPointScreenRoute));
                          },
                          child: Text("Logout")),
                    )
                  ],
                ),
              ),
            );
          }

          return Container();
        });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qurban_mart/constants.dart';
import 'package:flutter/material.dart';
import 'package:qurban_mart/components/network_image_with_loader.dart';
import 'package:qurban_mart/controller/auth_controller.dart';
import 'package:qurban_mart/models/user_model.dart';
import 'package:qurban_mart/route/route_constants.dart';
import 'package:qurban_mart/services/firebase_services.dart';
import 'package:qurban_mart/values/output_utils.dart';
import 'package:qurban_mart/values/position_utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    final fs = FirebaseServices();

    final nameController = TextEditingController();

    void showImageSourceActionSheet(
        BuildContext context, AuthController controller, UserModel user) {
      showModalBottomSheet(
        context: context,
        builder: (context) => SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  controller.pickImage(source: ImageSource.gallery);
                  controller.editImage(user.id.toString());
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  controller.pickImage(source: ImageSource.camera);
                  controller.editImage(user.id.toString());
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    }

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
                    GestureDetector(
                      onTap: () => showImageSourceActionSheet(
                          context, authController, user),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            child: NetworkImageWithLoader(
                              user.image.toString(),
                              radius: 100,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                // Tambahkan aksi ketika ikon edit diklik
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 20,
                                child: Icon(
                                  Icons.edit,
                                  color: primaryColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    V(32),
                    ObxValue((isEditing) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isEditing.value)
                            SizedBox(
                              width: 230,
                              child: TextField(
                                autofocus: true,
                                onEditingComplete: () {
                                  authController.updateNamaLengkap(
                                      user.id.toString(), nameController.text);
                                  isEditing.value = false;
                                },
                                controller:
                                    nameController, // Menggunakan controller untuk mengatur teks
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  // Menambahkan underline di bawah TextField
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            primaryColor), // Warna garis bawah saat tidak fokus
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: primaryColor,
                                        width:
                                            2), // Warna garis bawah saat fokus
                                  ),
                                  // hintText: 'Enter your name',
                                ),
                              ),
                            )
                          else
                            Text(
                              user.namaLengkap.toString(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          SizedBox(
                              width: 8), // Space between name and edit icon
                          InkWell(
                            onTap: () {
                              nameController.text = user.namaLengkap.toString();
                              isEditing.value = true;
                            },
                            child: Icon(
                              isEditing.value ? null : Icons.edit,
                              color: primaryColor,
                              size: 20,
                            ),
                          ),
                        ],
                      );
                    }, false.obs),

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

import 'package:admin_qurban_mart/constants.dart';
import 'package:admin_qurban_mart/controllers/MenuAppController.dart';
import 'package:admin_qurban_mart/screens/login/login_page.dart';
import 'package:admin_qurban_mart/screens/main/main_screen.dart';
import 'package:admin_qurban_mart/services/firebase_services.dart';
import 'package:admin_qurban_mart/values/output_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;
  final fs = FirebaseServices();

  @override
  initState() {
    super.initState();
  }

  void onClickLogin(isLogin) {
    setState(() {
      this.isLogin = isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
        listTileTheme: ListTileThemeData(
          selectedColor: Colors.white,
          selectedTileColor:
              Colors.white.withOpacity(0.2), // Background color when selected
        ),
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuAppController(),
          ),
        ],
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: fs.getDataStreamCollection("isLoggin"),
            builder: (context, snapshot) {
              logO("snapshot", m: snapshot.data);
              if (snapshot.data != null) {
                final data = snapshot.data?.docs;
                if (data!.isNotEmpty) {
                  final status = snapshot.data?.docs[0].data()["status"];
                  return status ? MainScreen() : const LoginPage();
                }
              }
              return Container();
            }),
      ),
    );
  }
}

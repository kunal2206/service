import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/core/constants/controllers.dart';
import 'app/core/constants/palette.dart';
import 'app/data/background_service/gps_isolate.dart';
import 'app/data/controllers/auth_controller.dart';
import 'app/data/controllers/bottom_navigation_controller.dart';
import 'app/data/controllers/gps_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  Get.put(AuthController());
  Get.put(GpsController());
  Get.put(BottomNavigationController());

  await initializeService();

  ///prevent device orientation
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Fixpals",
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      getPages: AppPages.routes,
      theme: ThemeData(
        scaffoldBackgroundColor: white,
        primaryColor: ultramarineBlue,
        backgroundColor: white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: dark),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        Future.delayed(const Duration(seconds: 1)).then((value) {
          authController.tryAutoLogging().then((value) async {
            if (value) {
              
              Get.toNamed(Routes.HOME);
            } else {
              Get.toNamed(Routes.AUTHENTICATION);
            }
          });
        });
        return const Center(
          child: Text("Splash Screen"),
        );
      }),
    );
  }
}

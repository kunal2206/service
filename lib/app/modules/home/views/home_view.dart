import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:get/get.dart';

import '../../../core/constants/controllers.dart';
import '../../../core/constants/palette.dart';
import '../../../global_widgets/bottom_navigation_bar.dart';
import '../../../global_widgets/custom_carousel.dart';
import '../../../global_widgets/drawer_widgets/side_nav.dart';
import '../../../global_widgets/home_grid/category_grid.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_app_bar.dart';

class IconNavigate {
  final IconData? icon;
  final void Function()? onPressed;
  final Color color;

  IconNavigate(this.icon, this.color, this.onPressed);
}

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: SideNav(
          scaffoldKey: _scaffoldKey,
        ),
      ),
      body: Stack(
        children: [
          _scrollableHomepageContent(context),
          HomePageAppBar(
            openDrawer: _openDrawer,
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _scrollableHomepageContent(BuildContext context) {
    controller.getAllCategoriesBySection();
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.23,
          ),
          Obx(() {
            return CustomCarousel(carouselUrl: controller.carouselUrl.value);
          }),
          Obx(() {
            return controller.categoriesBySection.value.keys.isEmpty
                ? const CircularProgressIndicator(
                    color: cafeAuLait,
                  )
                : Column(
                    children: controller.categoriesBySection.value.keys
                        .map((e) => CategoryGrid(
                              sectionName: e,
                              categories:
                                  controller.categoriesBySection.value[e]!,
                            ))
                        .toList(),
                  );
          }),
          const SizedBox(
            height: 10,
          ),
          //TODO: rectify the set state issue
          //const PopularSearches()
        ],
      ),
    );
  }
}

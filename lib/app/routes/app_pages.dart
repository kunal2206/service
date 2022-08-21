import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../core/constants/controllers.dart';
import '../modules/about/bindings/about_binding.dart';
import '../modules/about/views/about_view.dart';
import '../modules/address/bindings/address_binding.dart';
import '../modules/address/views/address_view.dart';
import '../modules/authentication/bindings/authentication_binding.dart';
import '../modules/authentication/views/authentication_view.dart';
import '../modules/bookings/bindings/bookings_binding.dart';
import '../modules/bookings/views/bookings_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/category/bindings/category_binding.dart';
import '../modules/category/views/category_view.dart';
import '../modules/contact_us/bindings/contact_us_binding.dart';
import '../modules/contact_us/views/contact_us_view.dart';
import '../modules/faq/bindings/faq_binding.dart';
import '../modules/faq/views/faq_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/ongoing_order_details/bindings/ongoing_order_details_binding.dart';
import '../modules/ongoing_order_details/views/ongoing_order_details_view.dart';
import '../modules/order_details/bindings/order_details_binding.dart';
import '../modules/order_details/views/order_details_view.dart';
import '../modules/order_summary/bindings/order_summary_binding.dart';
import '../modules/order_summary/views/order_summary_view.dart';
import '../modules/privacy_policy/bindings/privacy_policy_binding.dart';
import '../modules/privacy_policy/views/privacy_policy_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/middlewares/auth_middleware.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/terms_and_conditions/bindings/terms_and_conditions_binding.dart';
import '../modules/terms_and_conditions/views/terms_and_conditions_view.dart';

// ignore_for_file: non_constant_identifier_names

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.AUTHENTICATION;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
        name: _Paths.BOOKINGS,
        page: () => BookingsView(),
        binding: BookingsBinding(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: _Paths.PROFILE,
        page: () => const ProfileView(),
        binding: ProfileBinding(),
        middlewares: [AuthMiddleware()]),
    GetPage(
      name: _Paths.CATEGORY,
      page: () => CategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: _Paths.AUTHENTICATION,
      page: () => AuthenticationView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => const AboutView(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: _Paths.CONTACT_US,
      page: () => ContactUsView(),
      binding: ContactUsBinding(),
    ),
    GetPage(
      name: _Paths.TERMS_AND_CONDITIONS,
      page: () => const TermsAndConditionsView(),
      binding: TermsAndConditionsBinding(),
    ),
    GetPage(
      name: _Paths.FAQ,
      page: () => const FaqView(),
      binding: FaqBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACY_POLICY,
      page: () => const PrivacyPolicyView(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DETAILS,
      page: () => OrderDetailsView(),
      binding: OrderDetailsBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_SUMMARY,
      page: () => OrderSummaryView(),
      binding: OrderSummaryBinding(),
    ),
    GetPage(
      name: _Paths.ADDRESS,
      page: () => AddressView(),
      binding: AddressBinding(),
    ),
    GetPage(
      name: _Paths.ONGOING_ORDER_DETAILS,
      page: () => OngoingOrderDetailsView(),
      binding: OngoingOrderDetailsBinding(),
    ),
  ];
}

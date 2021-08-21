// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';

import 'package:lottery_flutter/app/modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
    ),
  ];
}

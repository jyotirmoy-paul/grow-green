import 'dart:ui';

import '../enum/farm_menu_option.dart';

class FarmMenuModel {
  final FarmMenuOption option;
  final Color bgColor;
  final String image;
  final FarmMenuData? data;

  const FarmMenuModel({
    required this.option,
    required this.bgColor,
    required this.image,
    this.data,
  });
}

class FarmMenuData {
  final String data;
  final String? image;

  const FarmMenuData({
    required this.data,
    required this.image,
  });
}

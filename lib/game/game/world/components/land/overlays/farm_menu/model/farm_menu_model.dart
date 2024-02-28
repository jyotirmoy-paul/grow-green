import 'dart:ui';

import '../enum/farm_menu_option.dart';

class FarmMenuModel {
  final List<FarmMenuItemModel> models;
  final String title;

  FarmMenuModel({
    required this.title,
    required this.models,
  });
}

class FarmMenuItemModel {
  final String text;
  final FarmMenuOption option;
  final Color bgColor;
  final String image;
  final FarmMenuItemData? data;

  const FarmMenuItemModel({
    required this.text,
    required this.option,
    required this.bgColor,
    required this.image,
    this.data,
  });
}

class FarmMenuItemData {
  final String data;
  final String? image;

  const FarmMenuItemData({
    required this.data,
    required this.image,
  });
}

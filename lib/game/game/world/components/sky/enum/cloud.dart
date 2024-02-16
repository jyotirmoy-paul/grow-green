abstract class Cloud {
  String get asset;
}

enum NormalCloud implements Cloud {
  type_1(asset: 'clouds/cloud_normal_1.png'),
  type_2(asset: 'clouds/cloud_normal_2.png'),
  type_3(asset: 'clouds/cloud_normal_3.png'),
  type_4(asset: 'clouds/cloud_normal_4.png'),
  type_5(asset: 'clouds/cloud_normal_5.png'),
  type_6(asset: 'clouds/cloud_normal_6.png');

  @override
  final String asset;

  const NormalCloud({
    required this.asset,
  });
}

enum RainCloud implements Cloud {
  type_1(asset: 'clouds/cloud_rain_1.png'),
  type_2(asset: 'clouds/cloud_rain_2.png');

  @override
  final String asset;

  const RainCloud({
    required this.asset,
  });
}

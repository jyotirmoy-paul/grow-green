// this is store per hacter

class Qty {
  final int value;
  final Scale scale;

  const Qty({required this.value, required this.scale});
}

enum Scale { kg, units }

class AgePriceLinearData {
  final AgePrice p1;
  final AgePrice p2;

  const AgePriceLinearData({required this.p1, required this.p2});

  static const zero = AgePriceLinearData(
    p1: AgePrice(age: 0, potentialPrice: 0),
    p2: AgePrice(age: 0, potentialPrice: 0),
  );
}

class AgePrice {
  final int age;
  final int potentialPrice;

  const AgePrice({required this.age, required this.potentialPrice});

  @override
  String toString() {
    return "AgePrice(age : $age , potentialPrice : $potentialPrice)";
  }
}

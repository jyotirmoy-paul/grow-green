abstract interface class HoverBoardModel {
  /// basic hover board factory
  factory HoverBoardModel.basic({
    required String text,
    required String image,
  }) {
    return BasicHoverBoardModel(
      text: text,
      image: image,
    );
  }

  /// timer hover board factory
  factory HoverBoardModel.timer({
    required String text,
    required String image,
    required DateTime futureDateTime,
  }) {
    return TimerHoverBoardModel(
      text: text,
      image: image,
      futureDateTime: futureDateTime,
    );
  }
}

class BasicHoverBoardModel implements HoverBoardModel {
  final String text;
  final String image;

  BasicHoverBoardModel({
    required this.text,
    required this.image,
  });

  @override
  String toString() {
    return 'BasicHoverBoardModel(text: $text, image: $image)';
  }
}

class TimerHoverBoardModel implements HoverBoardModel {
  final String text;
  final String image;
  final DateTime futureDateTime;

  TimerHoverBoardModel({
    required this.text,
    required this.image,
    required this.futureDateTime,
  });

  @override
  String toString() {
    return 'TimerHoverBoardModel(text:$text, image: $image, futureDateTime: $futureDateTime)';
  }
}

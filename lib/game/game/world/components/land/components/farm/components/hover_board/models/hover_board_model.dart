abstract interface class HoverBoardModel {
  /// basic hover board factory
  factory HoverBoardModel.basic({
    required String text,
    required String image,
    required String animationPrefix,
  }) {
    return BasicHoverBoardModel(
      text: text,
      image: image,
      animationPrefix: animationPrefix,
    );
  }

  /// timer hover board factory
  factory HoverBoardModel.timer({
    required String image,
    required DateTime futureDateTime,
    required DateTime startDateTime,
  }) {
    return TimerHoverBoardModel(
      image: image,
      startDateTime: startDateTime,
      futureDateTime: futureDateTime,
    );
  }
}

class BasicHoverBoardModel implements HoverBoardModel {
  final String text;
  final String image;
  final String animationPrefix;

  BasicHoverBoardModel({
    required this.text,
    required this.image,
    required this.animationPrefix,
  });

  @override
  String toString() {
    return 'BasicHoverBoardModel(text: $text, image: $image)';
  }
}

class TimerHoverBoardModel implements HoverBoardModel {
  final String image;
  final DateTime startDateTime;
  final DateTime futureDateTime;
  final int totalWaitDays;

  TimerHoverBoardModel({
    required this.image,
    required this.startDateTime,
    required this.futureDateTime,
  })  : assert(futureDateTime.isAfter(startDateTime), 'future date cannot be before start date!'),
        totalWaitDays = futureDateTime.difference(startDateTime).inDays;

  @override
  String toString() {
    return 'TimerHoverBoardModel(image: $image, futureDateTime: $futureDateTime)';
  }
}

part of 'calender_cubit.dart';

final class CalenderState extends Equatable {
  final String month;
  final String year;

  bool get isEmpty => month.isEmpty || year.isEmpty;

  const CalenderState({
    this.month = '',
    this.year = '',
  });

  @override
  List<Object> get props => [
        month,
        year,
      ];
}

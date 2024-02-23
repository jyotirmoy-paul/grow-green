import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../services/game_services/time/time_service.dart';

part 'calender_state.dart';

class CalenderCubit extends Cubit<CalenderState> {
  CalenderCubit() : super(const CalenderState()) {
    _init();
  }

  final _dateFormat = DateFormat('MMMM');
  int _lastMonth = -1;

  CalenderState _createCalenderStateFromDateTime(DateTime dateTime) {
    _lastMonth = dateTime.month;

    /// format month & year
    final month = _dateFormat.format(dateTime);
    final year = dateTime.year.toString();

    return CalenderState(
      month: month,
      year: year,
    );
  }

  void _init() {
    /// initial emit
    final dateTime = TimeService().currentDateTime;
    emit(_createCalenderStateFromDateTime(dateTime));

    /// periodic emit
    TimeService().dateTimeStream.listen((dateTime) {
      /// if month has not changed, no need to notify state!
      if (dateTime.month == _lastMonth) return;
      emit(_createCalenderStateFromDateTime(dateTime));
    });
  }
}

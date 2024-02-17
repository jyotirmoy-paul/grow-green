import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../services/time/time_service.dart';

part 'calender_state.dart';

class CalenderCubit extends Cubit<CalenderState> {
  CalenderCubit() : super(const CalenderState()) {
    _init();
  }

  final _dateFormat = DateFormat('MMMM');
  int _lastMonth = -1;

  void _init() {
    TimeService().dateTimeStream.listen((dateTime) {
      /// if month has not changed, no need to move ahead!
      if (dateTime.month == _lastMonth) return;
      _lastMonth = dateTime.month;

      /// for mat month & year
      final month = _dateFormat.format(dateTime);
      final year = dateTime.year.toString();

      emit(
        CalenderState(month: month, year: year),
      );
    });
  }
}

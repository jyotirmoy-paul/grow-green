import '../../game/game/world/components/utils/month.dart';

extension DateTimeExtension on DateTime {
  Month get gameMonth {
    return Month.values[month - 1];
  }
}

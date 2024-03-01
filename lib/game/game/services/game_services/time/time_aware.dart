import 'dart:async';

import 'package:flame/components.dart';

import 'time_service.dart';

mixin TimeAware on Component {
  void onTimeChange(DateTime dateTime);

  @override
  FutureOr<void> onLoad() {
    TimeService().register(this);
    return super.onLoad();
  }

  @override
  void onRemove() {
    super.onRemove();
    TimeService().deregister(this);
  }
}

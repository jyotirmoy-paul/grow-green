import 'package:flame/components.dart';

import 'time_service.dart';

mixin TimeAware on Component {
  void onTimeChange(DateTime dateTime);

  @override
  void onMount() {
    super.onMount();
    TimeService().register(this);
  }

  @override
  void onRemove() {
    super.onRemove();
    TimeService().deregister(this);
  }
}

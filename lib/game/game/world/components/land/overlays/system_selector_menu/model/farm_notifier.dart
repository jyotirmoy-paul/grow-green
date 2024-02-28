import 'package:flutter/material.dart';

import '../../../components/farm/farm.dart';

class FarmNotifier extends ChangeNotifier {
  Farm? _farm;

  Farm? get farm => _farm;

  set farm(Farm? value) {
    _farm = value;
    notifyListeners();
  }
}

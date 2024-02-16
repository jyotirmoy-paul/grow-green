import 'package:flutter/material.dart';

import '../enum/component_id.dart';

class ComponentSelectionModel extends ChangeNotifier {
  ComponentId _componentId;
  int _componentTappedIndex;

  ComponentId get componentId => _componentId;
  int get componentTappedIndex => _componentTappedIndex;

  ComponentSelectionModel({
    required ComponentId componentId,
    required int componentTappedIndex,
  })  : _componentId = componentId,
        _componentTappedIndex = componentTappedIndex;

  void update({
    required ComponentId componentId,
    required int componentTappedIndex,
  }) {
    _componentId = componentId;
    _componentTappedIndex = componentTappedIndex;
    notifyListeners();
  }
}

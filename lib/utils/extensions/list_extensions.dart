import 'package:flutter/material.dart';

extension ListExtension on Iterable<Widget>? {
  List<Widget> addSeparator(Widget separator) {
    if (this == null || this!.isEmpty) return [];

    final modifiedWidgets = <Widget>[];

    for (final widget in this!) {
      modifiedWidgets.add(widget);
      modifiedWidgets.add(separator);
    }

    /// remove last separator
    modifiedWidgets.removeAt(modifiedWidgets.length - 1);

    return modifiedWidgets;
  }
}

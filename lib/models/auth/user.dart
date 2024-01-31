import '../../utils/extensions/string_extensions.dart';

class User {
  final String id;
  final String name;
  final String? displayPicture;

  User({
    required this.id,
    String? name,
    this.displayPicture,
  }) : name = name.isEmptyOrNull ? "User" : name!;
}

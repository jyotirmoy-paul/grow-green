import '../../utils/extensions/string_extensions.dart';

class User {
  final String id;
  final String name;
  final String? displayPicture;
  late final String firstName = name.split(' ').first;
  late final String lastName = name.split(' ').last;

  User({
    required this.id,
    String? name,
    this.displayPicture,
  }) : name = name.isEmptyOrNull ? "User" : name!;
}

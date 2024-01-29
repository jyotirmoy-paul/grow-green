class User {
  final String id;
  final String name;
  final String? displayPicture;

  User({
    required this.id,
    String? name,
    this.displayPicture,
  }) : name = name ?? 'User';
}

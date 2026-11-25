enum UserRole {
  admin(id: 0, name: 'admin'),
  teacher(id: 1, name: 'teacher'),
  student(id: 2, name: 'student'),
  parent(id: 3, name: 'parent'),
  child(id: 4, name: 'child');

  const UserRole({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  static UserRole? fromId(int id) {
    return values.where((element) => element.id == id).firstOrNull;
  }

  static UserRole fromName(String value) {
    return values.firstWhere((element) {
      return element.name.toLowerCase() == value.toLowerCase();
    });
  }
}

enum SocialMediaAuthentication {
  google(id: 1, name: 'Google'),
  apple(id: 2, name: 'Apple'),
  facebook(id: 3, name: 'Facebook'),
  twitter(id: 4, name: 'Twitter');

  const SocialMediaAuthentication({required this.id, required this.name});

  final int id;
  final String name;

  static SocialMediaAuthentication fromId(int value) {
    return values.firstWhere((element) => element.id == value);
  }
}

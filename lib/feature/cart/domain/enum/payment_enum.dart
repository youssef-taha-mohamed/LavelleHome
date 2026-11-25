enum PaymentEnum {
  stripe(id: 0, name: 'Stripe'),
  manual(id: 1, name: 'Manual');

  const PaymentEnum({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  static PaymentEnum fromId(int id) {
    return values.firstWhere(
      (element) => element.id == id,
      orElse: () => PaymentEnum.stripe,
    );
  }

  static PaymentEnum fromValue(String value) {
    return values.firstWhere(
        (element) => element.name.toLowerCase() == value.toLowerCase(),
        orElse: () => PaymentEnum.stripe);
  }
}

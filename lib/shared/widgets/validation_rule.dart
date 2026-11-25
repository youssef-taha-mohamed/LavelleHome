class ValidationRule {
  /// The label text displayed next to the rule indicator.
  final String label;

  /// A function that receives the current field value and returns true if the rule is satisfied.
  final bool Function(String value) check;

  const ValidationRule({required this.label, required this.check});
}

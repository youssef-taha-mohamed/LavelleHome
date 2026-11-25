import 'shared_widgets.dart';

class PhoneFieldExample extends StatefulWidget {
  const PhoneFieldExample({super.key});

  @override
  State<PhoneFieldExample> createState() => _PhoneFieldExampleState();
}

class _PhoneFieldExampleState extends State<PhoneFieldExample> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PhoneNumber? _currentPhoneNumber;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onPhoneChanged(PhoneNumber phoneNumber) {
    setState(() {
      _currentPhoneNumber = phoneNumber;
    });
    debugPrint('Phone changed: ${phoneNumber.completeNumber}');
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phone number: ${_currentPhoneNumber?.completeNumber}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.phone_number),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // مثال لحقل الهاتف الأساسي
              CustomPhone(
                controller: _phoneController,
                onChangedPhoneNumber: _onPhoneChanged,
                label: context.l10n.phone_number,
                helperText: 'أدخل رقم هاتفك مع رمز الدولة',
                showClearButton: true,
                unFocusWhenTapOutside: true,
              ),

              const SizedBox(height: 24),

              // مثال لحقل الهاتف مع إعدادات مخصصة
              CustomPhone(
                initialCountryCode: 'EG',
                onChangedPhoneNumber: (phone) {
                  debugPrint('Egypt phone: ${phone.completeNumber}');
                },
                label: 'رقم الهاتف المصري',
                helperText: 'مثال: +20 123 456 789',
                showClearButton: false,
              ),

              const SizedBox(height: 24),

              // مثال لحقل الهاتف الأمريكي
              CustomPhone(
                initialCountryCode: 'US',
                onChangedPhoneNumber: (phone) {
                  debugPrint('US phone: ${phone.completeNumber}');
                },
                label: 'US Phone Number',
                helperText: 'Example: +1 234 567 8900',
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _onSubmit,
                child: Text('Submit'),
              ),

              const SizedBox(height: 16),

              if (_currentPhoneNumber != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone Details:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                            'Complete Number: ${_currentPhoneNumber!.completeNumber}'),
                        Text(
                            'Country Code: ${_currentPhoneNumber!.countryCode}'),
                        Text(
                            'Country ISO: ${_currentPhoneNumber!.countryISOCode}'),
                        Text('Number: ${_currentPhoneNumber!.number}'),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';
import 'package:image_picker/image_picker.dart';
import '../../../../core/authentication/provider.dart';
import '../../../../shared/enum/gender.dart';
import '../../../../shared/model/api_response.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../country/domain/entities/country.dart';
import '../../../user/domain/entities/profile_modification_data.dart';
import '../../../user/domain/entities/user.dart';
import '../../../user/domain/entities/user_details.dart';
import '../../../user/domain/repositories/user.dart';
import '../../../user/domain/use_cases/update_profile.dart';
import '../form/profile_update_form.dart';

enum UpdateProfileProviderState {
  initial,
  loading,
  success,
  successFetchUser,
  error,
}

class UpdateProfileProvider extends ChangeNotifier {
  UpdateProfileProviderState _state = UpdateProfileProviderState.initial;

  final ProfileUpdateForm form = ProfileUpdateForm();

  final UserBaseRepository _userRepository;

  UpdateProfileProviderState get state => _state;

  String? _errorMessage;
  String? _successMessage;

  UserDetails? userDetails;

  String? get errorMessage => _errorMessage;

  String? get successMessage => _successMessage;

  UpdateProfileProvider(this._userRepository) {
    _initializeForm();
  }

  PhoneNumber? phoneNumber;
  final FocusNode phoneFocusNode = FocusNode();
  String? initialPhoneIsoCode;

  String get phoneCountryIsoCode {
    if (phoneNumber != null && phoneNumber!.countryISOCode.isNotEmpty) {
      return phoneNumber!.countryISOCode;
    }
    if (initialPhoneIsoCode != null) {
      return initialPhoneIsoCode!;
    }
    return selectedCountryIsoCode;
  }

  /// Returns the dial code without '+' (e.g. '20' for Egypt)
  String get selectedCountryDialCode {
    final country = form.selectedCountry;
    if (country == null) return '20';
    return country.code.replaceFirst('+', '');
  }

  /// Returns the ISO code (e.g. 'EG' for Egypt)
  String get selectedCountryIsoCode {
    final country = form.selectedCountry;
    if (country == null) return 'EG';

    if (country.isoCode.isNotEmpty) {
      return country.isoCode;
    }

    final cleanDialCode = country.code.replaceFirst('+', '');
    try {
      final resolved = PhoneNumber.getCountry('+$cleanDialCode');
      return resolved.code;
    } catch (e) {
      return 'EG';
    }
  }

  void updatePhoneNumber(PhoneNumber number) {
    phoneNumber = number;
    form.phoneFullNumber = number.number;
    notifyListeners();
  }

  void _initializeForm() {
    final authUser = AuthenticationProvider.instance.currentUser?.details;
    if (authUser == null) return;

    String rawPhone = authUser.phone;
    String localPhone = rawPhone;
    String phoneCode = authUser.phoneNumberCode;
    if (phoneCode.isEmpty) phoneCode = authUser.country.code;
    final cleanPhoneDialCode = phoneCode.replaceAll('+', '');

    try {
      final resolved = PhoneNumber.getCountry('+$cleanPhoneDialCode');
      initialPhoneIsoCode = resolved.code;
    } catch (e) {
      initialPhoneIsoCode = authUser.country.isoCode;
      if (initialPhoneIsoCode == null || initialPhoneIsoCode!.isEmpty) {
        initialPhoneIsoCode = 'EG';
      }
    }

    // If it starts with +20 or +
    if (localPhone.startsWith('+')) {
      localPhone = localPhone.substring(1);
      if (localPhone.startsWith(cleanPhoneDialCode)) {
        localPhone = localPhone.substring(cleanPhoneDialCode.length);
      }
    }
    // If it starts with 0020
    else if (localPhone.startsWith('00')) {
      localPhone = localPhone.substring(2);
      if (localPhone.startsWith(cleanPhoneDialCode)) {
        localPhone = localPhone.substring(cleanPhoneDialCode.length);
      }
    }
    // If it starts with exactly the clean dial code (e.g. 20111...) and no + or 00
    // We assume it's the country code if the remaining length matches local phone length?
    // Just blindly stripping might be dangerous, but if the old app saved it as 20111... we must strip it.
    else if (localPhone.startsWith(cleanPhoneDialCode) &&
        localPhone.length > 10) {
      if (cleanPhoneDialCode.isNotEmpty) {
        localPhone = localPhone.substring(cleanPhoneDialCode.length);
      }
    }

    if (localPhone.startsWith('0')) {
      localPhone = localPhone.substring(1);
    }

    final userProfile = UserProfileModel(
      id: authUser.id,
      userName: authUser.username,
      email: authUser.email,
      fullName: authUser.fullName,
      phone: localPhone,
      image: authUser.image,
      birthday: authUser.birthday,
      gender: authUser.gender,
      countryId: authUser.country.id,
      notes: authUser.notes,
      address: authUser.address,
      phoneNumberCode: authUser.phoneNumberCode,
    );

    form.fillData(userProfile);
    form.selectedCountry = authUser.country;

    // Set the phone controller to the local number (without leading 0
    form.phoneController.text = localPhone;

    // Initialize phoneNumber object
    phoneNumber = PhoneNumber(
      countryISOCode: phoneCountryIsoCode,
      countryCode: '+$cleanPhoneDialCode',
      number: localPhone,
    );
    form.phoneFullNumber = localPhone;

    form.fullNameController.addListener(notifyListeners);
    form.phoneController.addListener(notifyListeners);
    form.address.addListener(notifyListeners);
    form.notes.addListener(notifyListeners);
  }

  Future<void> selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: form.birthday ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != form.birthday) {
      form.birthday = picked;
      notifyListeners();
    }
  }

  Future<void> changeProfilePicture(BuildContext context) async {
    if (kIsWeb) {
      // Web: use file picker directly (no bottom sheet, no camera)
      final XFile? xFile = await ImageBottomSheet.showForWeb(context);
      if (xFile != null) {
        form.imageFile = xFile;
        notifyListeners();
      }
    } else {
      // Mobile: show bottom sheet with camera & gallery options
      final XFile? xFile = await ImageBottomSheet.show(context);
      if (xFile != null) {
        form.imageFile = xFile;
        notifyListeners();
      }
    }
  }

  void selectCountry(Countries country) {
    form.selectedCountry = country;
    notifyListeners();
  }

  void selectGender(Gender gender) {
    form.gender = gender;
    notifyListeners();
  }

  void _setState(UpdateProfileProviderState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> saveProfile(BuildContext context) async {
    _errorMessage = null;
    try {
      _setState(UpdateProfileProviderState.loading);

      // Build the parameter from form
      var dataToUpdate = ProfileModificationData(
        userId: form.parameter.userId,
        gender: form.gender ?? form.userProfile?.gender,
        fullName: form.fullNameController.text,
        phone: form.phoneFullNumber ?? form.phoneController.text,
        birthDate: form.birthday ?? form.userProfile?.birthday,
        imagePath: form.imageFile?.path,
        imageName: form.imageFile?.name,
        imageUrl: form.imageFile == null
            ? (form.imageUrl ?? form.initialImageUrl)
            : null,
        notes: form.notes.text,
        address: form.address.text,
        countryId: form.selectedCountry?.id ?? form.userProfile?.countryId,
        phoneNumberCode:
            phoneNumber?.countryCode ?? form.userProfile?.phoneNumberCode,
        isoCode: phoneNumber?.countryISOCode ?? phoneCountryIsoCode,
      );

      // If there's an image on Web, read bytes and attach them
      if (kIsWeb && form.imageFile != null) {
        final Uint8List bytes = await form.imageFile!.readAsBytes();
        dataToUpdate = ProfileModificationData(
          userId: dataToUpdate.userId,
          gender: dataToUpdate.gender,
          fullName: dataToUpdate.fullName,
          phone: dataToUpdate.phone,
          birthDate: dataToUpdate.birthDate,
          imageBytes: bytes,
          imageName: form.imageFile!.name,
          notes: dataToUpdate.notes,
          address: dataToUpdate.address,
          countryId: dataToUpdate.countryId,
          phoneNumberCode: dataToUpdate.phoneNumberCode,
          isoCode: dataToUpdate.isoCode,
          imageUrl: dataToUpdate.imageUrl,
        );
      }

      final useCase = UpdateProfile(repository: _userRepository);
      final ApiResponse<UserDetails> newDetails = await useCase.call(
        parameter: dataToUpdate,
      );

      form.imageUrl = newDetails.record.image;
      form.imageFile = null;

      _setState(UpdateProfileProviderState.success);

      final authProvider = AuthenticationProvider.instance;
      final currentToken = authProvider.currentUser?.accessToken;

      if (currentToken != null) {
        final updatedUser = User(
          accessToken: currentToken,
          details: newDetails.record,
        );

        authProvider.refreshUser(childId: newDetails.record.id);
        authProvider.sinkUser(updatedUser);
      } else {
        log('UpdateProfileProvider Error: User token is null after update.');
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: MainText(newDetails.message),
            backgroundColor: MyColors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e, s) {
      log('UpdateProfileProvider - saveProfile error: $e');
      log('UpdateProfileProvider - saveProfile location: $s');
      _setState(UpdateProfileProviderState.error);
      _errorMessage = e.toString();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: MainText(_errorMessage ?? ""),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    phoneFocusNode.dispose();
    form.dispose();
    super.dispose();
  }
}

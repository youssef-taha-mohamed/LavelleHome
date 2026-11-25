import 'package:equatable/equatable.dart';
import '../../../../shared/enum/gender.dart';
import '../../../../shared/enum/user_role.dart';
import '../../../country/domain/entities/country.dart';
import 'preference.dart';

base class UserDetails extends Equatable {
  const UserDetails({
    required this.id,
    required this.username,
    required this.email,
    this.address,
    required this.fullName,
    required this.phone,
    this.birthday,
    required this.gender,
    required this.emailVerified,
    required this.role,
    this.image,
    required this.country,
    required this.notificationEnabled,
    this.notes,
    required this.isAdult,
    required this.preference,
    required this.phoneNumberCode,
  });

  final String id;
  final String username;
  final String email;
  final String? address;
  final String fullName;
  final String phone;
  final DateTime? birthday;
  final Gender? gender;
  final bool emailVerified;
  final UserRole role;
  final bool notificationEnabled;
  final String? image;
  final Countries country;
  final String? notes;
  final Preference preference;
  final bool isAdult;
  final String phoneNumberCode;

  /// Calculates the current age of the user based on their birthday.
  /// This calculation is highly accurate as it accounts for the month and day.
  int get age {
    if (birthday == null) return 0;
    final now = DateTime.now();
    int age = now.year - birthday!.year;
    if (now.month < birthday!.month ||
        (now.month == birthday!.month && now.day < birthday!.day)) {
      age--;
    }
    return age;
  }

  /// Returns whether the user is a boy or a girl.
  /// Returns 'ولد' for male and 'بنت' for female.
  String get genderLabel {
    if (gender == Gender.male) return 'ولد';
    if (gender == Gender.female) return 'بنت';
    return 'غير محدد';
  }

  /// Helper to check if the user is a boy.
  bool get isBoy => gender == Gender.male;

  /// Helper to check if the user is a girl.
  bool get isGirl => gender == Gender.female;

  UserDetails copyWith({
    String? id,
    String? username,
    String? email,
    String? address,
    String? fullName,
    String? phone,
    DateTime? birthday,
    Gender? gender,
    bool? emailVerified,
    UserRole? role,
    String? image,
    Countries? country,
    bool? notificationEnabled,
    String? notes,
    Preference? preference,
    bool? isAdult,
    String? phoneNumberCode,
  }) {
    return UserDetails(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      address: address ?? this.address,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      emailVerified: emailVerified ?? this.emailVerified,
      role: role ?? this.role,
      image: image ?? this.image,
      country: country ?? this.country,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      notes: notes ?? this.notes,
      preference: preference ?? this.preference,
      isAdult: isAdult ?? this.isAdult,
      phoneNumberCode: phoneNumberCode ?? this.phoneNumberCode,
    );
  }

  @override
  List<Object?> get props {
    return <Object?>[
      id,
      username,
      email,
      address,
      fullName,
      phone,
      birthday,
      gender,
      emailVerified,
      role,
      image,
      country,
      notificationEnabled,
      notes,
      isAdult,
      preference,
      phoneNumberCode,
    ];
  }
}

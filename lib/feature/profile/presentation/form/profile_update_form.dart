import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../shared/enum/gender.dart';
import '../../../country/domain/entities/country.dart';
import '../../../user/domain/entities/profile_modification_data.dart';
import '../../../user/domain/enums/field.dart';

class ProfileUpdateForm {
  String? userId;
  UserProfile? userProfile;
  String _initialFullName = '';
  String _initialAddress = '';
  String _initialNotes = '';
  String _initialPhone = '';
  DateTime? _initialBirthday;
  String? initialImageUrl;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController notes = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  DateTime? birthday;
  XFile? imageFile;
  Gender? gender;
  Countries? selectedCountry;
  String? imageUrl;

  void fillData(UserProfile data) {
    fullNameController.text = data.fullName ?? '';
    userNameController.text = data.userName ?? '';
    emailController.text = data.email ?? '';
    phoneController.text = data.phone ?? '';
    birthday = data.birthday;
    gender = data.gender;
    address.text = data.address ?? '';
    notes.text = data.notes ?? '';
    userProfile = data;
    if (data.image != null) {
      imageUrl = data.image;
    }
    _initialFullName = data.fullName ?? '';
    _initialAddress = data.address ?? '';
    _initialNotes = data.notes ?? '';
    _initialPhone = data.phone ?? '';
    _initialBirthday = data.birthday;
    initialImageUrl = data.image;
  }

  /// Optional override for the full phone number (with country code)
  String? phoneFullNumber;

  bool get hasChanges {
    final currentPhone = phoneFullNumber ?? phoneController.text;
    return fullNameController.text.trim() != _initialFullName.trim() ||
        address.text.trim() != _initialAddress.trim() ||
        notes.text.trim() != _initialNotes.trim() ||
        currentPhone.trim() != _initialPhone.trim() ||
        birthday != _initialBirthday ||
        imageFile != null;
  }

  ProfileModificationData get parameter {
    final idToSend = userId ?? '';
    return ProfileModificationData(
      userId: idToSend,
      gender: gender,
      fullName: fullNameController.text,
      phone: phoneFullNumber ?? phoneController.text,
      birthDate: birthday,
      // imagePath & imageBytes are set by the provider after picking
      imagePath: imageFile?.path,
      imageName: imageFile?.name,
      notes: notes.text,
      address: address.text,
    );
  }

  void dispose() {
    fullNameController.dispose();
    userNameController.dispose();
    phoneController.dispose();
    address.dispose();
    notes.dispose();
  }
}

base class UserProfile extends Equatable {
  final String? id;
  final String? userName;
  final String? email;
  final String? fullName;
  final String? phone;
  final String? image;
  final DateTime? birthday;
  final Gender? gender;
  final num? countryId;
  final String? notes;
  final String? address;
  final String? phoneNumberCode;

  const UserProfile({
    this.id,
    required this.userName,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.image,
    required this.birthday,
    required this.gender,
    required this.countryId,
    required this.notes,
    required this.address,
    required this.phoneNumberCode,
  });

  @override
  List<Object?> get props {
    return <Object?>[
      id,
      userName,
      email,
      fullName,
      phone,
      image,
      birthday,
      gender,
      countryId,
      notes,
      address,
      phoneNumberCode,
    ];
  }
}

final class UserProfileModel extends UserProfile {
  const UserProfileModel({
    super.id,
    required super.userName,
    required super.email,
    required super.fullName,
    required super.phone,
    required super.image,
    required super.birthday,
    required super.gender,
    required super.countryId,
    required super.notes,
    required super.address,
    required super.phoneNumberCode,
  });

  factory UserProfileModel.fromJson({required String json}) {
    return UserProfileModel.fromMap(
      map: Map<String, dynamic>.from(jsonDecode(json) as Map),
    );
  }

  factory UserProfileModel.fromMap({required Map<String, dynamic> map}) {
    return UserProfileModel(
      id: map[UserField.id.value] as String?,
      userName: map[UserField.userName.value] as String,
      email: map[UserField.email.value] as String?,
      fullName: map[UserField.fullName.value],
      phone: map[UserField.phone.value] as String,
      image: map[UserField.image.value],
      birthday: map[UserField.birthday.value] == null
          ? null
          : DateTime.tryParse(map[UserField.birthday.value]),
      gender: Gender.fromId(map[UserField.gender.value]),
      countryId: map[UserField.countryId.value],
      notes: map[UserField.notes.value],
      address: map[UserField.address.value],
      phoneNumberCode: map[UserField.phoneNumberCode.value] as String?,
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      UserField.id.value: id,
      UserField.userName.value: userName,
      UserField.email.value: email,
      UserField.fullName.value: fullName,
      UserField.phone.value: phone,
      UserField.image.value: image,
      UserField.birthday.value: birthday,
      UserField.gender.value: gender,
      UserField.countryId.value: countryId,
      UserField.notes.value: notes,
      UserField.address.value: address,
      UserField.phoneNumberCode.value: phoneNumberCode,
    };
  }

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      userName: entity.userName,
      email: entity.email,
      fullName: entity.fullName,
      phone: entity.phone,
      image: entity.image,
      birthday: entity.birthday,
      gender: entity.gender,
      countryId: entity.countryId,
      notes: entity.notes,
      address: entity.address,
      phoneNumberCode: entity.phoneNumberCode,
    );
  }
}

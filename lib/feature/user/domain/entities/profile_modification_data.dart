import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import '../../../../shared/enum/gender.dart';

base class ProfileModificationData extends Equatable {
  const ProfileModificationData({
    this.userId,
    this.countryId,
    this.birthDate,
    this.userName,
    this.fullName,
    this.gender,
    this.imagePath,
    this.imageBytes,
    this.imageName,
    this.imageUrl,
    this.phone,
    this.notes,
    this.address,
    this.phoneNumberCode,
    this.isoCode,
  });

  final String? userId;
  final num? countryId;
  final DateTime? birthDate;
  final String? userName;
  final Gender? gender;

  /// Mobile: absolute path to the image file
  final String? imagePath;
  final String? imageUrl;

  /// Web: raw bytes of the selected image
  final Uint8List? imageBytes;

  /// Filename to use when uploading (e.g. 'profile.jpg')
  final String? imageName;

  final String? fullName;
  final String? phone;
  final String? notes;
  final String? address;
  final String? isoCode;
  final String? phoneNumberCode;

  bool get hasImage => imagePath != null || imageBytes != null;

  @override
  List<Object?> get props {
    return <Object?>[
      userId,
      birthDate,
      countryId,
      fullName,
      gender,
      imagePath,
      imageBytes,
      imageName,
      phone,
      userName,
      notes,
      address,
      phoneNumberCode,
      isoCode,
      imageUrl,
    ];
  }
}

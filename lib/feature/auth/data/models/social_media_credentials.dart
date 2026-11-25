import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../domain/entities/social_media_credentials.dart';
import '../../domain/enums/field.dart';
import '../../domain/enums/social_media.dart';

final class SocialMediaCredentialsDTO extends SocialMediaCredentials {
  const SocialMediaCredentialsDTO({
    required super.token,
    required super.socialMedia,
  });

  SocialMediaCredentialsDTO copyWith({
    String? token,
    SocialMediaAuthentication? socialMedia,
  }) {
    return SocialMediaCredentialsDTO(
      token: token ?? this.token,
      socialMedia: socialMedia ?? this.socialMedia,
    );
  }

  factory SocialMediaCredentialsDTO.fromJson(String json) {
    return SocialMediaCredentialsDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json) as Map),
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory SocialMediaCredentialsDTO.fromMap(Map<String, dynamic> json) {
    return SocialMediaCredentialsDTO(
      token: json[AuthField.token.value] as String,
      socialMedia: SocialMediaAuthentication.fromId(
        json[AuthField.socialMedia.value] as int,
      ),
    );
  }

  factory SocialMediaCredentialsDTO.fromEntity(
    SocialMediaCredentials entity,
  ) {
    return SocialMediaCredentialsDTO(
      token: entity.token,
      socialMedia: entity.socialMedia,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      AuthField.socialMedia.value: socialMedia.id,
      AuthField.token.value: token,
      AuthField.platform.value: kIsWeb
          ? 1
          : (defaultTargetPlatform == TargetPlatform.iOS ? 3 : 2),
    };
  }
}

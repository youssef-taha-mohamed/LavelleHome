enum AuthField {
  birthDay(value: 'dateOfBirth'),
  email(value: 'email'),
  userName(value: 'userName'),
  usernameOrEmail(value: 'usernameOrEmail'),
  fcmToken(value: 'fcmToken'),
  gender(value: 'gender'),
  fullName(value: 'fullName'),
  deviceType(value: 'deviceType'),
  otp(value: 'otp'),
  password(value: 'password'),
  newPassword(value: 'newPassword'),
  phoneNumber(value: 'phoneNumber'),
  address(value: 'address'),
  notes(value: 'notes'),
  userId(value: 'userId'),
  type(value: 'userType'),
  countryId(value: 'countryId'),
  socialMedia(value: 'provider'),
  parentId(value: 'parentId'),
  languageId(value: 'languageId'),
  theme(value: 'theme'),
  token(value: 'externalToken'),
  phoneNumberCode(value: "phoneCountryCode"),
  isoCode(value: "phoneCountryIsoCode"),
  user(value: 'user'),
  actAs(value: 'actAs'),
  actAsName(value: 'actAsName'),
  imp(value: 'imp'),
  childId(value: 'childId'),
  platform(value: 'platform');

  const AuthField({required this.value});

  final String value;
}

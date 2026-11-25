import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @a_class.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get a_class;

  /// No description provided for @academic_courses.
  ///
  /// In en, this message translates to:
  /// **'Academic Courses'**
  String get academic_courses;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @account_information.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get account_information;

  /// No description provided for @account_name.
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get account_name;

  /// No description provided for @account_number.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get account_number;

  /// No description provided for @activated.
  ///
  /// In en, this message translates to:
  /// **'Activated'**
  String get activated;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @active_loc.
  ///
  /// In en, this message translates to:
  /// **'Enable Location'**
  String get active_loc;

  /// No description provided for @add_rating.
  ///
  /// In en, this message translates to:
  /// **'Add Rating'**
  String get add_rating;

  /// No description provided for @add_to_list.
  ///
  /// In en, this message translates to:
  /// **'Add to List'**
  String get add_to_list;

  /// No description provided for @additional_information.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additional_information;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @address_information.
  ///
  /// In en, this message translates to:
  /// **'Address Information'**
  String get address_information;

  /// No description provided for @agree_terms_conditions.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms and Conditions'**
  String get agree_terms_conditions;

  /// No description provided for @all_categories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get all_categories;

  /// No description provided for @all_notifications.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String all_notifications(Object count);

  /// No description provided for @app_language.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get app_language;

  /// No description provided for @app_settings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get app_settings;

  /// No description provided for @app_theme.
  ///
  /// In en, this message translates to:
  /// **'App Theme'**
  String get app_theme;

  /// No description provided for @app_version.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get app_version;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @application_info.
  ///
  /// In en, this message translates to:
  /// **'Application Information'**
  String get application_info;

  /// No description provided for @are_you_sure_clear_cart.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear your cart?'**
  String get are_you_sure_clear_cart;

  /// No description provided for @are_you_sure_delete_item_cart.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this item from the cart?'**
  String get are_you_sure_delete_item_cart;

  /// No description provided for @are_you_sure_you_want_exit.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get are_you_sure_you_want_exit;

  /// No description provided for @are_you_sure_you_want_to_delete_your_account.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get are_you_sure_you_want_to_delete_your_account;

  /// No description provided for @are_you_sure_you_want_to_logout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get are_you_sure_you_want_to_logout;

  /// No description provided for @at_least_one_number.
  ///
  /// In en, this message translates to:
  /// **'At least one number'**
  String get at_least_one_number;

  /// No description provided for @at_least_one_special_char.
  ///
  /// In en, this message translates to:
  /// **'At least one special character'**
  String get at_least_one_special_char;

  /// No description provided for @attach_images.
  ///
  /// In en, this message translates to:
  /// **'Attach Images'**
  String get attach_images;

  /// No description provided for @available_country.
  ///
  /// In en, this message translates to:
  /// **'Available Countries'**
  String get available_country;

  /// No description provided for @available_languages.
  ///
  /// In en, this message translates to:
  /// **'Available Languages'**
  String get available_languages;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @back_button.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back_button;

  /// No description provided for @back_gain.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get back_gain;

  /// No description provided for @back_to_home.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get back_to_home;

  /// No description provided for @bank_name.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bank_name;

  /// No description provided for @birth_date.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get birth_date;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get birthday;

  /// No description provided for @booking_successful.
  ///
  /// In en, this message translates to:
  /// **'Booking Successful'**
  String get booking_successful;

  /// No description provided for @browse_courses.
  ///
  /// In en, this message translates to:
  /// **'Browse Courses'**
  String get browse_courses;

  /// No description provided for @build_number.
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get build_number;

  /// No description provided for @call_us.
  ///
  /// In en, this message translates to:
  /// **'Call Us'**
  String get call_us;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @change_completed_successfully.
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully'**
  String get change_completed_successfully;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @change_password_desc.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password and a new secure password'**
  String get change_password_desc;

  /// No description provided for @change_password_you_login_again.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully. Please log in again.'**
  String get change_password_you_login_again;

  /// No description provided for @change_profile_image.
  ///
  /// In en, this message translates to:
  /// **'Change Profile Image'**
  String get change_profile_image;

  /// No description provided for @change_your_password.
  ///
  /// In en, this message translates to:
  /// **'Change Your Password'**
  String get change_your_password;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @child_personal_information.
  ///
  /// In en, this message translates to:
  /// **'Child\'s Personal Information'**
  String get child_personal_information;

  /// No description provided for @choose_appropriate_method.
  ///
  /// In en, this message translates to:
  /// **'Choose the appropriate method'**
  String get choose_appropriate_method;

  /// No description provided for @choose_appropriate_method_continue.
  ///
  /// In en, this message translates to:
  /// **'Choose the appropriate method to continue'**
  String get choose_appropriate_method_continue;

  /// No description provided for @choose_photo.
  ///
  /// In en, this message translates to:
  /// **'Choose Photo'**
  String get choose_photo;

  /// No description provided for @choose_preferred_language.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get choose_preferred_language;

  /// No description provided for @choose_your_account_type.
  ///
  /// In en, this message translates to:
  /// **'Choose your account type'**
  String get choose_your_account_type;

  /// No description provided for @clear_shopping_cart.
  ///
  /// In en, this message translates to:
  /// **'Clear Shopping Cart'**
  String get clear_shopping_cart;

  /// No description provided for @code_sent_successfully.
  ///
  /// In en, this message translates to:
  /// **'Code sent successfully'**
  String get code_sent_successfully;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @complete_apple_profile.
  ///
  /// In en, this message translates to:
  /// **'Complete Apple Profile'**
  String get complete_apple_profile;

  /// No description provided for @complete_google_profile.
  ///
  /// In en, this message translates to:
  /// **'Complete Google Profile'**
  String get complete_google_profile;

  /// No description provided for @complete_profile.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get complete_profile;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirm_delete_all_notifications.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all notifications?'**
  String get confirm_delete_all_notifications;

  /// No description provided for @confirm_delete_notification.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this notification?'**
  String get confirm_delete_notification;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @confirm_password_validation.
  ///
  /// In en, this message translates to:
  /// **'Passwords must match'**
  String get confirm_password_validation;

  /// No description provided for @contact_desc.
  ///
  /// In en, this message translates to:
  /// **'We are here to help. Feel free to reach out anytime.'**
  String get contact_desc;

  /// No description provided for @contact_information.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contact_information;

  /// No description provided for @contact_privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Inquiries'**
  String get contact_privacy;

  /// No description provided for @contact_privacy_text.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions regarding this privacy policy, please contact our support team.'**
  String get contact_privacy_text;

  /// No description provided for @contact_support_.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contact_support_;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_us;

  /// No description provided for @continue_as_guest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get continue_as_guest;

  /// No description provided for @continue_registration.
  ///
  /// In en, this message translates to:
  /// **'Continue registration'**
  String get continue_registration;

  /// No description provided for @continue_step.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_step;

  /// No description provided for @courses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get create_account;

  /// No description provided for @create_new_account.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get create_new_account;

  /// No description provided for @crop_image.
  ///
  /// In en, this message translates to:
  /// **'Crop Image'**
  String get crop_image;

  /// No description provided for @current_and_store_version.
  ///
  /// In en, this message translates to:
  /// **'Current: {current} • Store: {store}'**
  String current_and_store_version(String current, String store);

  /// No description provided for @current_password.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get current_password;

  /// No description provided for @current_version.
  ///
  /// In en, this message translates to:
  /// **'Current version: {version}'**
  String current_version(String version);

  /// No description provided for @customization.
  ///
  /// In en, this message translates to:
  /// **'Customization'**
  String get customization;

  /// No description provided for @dark_theme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get dark_theme;

  /// No description provided for @data_security.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get data_security;

  /// No description provided for @data_security_text.
  ///
  /// In en, this message translates to:
  /// **'We employ robust security measures including encryption and strict access controls to safeguard your data.'**
  String get data_security_text;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @date_of_birth_validation.
  ///
  /// In en, this message translates to:
  /// **'Please select your date of birth'**
  String get date_of_birth_validation;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @delete_account_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete your account? This action cannot be undone.'**
  String get delete_account_message;

  /// No description provided for @delete_account_warning.
  ///
  /// In en, this message translates to:
  /// **'All your data and courses will be permanently deleted.'**
  String get delete_account_warning;

  /// No description provided for @delete_all.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get delete_all;

  /// No description provided for @delete_all_notifications.
  ///
  /// In en, this message translates to:
  /// **'Delete all notifications'**
  String get delete_all_notifications;

  /// No description provided for @delete_item_from_cart.
  ///
  /// In en, this message translates to:
  /// **'Remove from cart'**
  String get delete_item_from_cart;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @didnt_receive_otp.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get didnt_receive_otp;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @do_not_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get do_not_have_account;

  /// No description provided for @edit_email.
  ///
  /// In en, this message translates to:
  /// **'Edit Email'**
  String get edit_email;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @effective_date.
  ///
  /// In en, this message translates to:
  /// **'Effective Date'**
  String get effective_date;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @email_err.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get email_err;

  /// No description provided for @email_us.
  ///
  /// In en, this message translates to:
  /// **'Email Us'**
  String get email_us;

  /// No description provided for @email_userName.
  ///
  /// In en, this message translates to:
  /// **'Email or Username'**
  String get email_userName;

  /// No description provided for @email_va.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get email_va;

  /// No description provided for @empty_cart.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty'**
  String get empty_cart;

  /// No description provided for @empty_cart_description.
  ///
  /// In en, this message translates to:
  /// **'Explore our courses and add them to your cart to get started'**
  String get empty_cart_description;

  /// No description provided for @enjoy.
  ///
  /// In en, this message translates to:
  /// **'Enjoy'**
  String get enjoy;

  /// No description provided for @enter_class_now.
  ///
  /// In en, this message translates to:
  /// **'Enter Class Now'**
  String get enter_class_now;

  /// No description provided for @enter_otp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enter_otp;

  /// No description provided for @enter_password.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enter_password;

  /// No description provided for @enter_your_current_new_password.
  ///
  /// In en, this message translates to:
  /// **'Enter your current and new password'**
  String get enter_your_current_new_password;

  /// No description provided for @enter_your_email_to_reset_your_password.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to reset your password'**
  String get enter_your_email_to_reset_your_password;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @failed_to_resend_otp.
  ///
  /// In en, this message translates to:
  /// **'Failed to resend code'**
  String get failed_to_resend_otp;

  /// No description provided for @faq_a1.
  ///
  /// In en, this message translates to:
  /// **'Konoz is an educational platform offering comprehensive courses and specialized lessons to support your learning journey.'**
  String get faq_a1;

  /// No description provided for @faq_a2.
  ///
  /// In en, this message translates to:
  /// **'You can create an account by selecting \'New Account\' on the login screen and following the registration steps.'**
  String get faq_a2;

  /// No description provided for @faq_a3.
  ///
  /// In en, this message translates to:
  /// **'We support multiple secure payment methods including online card payments and direct bank transfer.'**
  String get faq_a3;

  /// No description provided for @faq_a4.
  ///
  /// In en, this message translates to:
  /// **'Yes, all transactions are fully encrypted and adhere to highest global security standards.'**
  String get faq_a4;

  /// No description provided for @faq_a5.
  ///
  /// In en, this message translates to:
  /// **'Click on \'Forgot Password?\' on the login screen and enter your registered email to receive a reset code.'**
  String get faq_a5;

  /// No description provided for @faq_a6.
  ///
  /// In en, this message translates to:
  /// **'Yes, you have full access to enrolled course materials anytime via your dashboard.'**
  String get faq_a6;

  /// No description provided for @faq_a7.
  ///
  /// In en, this message translates to:
  /// **'You can reach our support team through the Contact Us page, email, or WhatsApp for quick help.'**
  String get faq_a7;

  /// No description provided for @faq_a8.
  ///
  /// In en, this message translates to:
  /// **'Yes, you can easily renew any active or expiring course directly through the app.'**
  String get faq_a8;

  /// No description provided for @faq_q1.
  ///
  /// In en, this message translates to:
  /// **'What is the Konoz platform?'**
  String get faq_q1;

  /// No description provided for @faq_q2.
  ///
  /// In en, this message translates to:
  /// **'How do I create a new account?'**
  String get faq_q2;

  /// No description provided for @faq_q3.
  ///
  /// In en, this message translates to:
  /// **'What payment methods are supported?'**
  String get faq_q3;

  /// No description provided for @faq_q4.
  ///
  /// In en, this message translates to:
  /// **'Is the payment process secure?'**
  String get faq_q4;

  /// No description provided for @faq_q5.
  ///
  /// In en, this message translates to:
  /// **'How can I reset my password?'**
  String get faq_q5;

  /// No description provided for @faq_q6.
  ///
  /// In en, this message translates to:
  /// **'Can I access courses after enrollment?'**
  String get faq_q6;

  /// No description provided for @faq_q7.
  ///
  /// In en, this message translates to:
  /// **'How do I contact technical support?'**
  String get faq_q7;

  /// No description provided for @faq_q8.
  ///
  /// In en, this message translates to:
  /// **'Can I renew course subscriptions?'**
  String get faq_q8;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqs;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @field_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get field_required;

  /// No description provided for @file_selected.
  ///
  /// In en, this message translates to:
  /// **'File selected'**
  String get file_selected;

  /// No description provided for @for_parent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get for_parent;

  /// No description provided for @for_parent_text.
  ///
  /// In en, this message translates to:
  /// **'For parents to follow up on their children\'s educational progress'**
  String get for_parent_text;

  /// No description provided for @for_students.
  ///
  /// In en, this message translates to:
  /// **'For Students'**
  String get for_students;

  /// No description provided for @for_your_vehicle.
  ///
  /// In en, this message translates to:
  /// **'For your service'**
  String get for_your_vehicle;

  /// No description provided for @forget_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forget_password;

  /// No description provided for @frequently.
  ///
  /// In en, this message translates to:
  /// **'Frequently'**
  String get frequently;

  /// No description provided for @frequently_asked.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequently_asked;

  /// No description provided for @from_15_to_20_characters.
  ///
  /// In en, this message translates to:
  /// **'From 15 to 25 characters'**
  String get from_15_to_20_characters;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @full_name_validation.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get full_name_validation;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @get_help_support.
  ///
  /// In en, this message translates to:
  /// **'Get Help & Support'**
  String get get_help_support;

  /// No description provided for @get_in_touch.
  ///
  /// In en, this message translates to:
  /// **'Get in Touch'**
  String get get_in_touch;

  /// No description provided for @good_evening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get good_evening;

  /// No description provided for @good_evening_tablet.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get good_evening_tablet;

  /// No description provided for @good_morning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get good_morning;

  /// No description provided for @good_morning_tablet.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get good_morning_tablet;

  /// No description provided for @good_night.
  ///
  /// In en, this message translates to:
  /// **'Good Night'**
  String get good_night;

  /// No description provided for @good_night_tablet.
  ///
  /// In en, this message translates to:
  /// **'Good Night'**
  String get good_night_tablet;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @help_and_support.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get help_and_support;

  /// No description provided for @high_quality_education.
  ///
  /// In en, this message translates to:
  /// **'High Quality Education'**
  String get high_quality_education;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @how_we_use.
  ///
  /// In en, this message translates to:
  /// **'How We Use Information'**
  String get how_we_use;

  /// No description provided for @how_we_use_text.
  ///
  /// In en, this message translates to:
  /// **'We use your data to deliver courses, improve services, process payments, and communicate important updates.'**
  String get how_we_use_text;

  /// No description provided for @iban.
  ///
  /// In en, this message translates to:
  /// **'IBAN'**
  String get iban;

  /// No description provided for @important_reminders.
  ///
  /// In en, this message translates to:
  /// **'Important Reminders'**
  String get important_reminders;

  /// No description provided for @info_we_collect.
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get info_we_collect;

  /// No description provided for @info_we_collect_text.
  ///
  /// In en, this message translates to:
  /// **'We collect information you provide directly, such as your name, email, phone number, and account details.'**
  String get info_we_collect_text;

  /// No description provided for @introduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get introduction;

  /// No description provided for @introduction_text.
  ///
  /// In en, this message translates to:
  /// **'We respect your privacy and are committed to protecting your personal data in accordance with privacy laws.'**
  String get introduction_text;

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalid_email;

  /// No description provided for @invalid_otp.
  ///
  /// In en, this message translates to:
  /// **'Invalid code'**
  String get invalid_otp;

  /// No description provided for @invalid_password_characters.
  ///
  /// In en, this message translates to:
  /// **'Password contains invalid characters'**
  String get invalid_password_characters;

  /// No description provided for @invalid_phone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalid_phone;

  /// No description provided for @invalid_user_name_characters.
  ///
  /// In en, this message translates to:
  /// **'Username contains invalid characters'**
  String get invalid_user_name_characters;

  /// No description provided for @items_basket.
  ///
  /// In en, this message translates to:
  /// **'items in basket'**
  String get items_basket;

  /// No description provided for @job_title.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get job_title;

  /// No description provided for @keep_up_great.
  ///
  /// In en, this message translates to:
  /// **'Keep up the great work!'**
  String get keep_up_great;

  /// No description provided for @knoz.
  ///
  /// In en, this message translates to:
  /// **'Konoz'**
  String get knoz;

  /// No description provided for @knoz_education_app.
  ///
  /// In en, this message translates to:
  /// **'Konoz Educational App'**
  String get knoz_education_app;

  /// No description provided for @konoz.
  ///
  /// In en, this message translates to:
  /// **'Konoz'**
  String get konoz;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @language_change_notice.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get language_change_notice;

  /// No description provided for @last_updated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get last_updated;

  /// No description provided for @laundry_tagline.
  ///
  /// In en, this message translates to:
  /// **'Premium laundry care, right at your door'**
  String get laundry_tagline;

  /// No description provided for @lectures.
  ///
  /// In en, this message translates to:
  /// **'Lectures'**
  String get lectures;

  /// No description provided for @lesson.
  ///
  /// In en, this message translates to:
  /// **'Lesson'**
  String get lesson;

  /// No description provided for @light_theme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get light_theme;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @loading_cart.
  ///
  /// In en, this message translates to:
  /// **'Loading Cart...'**
  String get loading_cart;

  /// No description provided for @location_permission_required.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required'**
  String get location_permission_required;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @login_logout.
  ///
  /// In en, this message translates to:
  /// **'Log In / Log Out'**
  String get login_logout;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @manage_notifications.
  ///
  /// In en, this message translates to:
  /// **'Manage Notifications'**
  String get manage_notifications;

  /// No description provided for @manual_payment.
  ///
  /// In en, this message translates to:
  /// **'Manual Payment'**
  String get manual_payment;

  /// No description provided for @manual_payment_instructions.
  ///
  /// In en, this message translates to:
  /// **'Please transfer the amount to the bank account below and attach the receipt'**
  String get manual_payment_instructions;

  /// No description provided for @mark_all_as_read.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get mark_all_as_read;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @message_sent.
  ///
  /// In en, this message translates to:
  /// **'Message Sent'**
  String get message_sent;

  /// No description provided for @message_sent_desc.
  ///
  /// In en, this message translates to:
  /// **'Thank you for contacting us. We will get back to you soon.'**
  String get message_sent_desc;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get month;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @must_not_start_with_space.
  ///
  /// In en, this message translates to:
  /// **'Must not start with a space'**
  String get must_not_start_with_space;

  /// No description provided for @my_assessment.
  ///
  /// In en, this message translates to:
  /// **'My Assessment'**
  String get my_assessment;

  /// No description provided for @my_courses.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get my_courses;

  /// No description provided for @my_current_courses.
  ///
  /// In en, this message translates to:
  /// **'My Current Courses'**
  String get my_current_courses;

  /// No description provided for @new_account.
  ///
  /// In en, this message translates to:
  /// **'New account'**
  String get new_account;

  /// No description provided for @new_email.
  ///
  /// In en, this message translates to:
  /// **'New Email'**
  String get new_email;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @new_value.
  ///
  /// In en, this message translates to:
  /// **'New Value'**
  String get new_value;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @no_courses_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse available courses and enroll to start learning'**
  String get no_courses_subtitle;

  /// No description provided for @no_courses_title.
  ///
  /// In en, this message translates to:
  /// **'No Courses Yet'**
  String get no_courses_title;

  /// No description provided for @no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get no_internet_connection;

  /// No description provided for @no_internet_connection_bar.
  ///
  /// In en, this message translates to:
  /// **'Please check your network connection'**
  String get no_internet_connection_bar;

  /// No description provided for @no_notifications.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get no_notifications;

  /// No description provided for @no_notifications_message.
  ///
  /// In en, this message translates to:
  /// **'You have no notifications at the moment'**
  String get no_notifications_message;

  /// No description provided for @no_notifications_message_tablet.
  ///
  /// In en, this message translates to:
  /// **'You have no notifications at the moment'**
  String get no_notifications_message_tablet;

  /// No description provided for @no_notifications_tablet.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get no_notifications_tablet;

  /// No description provided for @no_results.
  ///
  /// In en, this message translates to:
  /// **'No Results'**
  String get no_results;

  /// No description provided for @no_results_desc.
  ///
  /// In en, this message translates to:
  /// **'No matching results found for your search'**
  String get no_results_desc;

  /// No description provided for @no_results_found.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get no_results_found;

  /// No description provided for @no_sessions_for_this_day.
  ///
  /// In en, this message translates to:
  /// **'No sessions scheduled for this day'**
  String get no_sessions_for_this_day;

  /// No description provided for @no_sessions_scheduled_yet.
  ///
  /// In en, this message translates to:
  /// **'No sessions scheduled yet'**
  String get no_sessions_scheduled_yet;

  /// No description provided for @no_unread_notifications.
  ///
  /// In en, this message translates to:
  /// **'No unread notifications'**
  String get no_unread_notifications;

  /// No description provided for @not_available.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get not_available;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @note_mewwage.
  ///
  /// In en, this message translates to:
  /// **'Write your note here...'**
  String get note_mewwage;

  /// No description provided for @note_option.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get note_option;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @notification_details.
  ///
  /// In en, this message translates to:
  /// **'Notification Details'**
  String get notification_details;

  /// No description provided for @notifications_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay updated with your latest alerts'**
  String get notifications_subtitle;

  /// No description provided for @notifications_title.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications_title;

  /// No description provided for @notifications_title_tablet.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications_title_tablet;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @number_of_items.
  ///
  /// In en, this message translates to:
  /// **'Number of items'**
  String get number_of_items;

  /// No description provided for @number_of_sessions.
  ///
  /// In en, this message translates to:
  /// **'Number of Sessions'**
  String get number_of_sessions;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @open_location.
  ///
  /// In en, this message translates to:
  /// **'Open Location'**
  String get open_location;

  /// No description provided for @or_contact_via.
  ///
  /// In en, this message translates to:
  /// **'Or contact via'**
  String get or_contact_via;

  /// No description provided for @or_continue_with.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get or_continue_with;

  /// No description provided for @order_history.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get order_history;

  /// No description provided for @order_summary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get order_summary;

  /// No description provided for @otp_resent_successfully.
  ///
  /// In en, this message translates to:
  /// **'OTP resent successfully'**
  String get otp_resent_successfully;

  /// No description provided for @otp_sent_to.
  ///
  /// In en, this message translates to:
  /// **'Code sent to'**
  String get otp_sent_to;

  /// No description provided for @otp_sent_to_invitation.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to'**
  String get otp_sent_to_invitation;

  /// No description provided for @otp_verification_description.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 4-digit code sent to your phone/email'**
  String get otp_verification_description;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @packages.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get packages;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @password_changed_successfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get password_changed_successfully;

  /// No description provided for @password_same_as_old.
  ///
  /// In en, this message translates to:
  /// **'New password cannot be the same as old password'**
  String get password_same_as_old;

  /// No description provided for @password_validation.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get password_validation;

  /// No description provided for @password_validation_capital.
  ///
  /// In en, this message translates to:
  /// **'At least one uppercase letter'**
  String get password_validation_capital;

  /// No description provided for @password_validation_size.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get password_validation_size;

  /// No description provided for @password_validation_small.
  ///
  /// In en, this message translates to:
  /// **'At least one lowercase letter'**
  String get password_validation_small;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_do_not_match;

  /// No description provided for @pay_now.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get pay_now;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @payment_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Payment Confirmation'**
  String get payment_confirmation;

  /// No description provided for @payment_failed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get payment_failed;

  /// No description provided for @payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get payment_method;

  /// No description provided for @pending_course_grace_period_deadline_prefix.
  ///
  /// In en, this message translates to:
  /// **'Grace period ends on: '**
  String get pending_course_grace_period_deadline_prefix;

  /// No description provided for @pending_course_grace_period_desc.
  ///
  /// In en, this message translates to:
  /// **'Your course is in the grace period. Please renew soon to avoid interruption.'**
  String get pending_course_grace_period_desc;

  /// No description provided for @pending_course_nearing_completion_deadline_prefix.
  ///
  /// In en, this message translates to:
  /// **'Expires on: '**
  String get pending_course_nearing_completion_deadline_prefix;

  /// No description provided for @pending_course_nearing_completion_desc.
  ///
  /// In en, this message translates to:
  /// **'This course is nearing completion. Renew now to continue learning without interruption.'**
  String get pending_course_nearing_completion_desc;

  /// No description provided for @pending_course_renew_now.
  ///
  /// In en, this message translates to:
  /// **'Renew Now'**
  String get pending_course_renew_now;

  /// No description provided for @pending_course_renewal_required.
  ///
  /// In en, this message translates to:
  /// **'Renewal Required'**
  String get pending_course_renewal_required;

  /// No description provided for @pending_course_renewal_window_closed.
  ///
  /// In en, this message translates to:
  /// **'Renewal window has closed'**
  String get pending_course_renewal_window_closed;

  /// No description provided for @pending_course_view_details.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get pending_course_view_details;

  /// No description provided for @pending_courses_subtitle_plural.
  ///
  /// In en, this message translates to:
  /// **'You have {count} courses waiting for renewal'**
  String pending_courses_subtitle_plural(int count);

  /// No description provided for @pending_courses_subtitle_single.
  ///
  /// In en, this message translates to:
  /// **'You have 1 course waiting for renewal'**
  String get pending_courses_subtitle_single;

  /// No description provided for @pending_courses_title.
  ///
  /// In en, this message translates to:
  /// **'Pending Course Renewals'**
  String get pending_courses_title;

  /// No description provided for @permanent_deletion_warning.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent and cannot be undone.'**
  String get permanent_deletion_warning;

  /// No description provided for @personal_information.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personal_information;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @platform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platform;

  /// No description provided for @please_check_your_inputs.
  ///
  /// In en, this message translates to:
  /// **'Please check your inputs'**
  String get please_check_your_inputs;

  /// No description provided for @please_close_payment_process_complete.
  ///
  /// In en, this message translates to:
  /// **'Please complete or cancel the current payment first'**
  String get please_close_payment_process_complete;

  /// No description provided for @please_enter_address.
  ///
  /// In en, this message translates to:
  /// **'Please enter your address'**
  String get please_enter_address;

  /// No description provided for @please_enter_complete_otp.
  ///
  /// In en, this message translates to:
  /// **'Please enter complete OTP'**
  String get please_enter_complete_otp;

  /// No description provided for @please_enter_your_current_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password'**
  String get please_enter_your_current_password;

  /// No description provided for @please_enter_your_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get please_enter_your_phone_number;

  /// No description provided for @please_fill_all_required_fields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get please_fill_all_required_fields;

  /// No description provided for @please_select.
  ///
  /// In en, this message translates to:
  /// **'Please select'**
  String get please_select;

  /// No description provided for @please_select_country_first.
  ///
  /// In en, this message translates to:
  /// **'Please select a country first'**
  String get please_select_country_first;

  /// No description provided for @please_select_your_country.
  ///
  /// In en, this message translates to:
  /// **'Please select your country'**
  String get please_select_your_country;

  /// No description provided for @price_updated.
  ///
  /// In en, this message translates to:
  /// **'Price updated'**
  String get price_updated;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @privacy_policy_and_terms.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy and Terms'**
  String get privacy_policy_and_terms;

  /// No description provided for @profile_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profile_edit;

  /// No description provided for @profile_settings.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profile_settings;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @protect_your_account.
  ///
  /// In en, this message translates to:
  /// **'Protect Your Account'**
  String get protect_your_account;

  /// No description provided for @push_notifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get push_notifications;

  /// No description provided for @quran_courses.
  ///
  /// In en, this message translates to:
  /// **'Quran Courses'**
  String get quran_courses;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @registration_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Registration was cancelled'**
  String get registration_cancelled;

  /// No description provided for @registration_data.
  ///
  /// In en, this message translates to:
  /// **'Registration Data'**
  String get registration_data;

  /// No description provided for @renew_all_courses.
  ///
  /// In en, this message translates to:
  /// **'Renew all ({count})'**
  String renew_all_courses(int count);

  /// No description provided for @renew_your_package_now.
  ///
  /// In en, this message translates to:
  /// **'Renew your package now'**
  String get renew_your_package_now;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @resend_code.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resend_code;

  /// No description provided for @review_order_details.
  ///
  /// In en, this message translates to:
  /// **'Review Order Details'**
  String get review_order_details;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @save_edit.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_edit;

  /// No description provided for @save_password.
  ///
  /// In en, this message translates to:
  /// **'Save Password'**
  String get save_password;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @search_by_name_or_address.
  ///
  /// In en, this message translates to:
  /// **'Search by name or address'**
  String get search_by_name_or_address;

  /// No description provided for @second.
  ///
  /// In en, this message translates to:
  /// **'second'**
  String get second;

  /// No description provided for @security_notes.
  ///
  /// In en, this message translates to:
  /// **'Security Notes'**
  String get security_notes;

  /// No description provided for @security_notes_description.
  ///
  /// In en, this message translates to:
  /// **'Keep your login credentials safe and do not share them'**
  String get security_notes_description;

  /// No description provided for @security_privacy.
  ///
  /// In en, this message translates to:
  /// **'Security & Privacy'**
  String get security_privacy;

  /// No description provided for @see_all.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get see_all;

  /// No description provided for @select_birth_date.
  ///
  /// In en, this message translates to:
  /// **'Select Date of Birth'**
  String get select_birth_date;

  /// No description provided for @select_country.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get select_country;

  /// No description provided for @select_gender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get select_gender;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @select_notification_to_view_details.
  ///
  /// In en, this message translates to:
  /// **'Select a notification to view details'**
  String get select_notification_to_view_details;

  /// No description provided for @select_your_country.
  ///
  /// In en, this message translates to:
  /// **'Select Your Country'**
  String get select_your_country;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @selected_country.
  ///
  /// In en, this message translates to:
  /// **'Selected Country'**
  String get selected_country;

  /// No description provided for @send_code.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get send_code;

  /// No description provided for @send_message.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get send_message;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @sh_cart_desc.
  ///
  /// In en, this message translates to:
  /// **'View your selected items and complete purchases'**
  String get sh_cart_desc;

  /// No description provided for @sh_courses_desc.
  ///
  /// In en, this message translates to:
  /// **'Browse and access all your enrolled courses'**
  String get sh_courses_desc;

  /// No description provided for @sh_dash_banner_desc.
  ///
  /// In en, this message translates to:
  /// **'View important updates and announcements'**
  String get sh_dash_banner_desc;

  /// No description provided for @sh_dash_banner_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome Banner'**
  String get sh_dash_banner_title;

  /// No description provided for @sh_dash_courses_desc.
  ///
  /// In en, this message translates to:
  /// **'Easily access and resume your active courses'**
  String get sh_dash_courses_desc;

  /// No description provided for @sh_dash_courses_title.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get sh_dash_courses_title;

  /// No description provided for @sh_dash_stats_desc.
  ///
  /// In en, this message translates to:
  /// **'Track your progress and learning achievements'**
  String get sh_dash_stats_desc;

  /// No description provided for @sh_dash_stats_title.
  ///
  /// In en, this message translates to:
  /// **'Your Statistics'**
  String get sh_dash_stats_title;

  /// No description provided for @sh_dash_suggested_desc.
  ///
  /// In en, this message translates to:
  /// **'Discover new courses recommended for you'**
  String get sh_dash_suggested_desc;

  /// No description provided for @sh_dash_suggested_title.
  ///
  /// In en, this message translates to:
  /// **'Suggested Courses'**
  String get sh_dash_suggested_title;

  /// No description provided for @sh_dash_upcoming_desc.
  ///
  /// In en, this message translates to:
  /// **'Stay updated on your next scheduled classes'**
  String get sh_dash_upcoming_desc;

  /// No description provided for @sh_dash_upcoming_title.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Sessions'**
  String get sh_dash_upcoming_title;

  /// No description provided for @sh_hide.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show again'**
  String get sh_hide;

  /// No description provided for @sh_home_desc.
  ///
  /// In en, this message translates to:
  /// **'Quick access to your home dashboard'**
  String get sh_home_desc;

  /// No description provided for @sh_more_desc.
  ///
  /// In en, this message translates to:
  /// **'Access settings, profile, and help'**
  String get sh_more_desc;

  /// No description provided for @sh_more_title.
  ///
  /// In en, this message translates to:
  /// **'More Options'**
  String get sh_more_title;

  /// No description provided for @sh_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get sh_next;

  /// No description provided for @sh_parent_desc.
  ///
  /// In en, this message translates to:
  /// **'Choose parent account to follow up on your children\'s progress'**
  String get sh_parent_desc;

  /// No description provided for @sh_parent_title.
  ///
  /// In en, this message translates to:
  /// **'Parent Account'**
  String get sh_parent_title;

  /// No description provided for @sh_prev.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get sh_prev;

  /// No description provided for @sh_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get sh_skip;

  /// No description provided for @sh_student_desc.
  ///
  /// In en, this message translates to:
  /// **'Choose student account to access your courses and lessons'**
  String get sh_student_desc;

  /// No description provided for @sh_student_title.
  ///
  /// In en, this message translates to:
  /// **'Student Account'**
  String get sh_student_title;

  /// No description provided for @shopping_cart.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get shopping_cart;

  /// No description provided for @since.
  ///
  /// In en, this message translates to:
  /// **'Since'**
  String get since;

  /// No description provided for @social_account_not_registered.
  ///
  /// In en, this message translates to:
  /// **'Sorry, this account isn\'t registered yet.\n\nEmail: {email}\n\nWould you like to complete your details to create a new account?'**
  String social_account_not_registered(String email);

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get something_went_wrong;

  /// No description provided for @status_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get status_completed;

  /// No description provided for @stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @student_account.
  ///
  /// In en, this message translates to:
  /// **'Student Account'**
  String get student_account;

  /// No description provided for @student_account_text.
  ///
  /// In en, this message translates to:
  /// **'For students to attend classes and view courses'**
  String get student_account_text;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @suggested_courses.
  ///
  /// In en, this message translates to:
  /// **'Suggested Courses'**
  String get suggested_courses;

  /// No description provided for @system_details.
  ///
  /// In en, this message translates to:
  /// **'System Details'**
  String get system_details;

  /// No description provided for @teacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get teacher;

  /// No description provided for @technical.
  ///
  /// In en, this message translates to:
  /// **'Technical'**
  String get technical;

  /// No description provided for @theme_mode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get theme_mode;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @to_monitor_children.
  ///
  /// In en, this message translates to:
  /// **'To monitor children\'s progress'**
  String get to_monitor_children;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @total_lecture.
  ///
  /// In en, this message translates to:
  /// **'Total Lectures'**
  String get total_lecture;

  /// No description provided for @total_payment_amount.
  ///
  /// In en, this message translates to:
  /// **'Total Payment Amount'**
  String get total_payment_amount;

  /// No description provided for @total_price.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get total_price;

  /// No description provided for @track_children.
  ///
  /// In en, this message translates to:
  /// **'Track Children'**
  String get track_children;

  /// No description provided for @unexpected_error.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error occurred'**
  String get unexpected_error;

  /// No description provided for @unread_notifications.
  ///
  /// In en, this message translates to:
  /// **'Unread ({count})'**
  String unread_notifications(Object count);

  /// No description provided for @up_to_date.
  ///
  /// In en, this message translates to:
  /// **'Up to date'**
  String get up_to_date;

  /// No description provided for @upcoming_sessions.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Sessions'**
  String get upcoming_sessions;

  /// No description provided for @update_now.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get update_now;

  /// No description provided for @upload_image.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get upload_image;

  /// No description provided for @upload_pdf.
  ///
  /// In en, this message translates to:
  /// **'Upload PDF'**
  String get upload_pdf;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @user_name.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get user_name;

  /// No description provided for @user_name_validation.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get user_name_validation;

  /// No description provided for @user_name_validation_capital.
  ///
  /// In en, this message translates to:
  /// **'Must contain uppercase letters'**
  String get user_name_validation_capital;

  /// No description provided for @user_name_validation_size.
  ///
  /// In en, this message translates to:
  /// **'Username must be between 3 and 20 characters'**
  String get user_name_validation_size;

  /// No description provided for @user_name_validation_small.
  ///
  /// In en, this message translates to:
  /// **'Must contain lowercase letters'**
  String get user_name_validation_small;

  /// No description provided for @user_name_validation_space.
  ///
  /// In en, this message translates to:
  /// **'Username cannot contain spaces'**
  String get user_name_validation_space;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @verify_otp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verify_otp;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @view_all.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get view_all;

  /// No description provided for @view_assignment.
  ///
  /// In en, this message translates to:
  /// **'View Assignment'**
  String get view_assignment;

  /// No description provided for @view_course.
  ///
  /// In en, this message translates to:
  /// **'View Course'**
  String get view_course;

  /// No description provided for @view_details.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get view_details;

  /// No description provided for @view_family.
  ///
  /// In en, this message translates to:
  /// **'View Family'**
  String get view_family;

  /// No description provided for @view_feedback.
  ///
  /// In en, this message translates to:
  /// **'View Feedback'**
  String get view_feedback;

  /// No description provided for @view_order_details.
  ///
  /// In en, this message translates to:
  /// **'View Order Details'**
  String get view_order_details;

  /// No description provided for @view_security_details.
  ///
  /// In en, this message translates to:
  /// **'View Security Details'**
  String get view_security_details;

  /// No description provided for @web_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Web Dashboard'**
  String get web_dashboard;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcome_to_k.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Konoz'**
  String get welcome_to_k;

  /// No description provided for @welcome_to_konoz.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Konoz'**
  String get welcome_to_konoz;

  /// No description provided for @welcome_to_lavelle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Lavelle'**
  String get welcome_to_lavelle;

  /// No description provided for @what_are_you_looking_for.
  ///
  /// In en, this message translates to:
  /// **'What are you looking for?'**
  String get what_are_you_looking_for;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @with_to.
  ///
  /// In en, this message translates to:
  /// **'With'**
  String get with_to;

  /// No description provided for @working_hours.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get working_hours;

  /// No description provided for @working_hours_time.
  ///
  /// In en, this message translates to:
  /// **'Sunday - Thursday: 9:00 AM - 6:00 PM'**
  String get working_hours_time;

  /// No description provided for @writeYourMessageHere.
  ///
  /// In en, this message translates to:
  /// **'Write your message here'**
  String get writeYourMessageHere;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get year;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @you_can_now_log_in_with_your_new_password.
  ///
  /// In en, this message translates to:
  /// **'You can now log in with your new password'**
  String get you_can_now_log_in_with_your_new_password;

  /// No description provided for @you_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get you_have_account;

  /// No description provided for @your_email.
  ///
  /// In en, this message translates to:
  /// **'Your Email'**
  String get your_email;

  /// No description provided for @your_name.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get your_name;

  /// No description provided for @your_phone.
  ///
  /// In en, this message translates to:
  /// **'Your Phone'**
  String get your_phone;

  /// No description provided for @your_progress_month.
  ///
  /// In en, this message translates to:
  /// **'Your progress this month'**
  String get your_progress_month;

  /// No description provided for @your_rights.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get your_rights;

  /// No description provided for @your_rights_text.
  ///
  /// In en, this message translates to:
  /// **'You have the right to access, update, or request deletion of your personal data at any time.'**
  String get your_rights_text;

  /// No description provided for @splash_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get splash_loading;

  /// No description provided for @splash_checking_app.
  ///
  /// In en, this message translates to:
  /// **'Checking the app...'**
  String get splash_checking_app;

  /// No description provided for @splash_preparing.
  ///
  /// In en, this message translates to:
  /// **'Getting Lavelle ready...'**
  String get splash_preparing;

  /// No description provided for @splash_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Lavelle'**
  String get splash_welcome;

  /// No description provided for @register_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account and enjoy premium laundry care at your doorstep'**
  String get register_subtitle;

  /// No description provided for @delivery_address.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get delivery_address;

  /// No description provided for @select_area.
  ///
  /// In en, this message translates to:
  /// **'Select Area'**
  String get select_area;

  /// No description provided for @address_preview.
  ///
  /// In en, this message translates to:
  /// **'Address Preview'**
  String get address_preview;

  /// No description provided for @area_madinaty.
  ///
  /// In en, this message translates to:
  /// **'Madinaty'**
  String get area_madinaty;

  /// No description provided for @area_shorouk.
  ///
  /// In en, this message translates to:
  /// **'El Shorouk'**
  String get area_shorouk;

  /// No description provided for @area_other.
  ///
  /// In en, this message translates to:
  /// **'Other Area'**
  String get area_other;

  /// No description provided for @group_number.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group_number;

  /// No description provided for @building_number.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get building_number;

  /// No description provided for @apartment_number.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get apartment_number;

  /// No description provided for @district_number.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district_number;

  /// No description provided for @neighborhood_number.
  ///
  /// In en, this message translates to:
  /// **'Neighborhood'**
  String get neighborhood_number;

  /// No description provided for @area_name.
  ///
  /// In en, this message translates to:
  /// **'Area Name'**
  String get area_name;

  /// No description provided for @address_details.
  ///
  /// In en, this message translates to:
  /// **'Address Details (Street / Building / Apt)'**
  String get address_details;

  /// No description provided for @please_enter_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get please_enter_name;

  /// No description provided for @error_title.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get error_title;

  /// No description provided for @error_message.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load the data. Please try again.'**
  String get error_message;

  /// No description provided for @no_connection_title.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get no_connection_title;

  /// No description provided for @no_connection_message.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again'**
  String get no_connection_message;

  /// No description provided for @empty_default_title.
  ///
  /// In en, this message translates to:
  /// **'Nothing to show yet'**
  String get empty_default_title;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @nav_my_orders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get nav_my_orders;

  /// No description provided for @nav_offers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get nav_offers;

  /// No description provided for @nav_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get nav_profile;

  /// No description provided for @guest_gate_title.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get guest_gate_title;

  /// No description provided for @guest_gate_message.
  ///
  /// In en, this message translates to:
  /// **'This feature is available for registered accounts only'**
  String get guest_gate_message;

  /// No description provided for @not_now.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get not_now;

  /// No description provided for @deliver_to.
  ///
  /// In en, this message translates to:
  /// **'Deliver to'**
  String get deliver_to;

  /// No description provided for @select_location.
  ///
  /// In en, this message translates to:
  /// **'Select your location'**
  String get select_location;

  /// No description provided for @search_laundries_hint.
  ///
  /// In en, this message translates to:
  /// **'Search for a laundry'**
  String get search_laundries_hint;

  /// No description provided for @home_services_title.
  ///
  /// In en, this message translates to:
  /// **'What do you need today?'**
  String get home_services_title;

  /// No description provided for @service_washing.
  ///
  /// In en, this message translates to:
  /// **'Washing'**
  String get service_washing;

  /// No description provided for @service_ironing.
  ///
  /// In en, this message translates to:
  /// **'Ironing'**
  String get service_ironing;

  /// No description provided for @service_dry_cleaning.
  ///
  /// In en, this message translates to:
  /// **'Dry cleaning'**
  String get service_dry_cleaning;

  /// No description provided for @service_carpet.
  ///
  /// In en, this message translates to:
  /// **'Carpets'**
  String get service_carpet;

  /// No description provided for @nearby_laundries.
  ///
  /// In en, this message translates to:
  /// **'Laundries near you'**
  String get nearby_laundries;

  /// No description provided for @map_view.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map_view;

  /// No description provided for @status_open.
  ///
  /// In en, this message translates to:
  /// **'Open now'**
  String get status_open;

  /// No description provided for @status_closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get status_closed;

  /// No description provided for @status_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Temporarily unavailable'**
  String get status_unavailable;

  /// No description provided for @unit_km.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get unit_km;

  /// No description provided for @starting_from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get starting_from;

  /// No description provided for @currency_egp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get currency_egp;

  /// No description provided for @promo_platform.
  ///
  /// In en, this message translates to:
  /// **'Lavelle offer'**
  String get promo_platform;

  /// No description provided for @location_prompt_title.
  ///
  /// In en, this message translates to:
  /// **'Turn on location to see nearby laundries'**
  String get location_prompt_title;

  /// No description provided for @location_prompt_message.
  ///
  /// In en, this message translates to:
  /// **'We only use your location to find laundries serving your area'**
  String get location_prompt_message;

  /// No description provided for @no_laundries_nearby.
  ///
  /// In en, this message translates to:
  /// **'No laundries nearby right now'**
  String get no_laundries_nearby;

  /// No description provided for @no_laundries_nearby_message.
  ///
  /// In en, this message translates to:
  /// **'Try changing your location or check back later'**
  String get no_laundries_nearby_message;

  /// No description provided for @no_laundries_for_service.
  ///
  /// In en, this message translates to:
  /// **'No nearby laundries offer this service'**
  String get no_laundries_for_service;

  /// No description provided for @clear_filter.
  ///
  /// In en, this message translates to:
  /// **'Clear filter'**
  String get clear_filter;

  /// No description provided for @current_location.
  ///
  /// In en, this message translates to:
  /// **'Current location'**
  String get current_location;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

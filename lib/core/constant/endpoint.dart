import '../../feature/user/domain/enums/admin_setting.dart';

class ApiConfig {
  static String baseUrl = 'https://api.tiba-academy.com/api';
}

abstract class ApiEndPoint {
  static const isRelease = true;

  static String get baseUrl => ApiConfig.baseUrl;

  // region Auth Endpoints
  static String get sendOtpToResetPassword => '$baseUrl/Auth/resend-Otp';

  static String get register => '$baseUrl/Auth/student-parent-register';

  static String get addChild => '$baseUrl/Parent/child-register';

  static String get resetPasswordByOtp => '$baseUrl/Auth/reset-password';

  static String get confirmOtpToResetPassword =>
      '$baseUrl/Auth/confirm-reset-password';

  static String get login => '$baseUrl/Auth/login';

  static String get logout => '$baseUrl/User/Logout';

  static String get loginWithSocialMedia => '$baseUrl/Auth/external/login';

  static String get registerWithSocialMedia =>
      '$baseUrl/Auth/external/register';

  static String get resendOtp => '$baseUrl/Auth/resend-Otp';

  static String impersonate(String token) =>
      '$baseUrl/Auth/impersonate?token=$token';

  // region User Endpoints
  static String get addFcmToken => '$baseUrl/DeviceToken/Register-DeviceToken';

  static String get delete => '$baseUrl/User/Delete-Account';

  static String userById(String? childId) {
    String url = '$baseUrl/User/View-UserProfile';

    if (childId != null && childId != "") {
      return '$url?ChildId=$childId';
    }
    return url;
  }

  static String courseUpgradeOptions(num sspId) =>
      '$baseUrl/Student/Course-Upgrade-Options?SSPId=$sspId';

  static String get verifyAccount => '$baseUrl/Auth/confirm-user';

  static String get changeEmail => '$baseUrl/User/change-email';

  static String get confirmChangeEmail => '$baseUrl/User/confirm-email-change';

  static String get changePassword => '$baseUrl/User/change-password';

  static String get updateProfile => '$baseUrl/User/update-personal-info';

  static String get updatePreference => '$baseUrl/User/update-preferences';

  static String getPreference(String? childId) {
    String url = '$baseUrl/User/Preferences-Definition';

    if (childId != null && childId.isNotEmpty) {
      return '$url?ChildId=$childId';
    }
    return url;
  }

  // region Notification Endpoints
  static String get toggleNotification => '$baseUrl/User/Toggle-Notification';

  static String get myNotifications =>
      '$baseUrl/Notification/Get-MyNotifications';

  static String get notificationsCount =>
      '$baseUrl/Notification/Get-Unread-Count';

  static String get readNotifications => '$baseUrl/Notification/Mark-AsRead';

  static String get readAllNotifications =>
      '$baseUrl/Notification/Mark-All-AsRead';

  static String get deleteNotifications =>
      '$baseUrl/Notification/Delete-Notification';

  static String get clearAllNotifications => '$baseUrl/Notification/Clear-All';

  // region Profile Endpoints
  static String get updateUser => '$baseUrl/User/UpdateUserAccount';

  static String get updateBusiness => '$baseUrl/User/UpdateBusinessAccount';

  // region Package Endpoints
  static String getPackages({
    num? subjectId,
    num? countryId,
    String? studentId,
  }) {
    final queryParams = <String>[];
    if (countryId != null && countryId != 0) {
      queryParams.add('CountryId=$countryId');
    }
    if (subjectId != null && subjectId != 0) {
      queryParams.add('SubjectId=$subjectId');
    }
    if (studentId != null && studentId.trim().isNotEmpty) {
      queryParams.add('StudentId=${studentId.trim()}');
    }

    final query = queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
    return '$baseUrl/Redirect/Get-Plans$query';
  }

  static String getGroup(num countryId, String studentId) =>
      '$baseUrl/Visitor/Get-Subjects-With-Plans-ByCountry?CountryId=$countryId&StudentId=$studentId';

  static String get subscriptionPlans =>
      '$baseUrl/StudentSubscriptionPlan/addSubscriptionPlans-To-Student';

  static String get createAssessment =>
      '$baseUrl/Request/Create-Assessment-Request';

  // region Banner Endpoints
  static String get banners => '$baseUrl/Banner/GetBanners';

  // region Notification Endpoints
  static String get allowNotification =>
      '$baseUrl/User/UpdateAllowNotification';

  static String get markNotificationAsRead =>
      '$baseUrl/Notifications/MakeAsRead';

  static String get notifications =>
      '$baseUrl/Notification/Get-MyNotifications';

  static String get contactUs => '$baseUrl/ContactUs/Create';

  // region Privacy Endpoints
  static String get privacy => '$baseUrl/Privacy/GetPrivacy';

  static String get faq => '$baseUrl/Privacy/GetPrivacy';

  //region Country Endpoints
  static String get getCountry => '$baseUrl/Auth/register-definition';

  // region Parent Endpoint
  static String get inviteChild => '$baseUrl/Parent/invite-Child';

  static String get confirmInvite => '$baseUrl/Parent/confirm-Invite-Child';

  static String getChildren([String? studentId]) {
    if (studentId != null && studentId.isNotEmpty) {
      return '$baseUrl/Parent/get-Children-for-Parent?childId=$studentId';
    }
    return '$baseUrl/Parent/get-Children-for-Parent';
  }

  // region Student Endpoint
  static String getStudentSubject(String studentId) =>
      '$baseUrl/Student/get-StudentSubjects-With-Plans?studentId=$studentId';

  static String myCoursesDetail(String studentId, num sspId) =>
      '$baseUrl/Student/Get-My-Course-Details?StudentId=$studentId&SSPId=$sspId';

  static String myCourses(String studentId) =>
      '$baseUrl/Student/Get-My-Courses?ChildId=$studentId';

  static String get subscription =>
      '$baseUrl/StudentSubscriptionPlan/addSubscriptionPlans-To-Student';

  static String myAssessment(String studentId) =>
      '$baseUrl/Assessment/Get-My-Assessments?StudentId=$studentId';

  static String dashboard(String? childId) {
    String url = '$baseUrl/Student/Get-My-Dashboard';

    if (childId != null && childId.isNotEmpty) {
      return '$url?childId=$childId';
    }
    return url;
  }

  static String get makeChildAdult => '$baseUrl/Parent/Make-Child-Adult';

  static String get startSession => '$baseUrl/Student/Join-Meeting';

  // region CartEndPoints
  static String getCartId(String? childId) {
    String url = '$baseUrl/Order/Get-CartId';

    if (childId != null && childId != '') {
      return '$url?StudentId=$childId';
    }
    return url;
  }

  static String getCartList(num cartId) =>
      '$baseUrl/Order/Get-Cart-Items?CartId=$cartId';

  static String get deleteCart => '$baseUrl/Order/Delete-Cart-Items';

  static String get addToCart => '$baseUrl/Order/Add-To-Cart';

  static String get createOrder => '$baseUrl/Order/Create-Order';

  static String get paymentMethods => '$baseUrl/Order/Payment-Definition';

  static String get executePayment =>
      '$baseUrl/Payment/Stripe-Checkout-Session';

  static String get createSchedule =>
      '$baseUrl/Request/Create-PlanSchedule-Request';

  static String get reschedule => '$baseUrl/Student/Re-Scheduling-Course';

  // region Order Endpoints
  static String myOrders(String childId) =>
      '$baseUrl/Order/Get-My-Orders?StudentId=$childId';

  static String orderDetails(num orderId) =>
      '$baseUrl/Order/Get-Order-Details?OrderId=$orderId';

  static String get cancelSession => '$baseUrl/Request/Cancel-Request';

  static String get holdCourse => '$baseUrl/Request/Hold-Course-Request';

  static String appSettings(AdminSettingsEnum adminSettingsEnum) =>
      '$baseUrl/AdminSettings/Get-Admin-Settings?AdminSettingType=${adminSettingsEnum.id}';

  static String get manualPayment => '$baseUrl/Order/Upload-Receipt';
  static String get deferredPayment => '$baseUrl/Payment/Deferred-Payment';

  static String get renewCourseSubscription => '$baseUrl/Order/Repurchase-Plan';

  static String get appStatus => '$baseUrl/Settings/AppStatus';
}

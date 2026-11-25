import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../feature/auth/presentation/login/view/login.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets/main_button.dart';
import '../../shared/widgets/main_text.dart';
import '../enums/enums.dart';
import '../extension/extension_helper.dart';
import '../style/app_colors.dart';

String getGreeting(BuildContext context) {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return context.l10n.good_morning;
  } else if (hour < 17) {
    return context.l10n.good_night;
  } else {
    return context.l10n.good_evening;
  }
}

String getGreetingTablet(BuildContext context) {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return context.l10n.good_morning_tablet;
  } else if (hour < 17) {
    return context.l10n.good_night_tablet;
  } else {
    return context.l10n.good_evening_tablet;
  }
}

Future<void> showToast({
  required String msg,
  required ToastedStates state,
  ToastGravity gravity = ToastGravity.TOP,
  Toast toastLength = Toast.LENGTH_SHORT,
  Color? customColor,
}) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: msg,
    toastLength: toastLength,
    gravity: gravity,
    timeInSecForIosWeb: 5,
    backgroundColor: customColor ?? chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Color chooseToastColor(ToastedStates states) {
  Color color;
  switch (states) {
    case ToastedStates.success:
      color = Colors.green;
      break;
    case ToastedStates.error:
      color = Colors.red;
      break;
    case ToastedStates.warning:
      color = Colors.amber;
      break;
  }
  return color;
}

Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  String? cancelActionText,
  required String defaultActionText,
  bool isDestructive = false,
  String? routeName,
}) {
  if (kIsWeb ||
      defaultTargetPlatform != TargetPlatform.iOS &&
          defaultTargetPlatform != TargetPlatform.macOS) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      routeSettings: RouteSettings(name: routeName),
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (cancelActionText != null)
            TextButton(
              child: Text(cancelActionText),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          TextButton(
            child: Text(defaultActionText),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
  return showCupertinoDialog(
    context: context,
    routeSettings: RouteSettings(name: routeName),
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        if (cancelActionText != null)
          CupertinoDialogAction(
            child: Text(cancelActionText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        CupertinoDialogAction(
          isDestructiveAction: isDestructive,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(defaultActionText),
        ),
      ],
    ),
  );
}

void showExitDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: MainText(context.l10n.note),
      content: MainText(context.l10n.are_you_sure_you_want_exit),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: MainText(context.l10n.stay),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context).pushReplacementNamed(LoginView.routeName);
          },
          child: MainText(context.l10n.exit),
        ),
      ],
    ),
  );
}

String formatTimeDifference(DateTime postCreatedAt, BuildContext context) {
  final postDate = postCreatedAt;
  final difference = DateTime.now().difference(postDate);

  final days = difference.inDays;
  final hours = difference.inHours % 24;
  final minutes = difference.inMinutes % 60;
  final months = difference.inDays ~/ 30;
  final years = difference.inDays ~/ 365;

  var formattedString = '${context.l10n.since} ';

  if (years > 0) {
    formattedString += '$years ${context.l10n.year}';
  } else if (months > 0) {
    formattedString += '$months ${context.l10n.month}';
  } else if (days > 0) {
    formattedString += '$days ${context.l10n.day}';
  } else if (hours > 0 && days == 0) {
    formattedString += '$hours ${context.l10n.hour}';
  } else if (days == 0 && hours == 0 && minutes > 0) {
    formattedString += '$minutes ${context.l10n.minute}';
  } else {
    formattedString = context.l10n.now;
  }

  return formattedString;
}

// class ImageBottomSheet extends StatelessWidget {
//   ImageBottomSheet({super.key, this.imageFile});
//
//   File? imageFile;
//
//   static Future<File?> show(BuildContext context) {
//     return showModalBottomSheet<File>(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => ImageBottomSheet(),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//       decoration: BoxDecoration(
//         color: context.isDark ? AppColors.darkItemBG2 : AppColors.white,
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           16.ph,
//           Container(
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           16.ph,
//           MainText(
//             context.l10n.choose_photo,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//           20.ph,
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextButton.icon(
//                     icon: const Icon(
//                       Icons.camera,
//                     ),
//                     onPressed: () {
//                       _getImage(context, ImageSource.camera);
//                     },
//                     label: MainText(context.l10n.camera),
//                   ),
//                 ),
//                 Expanded(
//                   child: TextButton.icon(
//                     icon: const Icon(
//                       Icons.image,
//                     ),
//                     onPressed: () {
//                       _getImage(context, ImageSource.gallery);
//                     },
//                     label: MainText(context.l10n.gallery),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           16.ph,
//         ],
//       ),
//     );
//   }
//
//   Future<void> _getImage(context, ImageSource source) async {
//     try {
//       // اختيار الصورة
//       final pickedFile = await ImagePicker().pickImage(source: source);
//
//       if (pickedFile != null) {
//         // اقتصاص الصورة
//         final croppedFile = await _cropImage(context, pickedFile.path);
//
//         if (croppedFile != null) {
//           // تحويل الملف المقتصص إلى File
//           imageFile = File(croppedFile.path);
//           // إغلاق الـ bottom sheet وإرجاع الصورة المقتصة
//           Navigator.pop(context, imageFile);
//         }
//       }
//     } catch (e) {
//       print("Error picking/cropping image: $e");
//     }
//   }
//
//   // دالة اقتصاص الصورة
//   // Future<CroppedFile?> _cropImage(
//   //     BuildContext context, String sourcePath) async {
//   //   return await ImageCropper().cropImage(
//   //     sourcePath: sourcePath,
//   //     aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
//   //     // Default to square
//   //     // aspectRatioPresets: [
//   //     //   CropAspectRatioPreset.square, // دي مربع ثابت
//   //     //   CropAspectRatioPreset.ratio3x2,
//   //     //   CropAspectRatioPreset.original,
//   //     //   CropAspectRatioPreset.ratio4x3,
//   //     //   CropAspectRatioPreset.ratio16x9
//   //     // ],
//   //     uiSettings: [
//   //       AndroidUiSettings(
//   //         toolbarTitle: context.l10n.crop_image,
//   //         toolbarColor: AppColors.primaryColor,
//   //         toolbarWidgetColor: Colors.white,
//   //         initAspectRatio: CropAspectRatioPreset.square,
//   //         lockAspectRatio: false,
//   //         // قفل النسبة للحصول على صورة مربعة
//   //         hideBottomControls: false,
//   //         statusBarColor: AppColors.primaryColor,
//   //       ),
//   //       IOSUiSettings(
//   //         title: context.l10n.crop_image,
//   //         aspectRatioLockEnabled: true,
//   //         resetAspectRatioEnabled: false,
//   //       ),
//   //     ],
//   //   );
//   // }
// }

class DeleteAccountBottomSheet extends StatefulWidget {
  const DeleteAccountBottomSheet({super.key, required this.onDeleteAccount});

  final Future<void> Function() onDeleteAccount;

  static Future<bool?> show(
    BuildContext context, {
    required Future<void> Function() onDeleteAccount,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          DeleteAccountBottomSheet(onDeleteAccount: onDeleteAccount),
    );
  }

  @override
  State<DeleteAccountBottomSheet> createState() =>
      _DeleteAccountBottomSheetState();
}

class _DeleteAccountBottomSheetState extends State<DeleteAccountBottomSheet> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: context.isDark ? MyColors.darkItemBG2 : MyColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          16.ph,
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: MyColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          24.ph,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade700,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delete_forever,
              color: MyColors.white,
              size: 32,
            ),
          ),
          16.ph,
          MainText(
            context.l10n.delete_account,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          8.ph,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: MainText(
              context.l10n.are_you_sure_you_want_to_delete_your_account,
              fontSize: 16,
              color: Colors.grey[600],
              textAlign: TextAlign.center,
            ),
          ),
          24.ph,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              spacing: 16,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: MainText(
                      context.l10n.cancel,
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: MainButton(
                    onPressed: () async {
                      if (_isLoading) return;

                      setState(() => _isLoading = true);
                      try {
                        // Perform delete account operation
                        await widget.onDeleteAccount();

                        if (context.mounted) {
                          // If delete was successful, return true
                          Navigator.pop(context, true);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          // Show error message
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                          Navigator.pop(context, false);
                        }

                        if (mounted) {
                          setState(() => _isLoading = false);
                        }
                      }
                    },
                    backgroundColor: Colors.red.shade700,
                    title: context.l10n.delete_account,
                  ),
                ),
              ],
            ),
          ),
          16.ph,
        ],
      ),
    );
  }
}

// class ReviewBottomSheet extends StatefulWidget {
//   const ReviewBottomSheet({
//     super.key,
//     required this.onSubmit,
//     required this.crowdId,
//   });
//
//   final Future<void> Function(ReviewParameter) onSubmit;
//   final String crowdId;
//
//   static Future<bool?> show(BuildContext context,
//       {required Future<void> Function(ReviewParameter) onSubmit,
//         required String crowdId}) {
//     return showModalBottomSheet<bool>(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => ReviewBottomSheet(
//         onSubmit: onSubmit,
//         crowdId: crowdId,
//       ),
//     );
//   }
//
//   @override
//   State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
// }
//
// class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
//   bool _isLoading = false;
//
//   num? rating = 0;
//
//   final _messageController = TextEditingController();
//   final _messageFocusNode = FocusNode();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//       padding:
//       EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//       decoration: BoxDecoration(
//         color: context.isDark ? AppColors.darkItemBG2 : AppColors.white,
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: AppColors.grey300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//             24.ph,
//             Center(
//               child: MainText(
//                 context.l10n.add_rating,
//                 fontSize: 18,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             16.ph,
//             Center(
//               child: RatingBar.builder(
//                 initialRating: 0,
//                 minRating: 1,
//                 direction: Axis.horizontal,
//                 allowHalfRating: false,
//                 itemCount: 5,
//                 itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
//                 itemBuilder: (context, _) => Icon(
//                   Icons.star,
//                   color: Colors.amber,
//                 ),
//                 onRatingUpdate: (value) {
//                   setState(() {
//                     rating = value;
//                   });
//                 },
//               ),
//             ),
//             16.ph,
//             MainTextField(
//               controller: _messageController,
//               currentFocusNode: _messageFocusNode,
//               hint: context.l10n.writeYourMessageHere,
//             ),
//             16.ph,
//             Center(
//               child: LoadingButton(
//                 color: Theme.of(context).primaryColor,
//                 name: context.l10n.submit,
//                 onTap: () async {
//                   if (_messageController.text.trim().isEmpty || rating == 0) {
//                     ToastUtils.showErrorToast(
//                         context, 'type review and select rate');
//                     return;
//                   }
//                   if (_isLoading) return;
//
//                   FocusScope.of(context).requestFocus(FocusNode());
//                   setState(() => _isLoading = true);
//
//                   final review = ReviewParameter(
//                     entityId: widget.crowdId,
//                     rating: rating == null ? 0 : rating!.toInt(),
//                     review: _messageController.text,
//                     reviewType: ReviewType.crowd,
//                   );
//                   try {
//                     await widget.onSubmit(review);
//                     setState(() => _isLoading = false);
//                     Navigator.pop(context, true);
//                   } catch (e) {
//                     setState(() => _isLoading = false);
//                     ToastUtils.showErrorToast(context, e.toString());
//                   }
//
//                   // !widget.isUpdate.validate() ? addReviewApi(context) : updateReviewApi(context);
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// void showLocationDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 Icons.location_on,
//                 size: 50,
//                 color: AppColors.primaryColor,
//               ),
//               20.ph,
//               MainText(
//                 context.l10n.open_location,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//               10.ph,
//               MainText(
//                 context.l10n.location_permission_required,
//                 textAlign: TextAlign.center,
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//               20.ph,
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: MainText(
//                       context.l10n.cancel,
//                       color: Colors.grey,
//                       fontSize: 16,
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       Navigator.pop(context);
//                       await Geolocator.openLocationSettings();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 30,
//                         vertical: 10,
//                       ),
//                     ),
//                     child: MainText(
//                       context.l10n.active_loc,
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

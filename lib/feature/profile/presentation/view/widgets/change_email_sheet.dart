import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/extension/extension_helper.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/main_button.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../../../../shared/widgets/main_text_field.dart';
import '../../cubit/student_profile_cubit.dart';

class ChangeEmailSheet extends StatelessWidget {
  const ChangeEmailSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentProfileCubit, StudentProfileState>(
      //listener: _stateHandler,
      builder: (context, state) {
        final bool isLoading = state.isLoading;
        final cubit = context.read<StudentProfileCubit>();
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 32,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: context.read<StudentProfileCubit>().formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: MainText.bigText(
                      context.l10n.edit_email,
                      color: MyColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 24),
                  MainTextField(
                    controller: cubit.newEmail,
                    currentFocusNode: cubit.newEmailFocus,
                    nextFocusNode: cubit.passwordFocus,
                    keyboardType: TextInputType.emailAddress,
                    textDirection: context.isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    label: context.l10n.new_email,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: MyColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  MainTextField(
                    controller: cubit.password,
                    currentFocusNode: cubit.passwordFocus,
                    nextFocusNode: null,
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    label: context.l10n.password,
                    textDirection: context.isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: MyColors.primaryColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.password_validation;
                      }
                      if (value.length < 6) {
                        return context.l10n.password_validation_size;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  MainButton(
                    onPressed: state.isFormValid
                        ? () {
                      cubit.changeEmail();
                    }
                        : () {},
                    title: context.l10n.confirm,
                    isLoading: isLoading,
                    titleColor: state.isFormValid
                        ? MyColors.white
                        : MyColors.textDisabled,
                    backgroundColor: state.isFormValid
                        ? MyColors.primaryColor
                        : MyColors.black50,
                    //icon: Icons.send,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
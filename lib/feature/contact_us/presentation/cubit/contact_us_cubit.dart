import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/widgets/custom_image_bottom_sheet.dart';

part 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  ContactUsCubit() : super(ContactUsState());

  Future<void> pickImage(BuildContext context) async {
    if (state.selectedImages.length >= 3) {
      emit(
        state.copyWith(
          status: ContactUsStatus.error,
          errorMessage: 'Max 3 images allowed',
        ),
      );
      return;
    }

    final XFile? xFile = await ImageBottomSheet.show(context);

    if (xFile != null) {
      final List<XFile> updatedList = List.from(state.selectedImages)
        ..add(xFile);
      emit(
        state.copyWith(
          selectedImages: updatedList,
          status: ContactUsStatus.initial,
        ),
      );
    }
  }

  void removeImage(int index) {
    final List<XFile> updatedList = List.from(state.selectedImages)
      ..removeAt(index);
    emit(state.copyWith(selectedImages: updatedList));
  }

  Future<void> sendMessage({
    required String name,
    required String email,
    required String subject,
    required String message,
    String? phone,
  }) async {
    emit(state.copyWith(status: ContactUsStatus.loading));

    try {
      await Future.delayed(const Duration(seconds: 2));

      emit(
        state.copyWith(
          status: ContactUsStatus.success,
          successMessage: 'Message sent successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ContactUsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}

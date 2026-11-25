part of 'contact_us_cubit.dart';

enum ContactUsStatus { initial, loading, success, error }

class ContactUsState extends Equatable {
  final ContactUsStatus status;
  final String? errorMessage;
  final String? successMessage;
  final List<XFile> selectedImages;

  const ContactUsState({
    this.status = ContactUsStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.selectedImages = const [],
  });

  ContactUsState copyWith({
    ContactUsStatus? status,
    String? errorMessage,
    String? successMessage,
    List<XFile>? selectedImages,
  }) {
    return ContactUsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      selectedImages: selectedImages ?? this.selectedImages,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    successMessage,
    selectedImages,
  ];
}

import 'dart:io';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../shared/enum/gender.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../provider/update_profile.dart';

class ProfileEditWeb extends StatelessWidget {
  const ProfileEditWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UpdateProfileProvider>(
      builder: (context, provider, child) {
        return ModalProgressHUD(
          inAsyncCall: provider.state == UpdateProfileProviderState.loading,
          child: Scaffold(
            body: Column(
              children: [
                _buildProfessionalHeader(context),
                Expanded(child: _buildSimplifiedContent(context, provider)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfessionalHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
      decoration: BoxDecoration(
        color: context.isDark ? MyColors.darkItemBG2 : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: context.isDark ? Colors.white10 : MyColors.neutral200,
          ),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.isDark ? Colors.white10 : MyColors.neutral300,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                spacing: 8,
                children: [
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 14,
                    color: context.isDark
                        ? Colors.white70
                        : MyColors.neutral700,
                  ),
                  MainText(
                    context.l10n.back_button,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: context.isDark
                        ? Colors.white70
                        : MyColors.neutral700,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainText(
                context.l10n.edit_profile,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimplifiedContent(
    BuildContext context,
    UpdateProfileProvider provider,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 32),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: double.infinity),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              _buildProfileHeader(context, provider),
              const SizedBox(height: 32),

              // Two Column Layout
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column
                  Expanded(
                    child: Column(
                      children: [
                        _buildSectionCard(
                          context,
                          title: context.l10n.account_information,
                          child: Column(
                            spacing: 24,
                            children: [
                              _buildInfoItem(
                                context,
                                context.l10n.user_name, // Key usually exists
                                provider.form.userNameController.text,
                                isReadOnly: true,
                              ),
                              _buildInfoItem(
                                context,
                                context.l10n.email,
                                provider.form.emailController.text,
                                isReadOnly: true,
                              ),
                              _buildInputField(
                                context,
                                label: context.l10n.phone_number,
                                child: CustomPhone(
                                  key: ValueKey(
                                    'phone_field_${provider.phoneCountryIsoCode}',
                                  ),
                                  controller: provider.form.phoneController,
                                  label: context.l10n.phone_number,
                                  allowCountryChange: true,
                                  currentFocusNode: provider.phoneFocusNode,
                                  showClearButton: true,
                                  unFocusWhenTapOutside: true,
                                  textDirection: TextDirection.ltr,
                                  initialCountryCode:
                                      provider.phoneCountryIsoCode,
                                  onChangedPhoneNumber: (PhoneNumber number) {
                                    provider.updatePhoneNumber(number);
                                  },
                                  validator: (phone) {
                                    if (phone == null ||
                                        phone.completeNumber.isEmpty) {
                                      return context
                                          .l10n
                                          .please_enter_your_phone_number;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildSectionCard(
                          context,
                          title: context.l10n.additional_information,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // Expanded(
                                  //   child: _buildInputField(
                                  //     context,
                                  //     label: context.l10n.job_title,
                                  //     child: MainTextField(
                                  //       controller:
                                  //           provider.form.jobTitleController,
                                  //       label: "",
                                  //     ),
                                  //   ),
                                  // ),
                                  // const SizedBox(width: 24),
                                  // Expanded(
                                  //   child: _buildInputField(
                                  //     context,
                                  //     label: context.l10n.url,
                                  //     child: MainTextField(
                                  //       controller: provider.form.urlController,
                                  //       label: "",
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              // const SizedBox(height: 24),
                              _buildInputField(
                                context,
                                label: context.l10n.note,
                                child: MainTextField(
                                  controller: provider.form.notes,
                                  label: "",
                                  maxLines: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),

                  // Right Column
                  Expanded(
                    child: Column(
                      children: [
                        _buildSectionCard(
                          context,
                          title: context.l10n.personal_information,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInputField(
                                      context,
                                      label: context.l10n.full_name,
                                      child: MainTextField(
                                        controller:
                                            provider.form.fullNameController,
                                        label: "",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    child: _buildInfoItem(
                                      context,
                                      context.l10n.gender,
                                      _getGenderLabel(
                                        context,
                                        provider.form.gender,
                                      ),
                                      isReadOnly: true,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInputField(
                                      context,
                                      label: context.l10n.birthday,
                                      child: _buildDatePicker(
                                        context,
                                        provider,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    child: _buildInfoItem(
                                      context,
                                      context.l10n.selected_country,
                                      provider.userDetails?.country.name ??
                                          "N/A",
                                      isReadOnly: true,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              _buildInputField(
                                context,
                                label: context.l10n.address,
                                child: MainTextField(
                                  controller: provider.form.address,
                                  label: "",
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    UpdateProfileProvider provider,
  ) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: context.isDark ? MyColors.darkItemBG2 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => provider.changeProfilePicture(context),
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1C0070).withValues(alpha: 0.1),
                      width: 4,
                    ),
                    color: context.isDark
                        ? Colors.white10
                        : Colors.grey.withValues(alpha: 0.05),
                  ),
                  child: ClipOval(
                    child: provider.form.imageFile != null
                        ? (kIsWeb
                              ? FutureBuilder<Uint8List>(
                                  future: provider.form.imageFile!
                                      .readAsBytes(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Image.memory(
                                        snapshot.data!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => const Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      );
                                    }
                                    return const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.grey,
                                    );
                                  },
                                )
                              : Image.file(
                                  File(provider.form.imageFile!.path),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ))
                        : (provider.form.imageUrl != null
                              ? Image.network(
                                  provider.form.imageUrl!,
                                  fit: BoxFit.cover,
                                  // Use HTML <img> element on web to bypass CORS
                                  webHtmlElementStrategy:
                                      WebHtmlElementStrategy.prefer,
                                  errorBuilder: (_, _, _) => const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.grey,
                                )),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C0070),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText(
                  provider.form.fullNameController.text.isNotEmpty
                      ? provider.form.fullNameController.text
                      : context.l10n.welcome,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                // MainText(
                //   // provider.form.jobTitleController.text.isNotEmpty
                //   //     ? provider.form.jobTitleController.text
                //   //     : context.l10n.teacher,
                //   fontSize: 16,
                //   color: const Color(0xFF64748B),
                // ),
              ],
            ),
          ),
          _buildSaveButton(context, provider),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.isDark ? MyColors.darkItemBG2 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        spacing: 24,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MainText(title, fontSize: 18, fontWeight: FontWeight.bold),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value, {
    bool isReadOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainText(label, fontSize: 14, fontWeight: FontWeight.w600),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: context.isDark
                ? MyColors.darkItemBG3
                : const Color(0xFFF7F9FC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: MainText(
            value.isNotEmpty ? value : "N/A",
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required String label,
    required Widget child,
  }) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainText(label, fontSize: 14, fontWeight: FontWeight.w600),
        child,
      ],
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    UpdateProfileProvider provider,
  ) {
    return InkWell(
      onTap: () => provider.selectBirthDate(context),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: context.isDark ? MyColors.darkItemBG3 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            MainText(
              provider.form.birthday != null
                  ? "${provider.form.birthday!.year}-${provider.form.birthday!.month}-${provider.form.birthday!.day}"
                  : "YYYY-MM-DD",
              color: provider.form.birthday != null
                  ? context.isDark
                        ? Colors.white
                        : Colors.black
                  : Colors.grey,
            ),
            const Spacer(),
            const Icon(Icons.calendar_month, size: 20),
          ],
        ),
      ),
    );
  }

  String _getGenderLabel(BuildContext context, Gender? gender) {
    if (gender == Gender.male) return context.l10n.male;
    if (gender == Gender.female) return context.l10n.female;
    return '';
  }

  Widget _buildSaveButton(
    BuildContext context,
    UpdateProfileProvider provider,
  ) {
    final canSave =
        provider.form.hasChanges &&
        provider.state != UpdateProfileProviderState.loading;
    return MainButton(
      width: 140,
      height: 48,
      title: context.l10n.save,
      titleColor: Colors.white,
      backgroundColor: canSave
          ? const Color(0xFF1C0070)
          : const Color(0xFF64748B).withValues(alpha: 0.5),
      borderRadius: 12,
      onPressed: canSave
          ? () {
              //if (provider.form.validate()) {
              provider.saveProfile(context);
              //}
            }
          : null,
    );
  }
}

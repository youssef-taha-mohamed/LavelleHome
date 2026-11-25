import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../../../../shared/widgets/custom_header.dart';
import '../../../../core/authentication/provider.dart';
import '../../../../core/extension/extension_helper.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/main_text_field.dart';
import '../../../../shared/widgets/redo_back.dart';
import '../cubit/contact_us_cubit.dart';


class ContactUsScreen extends StatefulWidget {
  static const String routeName = '/contact-us';

  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    _prefillUserInfo();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _prefillUserInfo() {
    final userDetails = AuthenticationProvider.instance.currentUser?.details;
    if (userDetails != null) {
      _nameController.text = userDetails.fullName;
      _emailController.text = userDetails.email;
      _phoneController.text = userDetails.phone;
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.isDark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: MyColors.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: MyColors.primaryColor,
                size: 36,
              ),
            ),
            16.ph,
            MainText.bigText(
              context.l10n.message_sent,
              fontSize: 16,
              color: context.isDark ? Colors.white : MyColors.textDark,
              textAlign: TextAlign.center,
            ),
            8.ph,
            MainText(
              context.l10n.message_sent_desc,
              color: context.isDark ? Colors.white60 : MyColors.grey4,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: MainText(
              context.l10n.ok,
              fontSize: 14,
              color: MyColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: MainText(message, fontSize: 13, color: Colors.white),
        backgroundColor: isError ? Colors.red.shade600 : MyColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactUsCubit(),
      child: BlocConsumer<ContactUsCubit, ContactUsState>(
        listener: (context, state) {
          if (state.status == ContactUsStatus.success) {
            _showSuccessDialog(context);
          } else if (state.status == ContactUsStatus.error) {
            _showSnackBar(context, state.errorMessage ?? '', isError: true);
          }
        },
        builder: (context, state) {
          final cubit = context.read<ContactUsCubit>();
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  CustomStudentHeader(
                    title: context.l10n.contact_us,
                    subTitle: context.l10n.get_in_touch,
                    showLeading: true,
                    leadingIcon: Icons.arrow_forward_ios_outlined,
                    onLeadingTap: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDescriptionCard(),
                          20.ph,
                          _buildContactForm(context, cubit, state),
                          24.ph,
                          _buildDivider(),
                          20.ph,
                          _buildQuickContactMethods(),
                          20.ph,
                          _buildWorkingHours(),
                          30.ph,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                MyColors.primaryColor.withValues(alpha: 0.08),
                MyColors.lightTeal.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: MyColors.primaryColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: MyColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.support_agent_rounded,
                  color: MyColors.primaryColor,
                  size: 24,
                ),
              ),
              14.pw,
              Expanded(
                child: MainText(
                  context.l10n.contact_desc,
                  fontSize: 13,
                  color: context.isDark ? Colors.white70 : MyColors.textDark,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -12,
          left: context.isArabic ? -5 : null,
          right: context.isArabic ? null : -5,
          child: RedoBack(
            borderColor: MyColors.primaryColor.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildContactForm(
    BuildContext context,
    ContactUsCubit cubit,
    ContactUsState state,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.isDark
              ? const Color(0xFF2A2A2A)
              : const Color(0xFFE8E8E8),
          width: 1,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: _nameController,
              label: context.l10n.your_name,
              icon: Icons.person_outline_rounded,
            ),
            16.ph,
            _buildTextField(
              controller: _emailController,
              label: context.l10n.your_email,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  (v != null && (!v.contains('@') || !v.contains('.')))
                  ? context.l10n.invalid_email
                  : null,
            ),
            16.ph,
            _buildTextField(
              controller: _phoneController,
              label: context.l10n.your_phone,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            16.ph,
            _buildTextField(
              controller: _subjectController,
              label: context.l10n.subject,
              icon: Icons.title_rounded,
            ),
            16.ph,
            _buildTextField(
              controller: _messageController,
              label: context.l10n.message,
              icon: Icons.message_outlined,
              maxLines: 5,
            ),
            20.ph,
            _buildImageUploadSection(context, cubit, state),
            24.ph,
            _buildSendButton(cubit, state),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: MyColors.primaryColor),
            6.pw,
            MainText(
              label,
              fontSize: 13,
              color: context.isDark ? Colors.white70 : MyColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        8.ph,
        MainTextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator:
              validator ??
              (v) =>
                  (v == null || v.isEmpty) ? context.l10n.field_required : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadSection(
    BuildContext context,
    ContactUsCubit cubit,
    ContactUsState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.image_outlined, size: 16, color: MyColors.primaryColor),
            6.pw,
            MainText(
              context.l10n.attach_images,
              fontSize: 13,
              color: context.isDark ? Colors.white70 : MyColors.textDark,
              fontWeight: FontWeight.w600,
            ),
            const Spacer(),
            MainText(
              '${state.selectedImages.length}/3',
              fontSize: 12,
              color: context.isDark ? Colors.white60 : MyColors.grey4,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        12.ph,
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ...state.selectedImages.asMap().entries.map(
              (entry) => _buildImagePreview(entry.value, entry.key, cubit),
            ),
            if (state.selectedImages.length < 3)
              GestureDetector(
                onTap: () => cubit.pickImage(context),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: MyColors.primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: MyColors.primaryColor.withValues(alpha: 0.3),
                      width: 1.5,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Icon(
                    Icons.add_photo_alternate_outlined,
                    color: MyColors.primaryColor,
                    size: 28,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePreview(XFile image, int index, ContactUsCubit cubit) {
    return Stack(
      children: [
        FutureBuilder<Uint8List>(
          future: image.readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: MemoryImage(snapshot.data!),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }
            return Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
              ),
              child: const Center(child: CircularProgressIndicator()),
            );
          },
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => cubit.removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSendButton(ContactUsCubit cubit, ContactUsState state) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: state.status == ContactUsStatus.loading
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  cubit.sendMessage(
                    name: _nameController.text,
                    email: _emailController.text,
                    subject: _subjectController.text,
                    message: _messageController.text,
                    phone: _phoneController.text,
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: state.status == ContactUsStatus.loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  10.pw,
                  MainText(
                    context.l10n.send_message,
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: context.isDark
                ? const Color(0xFF2A2A2A)
                : const Color(0xFFE8E8E8),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MainText(
            context.l10n.or_contact_via,
            fontSize: 12,
            color: context.isDark ? Colors.white60 : MyColors.grey4,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: context.isDark
                ? const Color(0xFF2A2A2A)
                : const Color(0xFFE8E8E8),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickContactMethods() {
    return Row(
      children: [
        Expanded(
          child: _buildContactMethodCard(
            icon: Icons.wallet,
            label: context.l10n.whatsapp,
            color: const Color(0xFF25D366),
            onTap: _openWhatsApp,
          ),
        ),
        12.pw,
        Expanded(
          child: _buildContactMethodCard(
            icon: Icons.email_outlined,
            label: context.l10n.email_us,
            color: MyColors.primaryColor,
            onTap: _openEmail,
          ),
        ),
        12.pw,
        Expanded(
          child: _buildContactMethodCard(
            icon: Icons.phone_outlined,
            label: context.l10n.call_us,
            color: MyColors.islamicGold,
            onTap: _makePhoneCall,
          ),
        ),
      ],
    );
  }

  Widget _buildContactMethodCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: context.isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.isDark
                ? const Color(0xFF2A2A2A)
                : const Color(0xFFE8E8E8),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            8.ph,
            MainText(
              label,
              fontSize: 12,
              color: context.isDark ? Colors.white70 : MyColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkingHours() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.isDark
              ? const Color(0xFF2A2A2A)
              : const Color(0xFFE8E8E8),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MyColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.access_time_rounded,
              color: MyColors.primaryColor,
              size: 20,
            ),
          ),
          14.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText.bigText(
                  context.l10n.working_hours,
                  fontSize: 14,
                  color: context.isDark ? Colors.white : MyColors.textDark,
                ),
                4.ph,
                MainText(
                  context.l10n.working_hours_time,
                  fontSize: 12,
                  color: context.isDark ? Colors.white60 : MyColors.grey4,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openWhatsApp() async {
    const phoneNumber = '+201234567890';
    final url = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openEmail() async {
    const email = 'support@konoz.com';
    final url = Uri.parse('mailto:$email');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  Future<void> _makePhoneCall() async {
    const phone = '+201234567890';
    final url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }
}

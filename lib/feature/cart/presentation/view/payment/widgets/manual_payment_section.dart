import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../core/extension/extension_helper.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/style/app_colors.dart';
import '../../../../../../l10n/l10n.dart';
import '../../../../../../shared/widgets/main_text.dart';
import '../../../../../../shared/widgets/main_text_field.dart';
import '../../../provider/provider.dart';

class ManualPaymentSection extends StatelessWidget {
  final bool isDesktop;
  const ManualPaymentSection({super.key, this.isDesktop = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            24.ph,
            MainText(
              context.l10n.manual_payment,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.isDark ? MyColors.white : MyColors.textDark,
            ),
            12.ph,
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.isDark
                    ? MyColors.darkGreen.withValues(alpha: 0.1)
                    : MyColors.lightTeal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: MyColors.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  MainText(
                    context.l10n.manual_payment_instructions,
                    fontSize: 14,
                    color: context.isDark ? MyColors.grey4 : MyColors.textDark,
                    textAlign: TextAlign.center,
                  ),
                  16.ph,
                  ...provider.bankAccounts.map((account) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildBankDetailRow(context, context.l10n.bank_name,
                                account.bankName),
                            4.ph,
                            _buildBankDetailRow(
                              context,
                              context.l10n.account_name,
                              account.accountHolderName,
                            ),
                            4.ph,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MainText(
                                  context.l10n.account_number,
                                  fontSize: 13,
                                  color: MyColors.grey4,
                                ),
                                Row(
                                  children: [
                                    MainText(
                                      account.accountNumber,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: context.isDark
                                          ? MyColors.white
                                          : MyColors.textDark,
                                    ),
                                    8.pw,
                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                            text: account.accountNumber));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text("تم نسخ رقم الحساب")),
                                        );
                                      },
                                      child: Icon(
                                        Icons.copy_rounded,
                                        size: 16,
                                        color: MyColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            4.ph,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MainText(
                                  context.l10n.iban,
                                  fontSize: 13,
                                  color: MyColors.grey4,
                                ),
                                Row(
                                  children: [
                                    MainText(
                                      account.iban,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: context.isDark
                                          ? MyColors.white
                                          : MyColors.textDark,
                                    ),
                                    8.pw,
                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(
                                            ClipboardData(text: account.iban));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text("تم نسخ رقم الايبان")),
                                        );
                                      },
                                      child: Icon(
                                        Icons.copy_rounded,
                                        size: 16,
                                        color: MyColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            4.ph,
                            if (account.notes != null &&
                                account.notes!.isNotEmpty)
                              _buildBankDetailRow(context, context.l10n.note,
                                  account.notes.toString()),
                            if (provider.bankAccounts.last != account)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Divider(
                                    color:
                                        MyColors.grey4.withValues(alpha: 0.2)),
                              ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            20.ph,
            Row(
              children: [
                Expanded(
                  child: _buildUploadButton(
                    context,
                    title: context.l10n.upload_image,
                    icon: Icons.image_rounded,
                    onTap: () async {
                      if (isDesktop) {
                        await provider.pickReceipt(
                          isPdf: false,
                          imageSource: ImageSource.gallery,
                        );
                        if (provider.state == CartProviderState.error &&
                            context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(provider.errorMessage ?? ""),
                              backgroundColor: Colors.red,
                            ),
                          );
                          provider.clearError();
                        }
                      } else {
                        _showImageSourcePicker(context, provider);
                      }
                    },
                  ),
                ),
                16.pw,
                Expanded(
                  child: _buildUploadButton(
                    context,
                    title: context.l10n.upload_pdf,
                    icon: Icons.picture_as_pdf_rounded,
                    onTap: () async {
                      await provider.pickReceipt(isPdf: true);
                      if (isDesktop &&
                          provider.state == CartProviderState.error &&
                          context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(provider.errorMessage ?? ""),
                            backgroundColor: Colors.red,
                          ),
                        );
                        provider.clearError();
                      }
                    },
                  ),
                ),
              ],
            ),
            if (provider.attachedReceiptBytes != null) ...[
              16.ph,
              _buildFilePreview(context, provider),
            ],
            20.ph,
            MainText(
              context.l10n.note_option,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.isDark ? MyColors.white : MyColors.textDark,
            ),
            8.ph,
            MainTextField(
              controller: provider.noteController,
              hint: context.l10n.note_mewwage,
              maxLines: 3,
            ),
          ],
        );
      },
    );
  }

  Widget _buildBankDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MainText(
          label,
          fontSize: 13,
          color: MyColors.grey4,
          textAlign: TextAlign.end,
        ),
        Spacer(),
        Flexible(
          flex: 5,
          child: MainText(
            value,
            fontSize: 14,
            textAlign: TextAlign.end,
            fontWeight: FontWeight.bold,
            color: context.isDark ? MyColors.white : MyColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: MyColors.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: MyColors.primaryColor, width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: MyColors.primaryColor, size: 28),
            8.ph,
            MainText(
              title,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: MyColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePreview(BuildContext context, CartProvider provider) {
    final fileName = provider.attachedReceiptName ?? 'file';
    final isPdf = fileName.toLowerCase().endsWith('.pdf');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.isDark ? MyColors.white : MyColors.grey100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MyColors.grey4.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isPdf ? Colors.red : Colors.blue).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isPdf ? Icons.picture_as_pdf_rounded : Icons.image_rounded,
              color: isPdf ? Colors.red : Colors.blue,
              size: 24,
            ),
          ),
          12.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText(
                  context.l10n.file_selected,
                  fontSize: 12,
                  color: MyColors.grey4,
                ),
                MainText(
                  fileName,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => provider.clearReceipt(),
            icon: const Icon(Icons.close_rounded, color: Colors.red),
          ),
        ],
      ),
    );
  }

  void _showImageSourcePicker(BuildContext context, CartProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.isDark ? MyColors.darkItemBG5 : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            16.ph,
            MainText(
              context.l10n.choose_photo,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            8.ph,
            ListTile(
              leading: const Icon(Icons.photo_library_rounded,
                  color: MyColors.primaryColor),
              title: MainText(context.l10n.gallery),
              onTap: () {
                Navigator.pop(context);
                provider.pickReceipt(
                    isPdf: false, imageSource: ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded,
                  color: MyColors.primaryColor),
              title: MainText(context.l10n.camera),
              onTap: () {
                Navigator.pop(context);
                provider.pickReceipt(
                    isPdf: false, imageSource: ImageSource.camera);
              },
            ),
            16.ph,
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../core/authentication/provider.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/style/theme/extensions/app_theme_extension.dart';
import '../../../../core/utils/utilities.dart';
import '../../../../feature/user/domain/entities/parameters/update_preference.dart';
import '../../../../feature/user/domain/entities/user.dart';
import '../../../../l10n/l10n.dart';
import '../../../cubits/language/language_cubit.dart';
import '../../../widgets/custom_tablet_appbar.dart';
import '../../../widgets/main_text.dart';
import '../../widgets/language_item.dart';

class LanguageScreenTablet extends StatelessWidget {
  const LanguageScreenTablet({super.key, required this.languageCubit});

  final LanguageCubit languageCubit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;

    return Column(
      children: [
        StreamBuilder<User?>(
          stream: AuthenticationProvider.instance.userChanges(),
          builder: (context, snapshot) {
            final user = snapshot.data;
            return CustomTabletStudentHeader(
              title: context.l10n.select_language,
              subTitle: getGreetingTablet(context),
              image:
                  user?.details.image ??
                  'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png',
              showLeading: true,
            );
          },
        ),
        Expanded(
          child: BlocBuilder<LanguageCubit, LanguageState>(
            bloc: languageCubit,
            builder: (context, state) {
              if (state.isLoadingLanguage) {
                return const Center(child: CircularProgressIndicator());
              }
              return ModalProgressHUD(
                inAsyncCall: state.isLoadingUpdate,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 32,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: theme.primaryGradient,
                                borderRadius: BorderRadius.circular(16),
                                border: theme.primaryBorder,
                                boxShadow: theme.mediumShadow,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: MyColors.primaryColor.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.translate_rounded,
                                      color: MyColors.primaryColor,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MainText(
                                          context.l10n.available_languages,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        const SizedBox(height: 8),
                                        MainText(
                                          context.l10n.language_change_notice,
                                          fontSize: 18,
                                          color: MyColors.neutral500,
                                          fontWeight: FontWeight.w500,
                                          maxLines: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(
                        left: 48,
                        right: 48,
                        top: 0,
                        bottom: 32,
                      ),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 450,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 24,
                              childAspectRatio: 2.5,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return LanguageItem(
                            isTablet: true,
                            languageCode: state.languages[index].code,
                            isSelected:
                                state.languages[index].code ==
                                state.languageCode,
                            title: state.languages[index].name,
                            subtitle: state.languages[index].name,
                            gradientColors: [
                              MyColors.darkGreen,
                              MyColors.deepGreen,
                            ],
                            onTap: () async {
                              final defaultTheme = state.themes.firstWhere(
                                (theme) => theme.isDefault,
                              );
                              await languageCubit.updatePreference(
                                UpdatePreference(
                                  languageId: state.languages[index].priority,
                                  themeId: defaultTheme.theme,
                                ),
                              );

                              if (languageCubit.state.isSuccessUpdate) {
                                languageCubit.changeLanguage(
                                  state.languages[index].code,
                                );
                              }
                            },
                          );
                        }, childCount: state.languages.length),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

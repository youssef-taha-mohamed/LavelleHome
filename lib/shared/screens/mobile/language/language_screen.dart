import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../core/authentication/provider.dart';
import '../../../../core/di/dependency_injector.dart';
import '../../../../core/extension/extension_helper.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../feature/user/domain/entities/parameters/update_preference.dart';
import '../../../../feature/user/domain/entities/user.dart';
import '../../../../l10n/l10n.dart';
import '../../../cubits/language/language_cubit.dart';
import '../../../widgets/custom_header.dart';
import '../../../widgets/main_text.dart';
import '../../desktop/language/language_desctop.dart';
import '../../tablet/language/language_screen_tablet.dart';
import '../../widgets/language_item.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  static const routeName = '/language';

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late LanguageCubit _languageCubit;

  @override
  void initState() {
    _languageCubit = DependencyInjector.languageCubit;

    _languageCubit.getPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _languageCubit,
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, state) {
              final category = AppResponsive.getCategory(context);
              final isTablet = category == DeviceCategory.smallTablet ||
                  category == DeviceCategory.largeTablet;

              if (category == DeviceCategory.desktop) {
                return LanguageDesktop(
                  state: state,
                  onUpdateLanguage: (index) async {
                    final defaultTheme = state.themes.firstWhere(
                      (theme) => theme.isDefault,
                    );
                    await _languageCubit.updatePreference(
                      UpdatePreference(
                        languageId: state.languages[index].priority,
                        themeId: defaultTheme.theme,
                      ),
                    );
                    if (_languageCubit.state.isSuccessUpdate) {
                      _languageCubit.changeLanguage(
                          state.languages[index].code);
                    }
                  },
                );
              }

              if (isTablet) {
                return LanguageScreenTablet(
                  languageCubit: _languageCubit,
                );
              }

              return Column(
                    children: [
                      StreamBuilder<User?>(
                        stream: AuthenticationProvider.instance.userChanges(),
                        builder: (context, snapshot) {
                          final user = snapshot.data;
                          return CustomStudentHeader(
                            title: context.l10n.select_language,
                            subTitle: user?.details.fullName ?? '',
                            image: user?.details.image ??
                                'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png',
                            showLeading: true,
                          );
                        },
                      ),
                      Expanded(
                        child: state.isLoadingLanguage
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ModalProgressHUD(
                                inAsyncCall: state.isLoadingUpdate,
                                child: CustomScrollView(
                          physics: BouncingScrollPhysics(),
                          slivers: [
                            SliverPadding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              sliver: SliverToBoxAdapter(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MainText(
                                      context.l10n.available_languages,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: context.isDark
                                          ? MyColors.white
                                          : MyColors.black900,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SliverPadding(
                              padding: EdgeInsets.only(
                                  left: 16, right: 16, top: 0, bottom: 16),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    return LanguageItem(
                                      languageCode: state.languages[index].code,
                                      isSelected: state.languages[index].code ==
                                          state.languageCode,
                                      title: state.languages[index].name,
                                      subtitle: state.languages[index].name,
                                      gradientColors: [
                                        MyColors.darkGreen,
                                        MyColors.deepGreen,
                                      ],
                                      onTap: () async {
                                        final defaultTheme =
                                            state.themes.firstWhere(
                                          (theme) => theme.isDefault,
                                        );
                                        await _languageCubit.updatePreference(
                                          UpdatePreference(
                                            languageId:
                                                state.languages[index].priority,
                                            themeId: defaultTheme.theme,
                                          ),
                                        );

                                        if (_languageCubit
                                            .state.isSuccessUpdate) {
                                          _languageCubit.changeLanguage(
                                              state.languages[index].code);
                                        }
                                      },
                                    );
                                  },
                                  childCount: state.languages.length,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
  }
}

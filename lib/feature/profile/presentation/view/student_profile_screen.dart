import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/authentication/provider.dart';
import '../../../../core/di/dependency_injector.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/utils/shimmers/profile.dart';
import '../../../../core/utils/utilities.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/custom_header.dart';
import '../../../../shared/widgets/main_text.dart';
import '../../../user/domain/entities/user.dart';
import '../cubit/student_profile_cubit.dart';
import 'widgets/profile_card.dart';
import 'widgets/student_menu_list.dart';
import 'student_profile_screen_tablet.dart';
import '../desctop/profile_view_desctop.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentProfileCubit(
        repository: DependencyInjector.userRepository,
        cache: DependencyInjector.hiveAuthenticationCache,
      ),
      child: _StudentProfileScreenContent(),
    );
  }
}

class _StudentProfileScreenContent extends StatefulWidget {
  @override
  State<_StudentProfileScreenContent> createState() =>
      __StudentProfileScreenContentState();
}

class __StudentProfileScreenContentState
    extends State<_StudentProfileScreenContent> {
  bool _isLoggingOut = false;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {
    context.read<StudentProfileCubit>().fetchUserById();
    _initPackageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<StudentProfileCubit>(),
      child: BlocConsumer<StudentProfileCubit, StudentProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.isLoadingUser || state.userDetails == null) {
            return StudentProfileScreenShimmer();
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 1100) {
                return const StudentProfileDesktop();
              }
              if (constraints.maxWidth >= 600) {
                return StreamBuilder<User?>(
                  stream: AuthenticationProvider.instance.userChanges(),
                  builder: (context, snapshot) {
                    final user = snapshot.data;
                    return StudentProfileScreenTabletView(
                      user: user?.details,
                      isLoggingOut: _isLoggingOut,
                      packageInfo: _packageInfo,
                      onLogoutStart: () => setState(() => _isLoggingOut = true),
                      onLogoutEnd: () => setState(() => _isLoggingOut = false),
                      onRefresh: () async {
                        context.read<StudentProfileCubit>().fetchUserById();
                      },
                    );
                  },
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<StudentProfileCubit>().fetchUserById();
                },
                child: ModalProgressHUD(
                  inAsyncCall: _isLoggingOut,
                  child: Scaffold(
                    body: StreamBuilder<User?>(
                      stream: AuthenticationProvider.instance.userChanges(),
                      builder: (context, snapshot) {
                        final user = snapshot.data;
                        return SafeArea(
                          child: Column(
                            children: [
                              CustomStudentHeader(
                                title: getGreeting(context),
                                subTitle: user?.details.fullName ?? '',
                                image:
                                    user?.details.image ??
                                    'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png',
                                showNotification: true,
                              ),
                              Expanded(
                                child: CustomScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics(),
                                  ),
                                  slivers: [
                                    SliverToBoxAdapter(
                                      child: Column(
                                        children: [
                                          SizedBox(height: 8),
                                          ProfileCardWidget(
                                            user: user?.details,
                                          ),
                                          StudentMenuList(
                                            user: user?.details,
                                            onLogoutStart: () => setState(
                                              () => _isLoggingOut = true,
                                            ),
                                            onLogoutEnd: () => setState(
                                              () => _isLoggingOut = false,
                                            ),
                                          ),
                                          SizedBox(height: 24),
                                          _buildFooter(context),
                                          SizedBox(height: 16),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    debugPrint("_buildFooter${context.l10n.version(_packageInfo.version)}");
    return Column(
      spacing: 4,
      children: [
        MainText(
          context.l10n.knoz_education_app,
          fontSize: 12,
          color: MyColors.neutral500,
          fontWeight: FontWeight.w600,
        ),
        MainText(
          context.l10n.version(_packageInfo.version),
          fontSize: 10,
          color: MyColors.neutral400,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}

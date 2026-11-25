import '../../../../core/authentication/provider.dart';
import '../../../../core/di/dependency_injector.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../cubit/student_profile_cubit.dart';
import 'profile_edit.dart';
import 'widgets/action_button.dart';
import '../../../user/domain/entities/user.dart';
import 'widgets/profile_details.dart';
import 'widgets/profile_header_card.dart';
import 'profile_view_tablet.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const routeName = '/profile_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentProfileCubit(
        repository: DependencyInjector.userRepository,
        cache: DependencyInjector.hiveAuthenticationCache,
      ),
      child: _ProfileViewContent(),
    );
  }
}

class _ProfileViewContent extends StatefulWidget {
  @override
  State<_ProfileViewContent> createState() => __ProfileViewContentState();
}

class __ProfileViewContentState extends State<_ProfileViewContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentProfileCubit, StudentProfileState>(
      listener: (context, state) {
        if (state.isEmailChangedSuccess) {
          _showOTPBottomSheet(context);
        }
      },
      listenWhen: (previous, current) {
        return !previous.isEmailChangedSuccess && current.isEmailChangedSuccess;
      },
      builder: (context, state) {
        return StreamBuilder<User?>(
          stream: AuthenticationProvider.instance.userChanges(),
          builder: (context, snapshot) {
            final user = snapshot.data?.details;
            return LayoutBuilder(
              builder: (context, constraints) {
                final isTablet = constraints.maxWidth >= 600;
                if (isTablet) {
                  return ProfileViewTablet(
                    user: user,
                    fadeAnimation: _fadeAnimation,
                    slideAnimation: _slideAnimation,
                  );
                }
                return Scaffold(
                  body: SafeArea(
                    child: Column(
                      spacing: 16,
                      children: [
                        CustomStudentHeader(
                          title: context.l10n.profile_settings,
                          subTitle: user?.fullName ?? '',
                          image: user?.image ??
                              'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png',
                          showNotification: true,
                          showLeading: true,
                        ),
                        Expanded(
                          child: CustomScrollView(
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                              SliverPadding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                sliver: SliverToBoxAdapter(
                                  child: FadeTransition(
                                    opacity: _fadeAnimation,
                                    child: SlideTransition(
                                      position: _slideAnimation,
                                      child: Column(
                                        spacing: 24,
                                        children: [
                                          ProfileHeaderCard(user: user),
                                          ProfileDetails(user: user),
                                          ActionButton(
                                            editProfile: () {
                                              HapticFeedback.lightImpact();
                                              Navigator.pushNamed(
                                                context,
                                                ProfileEdit.routeName,
                                              );
                                            },
                                            myCourses: () {
                                              HapticFeedback.lightImpact();
                                             
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showOTPBottomSheet(BuildContext context) {
    final cubit = context.read<StudentProfileCubit>();
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (newContext) => BlocProvider.value(
        value: cubit,
        child: OTPBottomSheet(
          email: cubit.newEmail.text,
          onVerificationSuccess: (otpString) {
            return cubit.confirmChangeEmail(otp: otpString);
          },
          onResendOTP: () {
            cubit.resendOTP(cubit.newEmail.text);
          },
        ),
      ),
    ).then((result) {
      if (result == true && context.mounted) {
        // After the sheet closes with success, fetch the user
        cubit.newEmail.clear();
        cubit.password.clear();
        context.read<StudentProfileCubit>().fetchUserById();
      }
    });
  }
}

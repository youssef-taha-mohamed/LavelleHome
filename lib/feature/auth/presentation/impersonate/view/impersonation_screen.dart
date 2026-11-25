import '../../../../../core/di/dependency_injector.dart';
import '../../../../../core/resources/images.dart';
import '../../../../../shared/widgets/shared_widgets.dart';
import '../../../../botttom_nav_bar/nav_bar.dart';
import '../../../domain/use_cases/impersonate.dart';
import '../../login/view/login.dart';
import '../cubit/impersonation_cubit.dart';
import '../cubit/impersonation_state.dart';

class ImpersonationScreen extends StatefulWidget {
  const ImpersonationScreen({super.key, this.token});

  static const String routeName = '/impersonate';

  final String? token;

  @override
  State<ImpersonationScreen> createState() => _ImpersonationScreenState();
}

class _ImpersonationScreenState extends State<ImpersonationScreen> {
  late final ImpersonationCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ImpersonationCubit(
      impersonateUseCase: Impersonate(
        repository: DependencyInjector.authenticationRepository,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(
        '🎬 [ImpersonationScreen] Starting loginAsUser with token: "${widget.token}"',
      );
      _cubit.loginAsUser(token: widget.token);
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final backgroundColor = isDark
        ? MyColors.darkThemeBg
        : MyColors.scaffoldColor;
    final cardColor = isDark ? const Color(0xFF1E2230) : Colors.white;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: BlocConsumer<ImpersonationCubit, ImpersonationState>(
              listener: (context, state) {
                if (state is ImpersonationSuccess) {
                  final isParent =
                      state.user.details.role.id == UserRole.parent.id ||
                      (state.studentId != null &&
                          state.studentId!.trim().isNotEmpty);

                  debugPrint(
                    '🚀 [ImpersonationScreen] Login success! isParent: $isParent, role: ${state.user.details.role}, studentId: ${state.studentId}',
                  );

                  if (!context.mounted) return;

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    BottomNavBar.routeName,
                    (route) => false,
                  );
                }
              },
              builder: (context, state) {
                return Container(
                  constraints: const BoxConstraints(maxWidth: 440),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 40,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.4 : 0.06,
                        ),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.04),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(ImagesAssets.logo, width: 90, height: 90),
                      const SizedBox(height: 24),
                      if (state is ImpersonationLoading ||
                          state is ImpersonationInitial ||
                          state is ImpersonationSuccess) ...[
                        const SizedBox(
                          width: 44,
                          height: 44,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              MyColors.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const MainText(
                          'تسجيل الدخول إلى الحساب',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        MainText(
                          'يرجى الانتظار، جاري التحقق من الصلاحيات وتحضير الجلسة...',
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          textAlign: TextAlign.center,
                        ),
                      ] else if (state is ImpersonationFailure) ...[
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.error_outline_rounded,
                            color: Colors.redAccent,
                            size: 36,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const MainText(
                          'تعذر تسجيل الدخول',
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        MainText(
                          state.message,
                          fontSize: 14,
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                LoginView.routeName,
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const MainText(
                              'العودة لصفحة الدخول',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

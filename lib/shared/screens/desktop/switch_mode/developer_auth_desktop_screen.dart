import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extension/extension_helper.dart';
import '../../../../core/style/app_colors.dart';
import '../../../cubit/developer_cubit.dart';
import '../../../widgets/main_button.dart';
import '../../../widgets/main_text.dart';
import 'developer_desktop_screen.dart';

class DeveloperAuthDesktopScreen extends StatefulWidget {
  const DeveloperAuthDesktopScreen({super.key});

  @override
  State<DeveloperAuthDesktopScreen> createState() =>
      _DeveloperAuthDesktopScreenState();
}

class _DeveloperAuthDesktopScreenState
    extends State<DeveloperAuthDesktopScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext blocContext) {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      blocContext.read<DeveloperCubit>().login(
            _usernameController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final backgroundColor =
        isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
    final inputFill = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF1F5F9);

    return BlocProvider(
      create: (context) => DeveloperCubit(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: BlocConsumer<DeveloperCubit, DeveloperState>(
          listener: (context, state) {
            if (state is DeveloperAuthSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeveloperDesktopScreen(),
                ),
              );
            } else if (state is DeveloperAuthFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: const Color(0xFFDC2626),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(24),
                  content: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                // ── Subtle Ambient Background Accents ──
                Positioned(
                  top: -120,
                  right: -100,
                  child: Container(
                    width: 360,
                    height: 360,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          MyColors.primaryColor.withValues(alpha: isDark ? 0.18 : 0.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -100,
                  left: -80,
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF0EA5E9).withValues(alpha: isDark ? 0.12 : 0.06),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Top Navigation Bar ──
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back to Application Button
                        InkWell(
                          onTap: () => Navigator.maybePop(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back_rounded,
                                  size: 18,
                                  color: isDark ? Colors.white70 : Colors.black87,
                                ),
                                const SizedBox(width: 8),
                                MainText(
                                  'Back to App',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white70 : Colors.black87,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // System Environment Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: MyColors.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: MyColors.primaryColor.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: MyColors.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const MainText(
                                'KNOZ Developer Gateway',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: MyColors.primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Centered Card ──
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 80,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Container(
                        padding: const EdgeInsets.all(36),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.3 : 0.04,
                              ),
                              blurRadius: 30,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Icon Container
                              Center(
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: MyColors.primaryColor.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: MyColors.primaryColor.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.admin_panel_settings_rounded,
                                    size: 32,
                                    color: MyColors.primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Title & Subtitle
                              const Center(
                                child: MainText(
                                  'Developer Gateway',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: Text(
                                  'Enter authorized credentials to configure runtime endpoints and developer tools.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? Colors.white60
                                        : Colors.grey.shade600,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Username Input
                              const MainText(
                                'Username',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _usernameController,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: 'Enter username (e.g. admin)',
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? Colors.white38
                                        : Colors.grey.shade400,
                                  ),
                                  filled: true,
                                  fillColor: inputFill,
                                  prefixIcon: Icon(
                                    Icons.person_outline_rounded,
                                    size: 20,
                                    color: isDark
                                        ? Colors.white60
                                        : Colors.grey.shade600,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: borderColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: borderColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: MyColors.primaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter username';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Password Input
                              const MainText(
                                'Password',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _submit(context),
                                decoration: InputDecoration(
                                  hintText: 'Enter password',
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? Colors.white38
                                        : Colors.grey.shade400,
                                  ),
                                  filled: true,
                                  fillColor: inputFill,
                                  prefixIcon: Icon(
                                    Icons.lock_outline_rounded,
                                    size: 20,
                                    color: isDark
                                        ? Colors.white60
                                        : Colors.grey.shade600,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 20,
                                      color: isDark
                                          ? Colors.white60
                                          : Colors.grey.shade600,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: borderColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: borderColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: MyColors.primaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter password';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 28),

                              // Submit Button
                              MainButton(
                                height: 48,
                                borderRadius: 12,
                                backgroundColor: MyColors.primaryColor,
                                onPressed: () => _submit(context),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Login Provider',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Security Notice
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: inputFill,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.shield_outlined,
                                      size: 16,
                                      color: isDark
                                          ? Colors.white54
                                          : Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Restricted access. All actions are logged locally.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark
                                              ? Colors.white54
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../cubit/developer_cubit.dart';
import '../../desktop/switch_mode/developer_auth_desktop_screen.dart';
import 'developer_screen.dart';

class DeveloperAuthScreen extends StatefulWidget {
  const DeveloperAuthScreen({super.key});

  @override
  State<DeveloperAuthScreen> createState() => _DeveloperAuthScreenState();
}

class _DeveloperAuthScreenState extends State<DeveloperAuthScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (AppResponsive.isDesktop(context) || constraints.maxWidth >= 768) {
          return const DeveloperAuthDesktopScreen();
        }

        return BlocProvider(
          create: (context) => DeveloperCubit(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Developer Gateway'),
              backgroundColor: MyColors.primaryColor,
            ),
            body: BlocConsumer<DeveloperCubit, DeveloperState>(
              listener: (context, state) {
                if (state is DeveloperAuthSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeveloperScreen(),
                    ),
                  );
                } else if (state is DeveloperAuthFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.developer_mode,
                          size: 80,
                          color: MyColors.primaryColor,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<DeveloperCubit>().login(
                                  _usernameController.text,
                                  _passwordController.text,
                                );
                              }
                            },
                            child: const Text(
                              'Login Provider',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:putevod/view/screens/main_menu_screen.dart';
import 'package:putevod/view/screens/password_recovery_screen.dart';
import 'package:putevod/view/screens/registration_screen.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/view-model/login_view_model.dart';

import '../widgets/password_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                const Image(
                  width: 350,
                  image: AssetImage('assets/images/login_image.png'),
                ),
                const SizedBox(height: 60),
                const Text(
                  'Войти',
                  style: TextStyle(
                    color: Color(0xFF232323),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NotoSans',
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Войдите, чтобы продолжить',
                  style: TextStyle(
                    color: Color(0xFF959595),
                    fontSize: 21,
                    fontFamily: 'NotoSans',
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  onChanged: (value) => viewModel.setEmail(value),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(
                      color: Color(0xFF9A9A9A),
                      fontFamily: 'NotoSans',
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFFD9D9D9),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.accent,
                        width: 2.0,
                      ),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: AppColors.accent,
                      fontFamily: 'NotoSans',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                PasswordField(
                    onChanged: (value) => viewModel.setPassword(value),
                    label: 'Пароль'
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PasswordRecoveryScreen()),
                      );
                    },
                    child: const Text(
                      'Забыли пароль?',
                      style: TextStyle(
                        color: Color(0xFF232323),
                        fontSize: 16,
                        fontFamily: 'NotoSans',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Показываем ошибки если есть
                if (viewModel.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            viewModel.errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ElevatedButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          final success = await viewModel.login();
                          if (success && context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const MainMenuScreen()),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    minimumSize: const Size(343, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: viewModel.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Войти',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontFamily: 'NotoSans',
                          ),
                        ),
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Color(0xFFD9D9D9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                    );
                  },
                  child: Center(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Color(0xFF232323),
                          fontSize: 18,
                          fontFamily: 'NotoSans',
                        ),
                        children: [
                          TextSpan(text: 'Нет аккаунта? '),
                          TextSpan(
                            text: 'Зарегистрируйтесь',
                            style: TextStyle(
                              color: Color(0xFF367AFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(
                  color: Color(0xFF494949),
                  thickness: 5,
                  indent: 130,
                  endIndent: 130,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
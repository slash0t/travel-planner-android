import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:putevod/view/screens/login_screen.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/view-model/password_recovery_view_model.dart';

import '../widgets/password_field.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PasswordRecoveryViewModel>(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Image(
                  width: 350,
                  height: 232.98,
                  image: AssetImage('assets/images/password_recovery_image.png'),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Восстановление пароля',
                  style: TextStyle(
                    color: Color(0xFF232323),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NotoSans',
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Введите email для восстановления пароля',
                  style: TextStyle(
                    color: Color(0xFF959595),
                    fontSize: 18,
                    fontFamily: 'NotoSans',
                  ),
                ),
                const SizedBox(height: 30),
                if (viewModel.errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      viewModel.errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'NotoSans',
                      ),
                    ),
                  ),
                if (viewModel.successMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      viewModel.successMessage,
                      style: const TextStyle(
                        color: Colors.green,
                        fontFamily: 'NotoSans',
                      ),
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
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
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: viewModel.isLoading 
                          ? null 
                          : () async {
                              await viewModel.sendResetCode();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        minimumSize: const Size(120, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Отправить код',
                        style: TextStyle(
                          color: Color(0xFF367AFF),
                          fontFamily: 'NotoSans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) => viewModel.setCode(value),
                  decoration: InputDecoration(
                    labelText: 'Код подтверждения',
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
                    onChanged: (value) => viewModel.setNewPassword(value),
                    label: 'Новый пароль'
                ),
                const SizedBox(height: 20),
                PasswordField(
                    onChanged: (value) => viewModel.setConfirmPassword(value),
                    label: 'Подтвердите новый пароль'
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          final success = await viewModel.resetPassword();
                          if (success && context.mounted) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: AppColors.background,
                                  title: const Text(
                                    'Пароль изменен',
                                    style: TextStyle(
                                      fontFamily: 'NotoSans',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: const Text(
                                    'Ваш пароль был успешно изменен.',
                                    style: TextStyle(
                                      fontFamily: 'NotoSans',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const LoginScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'ОК',
                                        style: TextStyle(
                                          color: AppColors.accent,
                                          fontFamily: 'NotoSans',
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
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
                  child: const Text(
                    'Восстановить пароль',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontFamily: 'NotoSans',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                          TextSpan(text: 'Вспомнили пароль? '),
                          TextSpan(
                            text: 'Войти',
                            style: TextStyle(
                              color: AppColors.link,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
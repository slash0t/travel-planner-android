import 'package:flutter/material.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/view/screens/login_screen.dart';
import 'package:putevod/view/screens/main_menu_screen.dart';
import 'package:putevod/view/screens/registration_screen.dart';

/// The original main screen of the application displaying welcome content
class MainScreen extends StatelessWidget {
  /// Creates an instance of the original main screen
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 180),
            const Center(
              child: Image(
                width: 378,
                height: 108,
                image: AssetImage('assets/images/wide_logo.png'),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Планируй. Делись. Вдохновляй.',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 18,
                fontFamily: 'NotoSans',
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      minimumSize: const Size(343, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Войти',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 22,
                        fontFamily: 'NotoSans',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      minimumSize: const Size(343, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Зарегистрироваться',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 22,
                        fontFamily: 'NotoSans',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'или',
                    style: TextStyle(
                      color: Color(0xFF6E6E6E),
                      fontSize: 24,
                      fontFamily: 'NotoSans',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to main navigation screen as guest
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const MainMenuScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(343, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Продолжить как гость',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 22,
                        fontFamily: 'NotoSans',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Divider(
              color: AppColors.text.withOpacity(0.6),
              thickness: 5,
              indent: 130,
              endIndent: 130,
            ),
          ],
        ),
      ),
    );
  }
} 
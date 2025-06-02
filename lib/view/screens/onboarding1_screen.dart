import 'package:flutter/material.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/shared_prefs_manager.dart';
import 'package:putevod/view/screens/main_screen.dart';
import 'package:putevod/view/screens/onboarding2_screen.dart';

/// First onboarding screen displayed on the first app launch
class Onboarding1Screen extends StatelessWidget {
  /// Creates the first onboarding screen
  const Onboarding1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Illustration
                    SizedBox(
                      width: 225,
                      height: 225,
                      child: Image.asset(
                        'assets/images/onboarding_image_1.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Indicator dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 15,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    // Title text
                    const Text(
                      'Добро пожаловать!',
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Description text
                    const Text(
                      'Отправляйтесь в путь вместе с Путеводом и откройте для себя мир новых мест, возможностей и впечатлений!',
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    // Buttons row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Skip button
                        TextButton(
                          onPressed: () async {
                            // Mark onboarding as completed
                            await SharedPrefsManager.setFirstLaunchComplete();
                            
                            if (context.mounted) {
                              // Navigate to main screen and remove all previous routes
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const MainScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                          child: const Text(
                            'Пропустить',
                            style: TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Next button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const Onboarding2Screen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 32,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Далее',
                            style: TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
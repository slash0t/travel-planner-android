import 'package:flutter/material.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/shared_prefs_manager.dart';
import 'package:putevod/model/analytics_service.dart';
import 'package:putevod/view/screens/main_screen.dart';

/// Third and final onboarding screen
class Onboarding3Screen extends StatelessWidget {
  /// Creates the third onboarding screen
  const Onboarding3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    // Трекинг просмотра экрана онбординга
    AnalyticsService.trackOnboardingView('onboarding3');
    
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
                        'assets/images/onboarding_image_3.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Indicator dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                        const SizedBox(width: 10),
                        Container(
                          width: 18,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    // Title text
                    const Text(
                      'Наслаждайтесь поездкой',
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
                      'Положитесь на Путевода с составлением планов Вашей поездки! Списки дел, расписания походов по достопримечательностям, даты отправления и не только Вы можете отслеживать с помощью нашего приложения!',
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Трекинг возврата назад
                            AnalyticsService.trackCustomEvent('onboarding_back', {'from_screen': 'onboarding3'});
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Назад',
                            style: TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // Трекинг завершения онбординга
                            AnalyticsService.trackOnboardingCompleted();
                            
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
                            'Начать',
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
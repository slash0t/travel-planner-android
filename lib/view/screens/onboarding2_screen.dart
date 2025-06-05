import 'package:flutter/material.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/shared_prefs_manager.dart';
import 'package:putevod/model/analytics_service.dart';
import 'package:putevod/view/screens/main_screen.dart';
import 'package:putevod/view/screens/onboarding3_screen.dart';

/// Second onboarding screen displayed after the first one
class Onboarding2Screen extends StatelessWidget {
  /// Creates the second onboarding screen
  const Onboarding2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    // Трекинг просмотра экрана онбординга
    AnalyticsService.trackOnboardingView('onboarding2');
    
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
                        'assets/images/onboarding_image_2.png',
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
                      ],
                    ),
                    const SizedBox(height: 36),
                    // Title text
                    const Text(
                      'Выберите место назначения',
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
                      'Наша цель - помочь Вам выбрать именно то место, где время пролетит незаметно и остануться только приятные воспоминания. Учитывая все Ваши требования и пожелания, Путевод найдёт идеальный маршрут!',
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
                            AnalyticsService.trackCustomEvent('onboarding_back', {'from_screen': 'onboarding2'});
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
                          onPressed: () {
                            // Трекинг перехода к следующему экрану
                            AnalyticsService.trackCustomEvent('onboarding_next', {'from_screen': 'onboarding2'});
                            
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const Onboarding3Screen(),
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
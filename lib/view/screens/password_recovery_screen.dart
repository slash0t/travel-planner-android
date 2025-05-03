import 'package:flutter/material.dart';
import 'package:putevod/view/screens/login_screen.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7E4DC),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
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
                              color: Color(0xFFEA2517),
                              width: 2.0,
                            ),
                          ),
                          floatingLabelStyle: const TextStyle(
                            color: Color(0xFFEA2517),
                            fontFamily: 'NotoSans',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Handle send code
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
                        color: Color(0xFFEA2517),
                        width: 2.0,
                      ),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: Color(0xFFEA2517),
                      fontFamily: 'NotoSans',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Новый пароль',
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
                        color: Color(0xFFEA2517),
                        width: 2.0,
                      ),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: Color(0xFFEA2517),
                      fontFamily: 'NotoSans',
                    ),
                    suffixIcon: const Icon(
                      Icons.visibility_off,
                      color: Color(0xFF9A9A9A),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Подтвердите новый пароль',
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
                        color: Color(0xFFEA2517),
                        width: 2.0,
                      ),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: Color(0xFFEA2517),
                      fontFamily: 'NotoSans',
                    ),
                    suffixIcon: const Icon(
                      Icons.visibility_off,
                      color: Color(0xFF9A9A9A),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle password recovery
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: const Color(0xFFE7E4DC),
                          title: const Text(
                            'Письмо отправлено',
                            style: TextStyle(
                              fontFamily: 'NotoSans',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: const Text(
                            'На указанный email отправлено письмо с инструкциями по восстановлению пароля.',
                            style: TextStyle(
                              fontFamily: 'NotoSans',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'ОК',
                                style: TextStyle(
                                  color: Color(0xFFEA2517),
                                  fontFamily: 'NotoSans',
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEA2525),
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
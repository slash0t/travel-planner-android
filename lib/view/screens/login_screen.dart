import 'package:flutter/material.dart';
import 'package:putevod/view/screens/password_recovery_screen.dart';
import 'package:putevod/view/screens/registration_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7E4DC),
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
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Пароль',
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
                ElevatedButton(
                  onPressed: () {
                    // Handle login
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEA2525),
                    minimumSize: const Size(343, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
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
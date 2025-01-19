import 'package:flutter/material.dart';
import '../../utils/my_colors.dart';
import '../../utils/my_images.dart';
import '../../services/database_helper.dart';
import '../Home/home_view.dart';
import '../Register/register_view.dart';
import '../widgets/basic_text_form_field.dart';
import '../widgets/password_text_form_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  static const EdgeInsets formFieldPadding = EdgeInsets.symmetric(vertical: 5, horizontal: 20);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: MyColors.whiteColor,
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 62),
              Image.asset(MyImages.logo),

              const SizedBox(height: 21),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: MyColors.purpleColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: formFieldPadding,
                child: BasicTextFormField(
                  hintText: "Email",
                  prefixIcon: Icons.person_outline,
                  controller: emailController,
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: formFieldPadding,
                child: PasswordTextFormField(
                  hintText: "Password",
                  controller: passwordController,
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterView(),
                        ),
                      );
                    },
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(
                        fontSize: 14,
                        color: MyColors.purpleColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: formFieldPadding,
                child: ElevatedButton(
                  onPressed: () async {
                    // Logika logowania
                    final user = await DatabaseHelper.instance.loginUser(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );

                    if (user != null) {
                      // Przekierowanie do HomeView po poprawnym logowaniu
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeView()),
                      );
                    } else {
                      // Wyświetlenie błędu logowania
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Invalid email or password")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: MyColors.purpleColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const Spacer(), // Przestrzeń zajmująca resztę miejsca między górą a dołem

              // "Don't have an account? Sign up" wyrównane na dole ekranu
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: GestureDetector(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      children: [
                        const TextSpan(
                          text: 'Don\'t have an account? ',
                        ),
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MyColors.purpleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterView(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

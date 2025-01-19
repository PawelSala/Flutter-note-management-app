import 'package:flutter/material.dart';
import '../../utils/my_colors.dart';
import '../../utils/my_images.dart';
import '../../models/user.dart';
import '../../services/database_helper.dart';
import '../widgets/basic_text_form_field.dart';
import '../widgets/password_text_form_field.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  // Kontrolery tekstowe do przechowywania danych wejściowych
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.whiteColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.purple),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 0, top: 0),
              child: Image.asset(
                MyImages.circle,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        body: Container(
          color: MyColors.whiteColor,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tytuł
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: MyColors.purpleColor,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Pole Username
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: BasicTextFormField(
                  hintText: "Username",
                  prefixIcon: Icons.person_outline,
                  controller: usernameController,
                ),
              ),
              const SizedBox(height: 20),

              // Pole Email
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: BasicTextFormField(
                  hintText: "Email",
                  prefixIcon: Icons.email_outlined,
                  controller: emailController,
                ),
              ),
              const SizedBox(height: 20),

              // Pole Password
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: PasswordTextFormField(
                  hintText: "Password",
                  controller: passwordController,
                ),
              ),
              const SizedBox(height: 20),

              // Pole Confirm Password
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: PasswordTextFormField(
                  hintText: "Confirm password",
                  controller: confirmPasswordController,
                ),
              ),
              const SizedBox(height: 30),

              // Przycisk Sign Up
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton(
                  onPressed: () async {
                    // Walidacja hasła
                    if (passwordController.text != confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Passwords do not match")),
                      );
                      return;
                    }

                    // Tworzenie obiektu użytkownika
                    final user = User(
                      username: usernameController.text.trim(),
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );

                    try {
                      // Dodanie użytkownika do bazy danych
                      await DatabaseHelper.instance.registerUser(user);

                      // Wyświetlenie komunikatu o sukcesie
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Registration successful!")),
                      );

                      // Powrót do widoku logowania
                      Navigator.pop(context);
                    } catch (e) {
                      // Obsługa błędu (np. powielony email)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
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
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const Spacer(),

              // Tekst "Already have an account? Sign in"
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Powrót do poprzedniego widoku
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        children: [
                          const TextSpan(
                            text: 'Already have an account? ',
                          ),
                          TextSpan(
                            text: 'Sign in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyColors.purpleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

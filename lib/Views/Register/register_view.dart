import 'package:flutter/material.dart';
import '../../utils/my_colors.dart';
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

  // Klucz formularza do walidacji
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Prosta funkcja walidująca adres e-mail
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    // Proste wyrażenie regularne do walidacji e-maila
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

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
        ),
        body: SingleChildScrollView(
          child: Container(
            color: MyColors.whiteColor,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username cannot be empty';
                        }
                        return null;
                      },
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
                      validator: validateEmail,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Pole Password
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: PasswordTextFormField(
                      hintText: "Password",
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Pole Confirm Password
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: PasswordTextFormField(
                      hintText: "Confirm password",
                      controller: confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm password cannot be empty';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Przycisk Sign Up
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Sprawdzamy, czy wszystkie pola są poprawne
                        if (_formKey.currentState!.validate()) {
                          final user = User(
                            username: usernameController.text.trim(),
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );

                          try {
                            // Rejestracja użytkownika w SQLite
                            await DatabaseHelper.instance.registerUser(user);

                            // Powiadomienie o sukcesie
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Registration successful!")),
                            );

                            // Powrót do widoku logowania
                            Navigator.pop(context);
                          } catch (e) {
                            // Obsługa błędów (np. istniejący e-mail)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: $e")),
                            );
                          }
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

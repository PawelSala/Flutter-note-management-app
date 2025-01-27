import 'package:flutter/material.dart';
import '../../utils/my_colors.dart';
import '../../models/user.dart';
import '../../services/database_helper.dart';
import '../widgets/basic_text_form_field.dart';
import '../widgets/password_text_form_field.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});


  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }

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


                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ElevatedButton(
                      onPressed: () async {

                        if (_formKey.currentState!.validate()) {
                          final user = User(
                            username: usernameController.text.trim(),
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );

                          try {

                            await DatabaseHelper.instance.registerUser(user);


                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Registration successful!")),
                            );


                            Navigator.pop(context);
                          } catch (e) {

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

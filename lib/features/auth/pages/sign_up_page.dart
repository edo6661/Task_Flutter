import 'package:flutter/material.dart';
import 'package:frontend/core/common/extent.dart';
import 'package:frontend/core/utils/log_service.dart';
import 'package:frontend/features/auth/pages/sign_in_page.dart';
import 'package:frontend/ui/components/center_column_container.dart';
import 'package:frontend/ui/components/main_text.dart';
import 'package:frontend/ui/components/main_text_field.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpPage());
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool obscurePassword = false;
  String? passwordError;

  void signUp() {
    if (formKey.currentState!.validate()) {
      LogService.d("Sign Up");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CenterColumnContainer(
            isVerticallyCentered: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20,
              children: [
                MainText(text: "Sign Up", extent: ExtraLarge()),
                Form(
                  key: formKey,
                  child: Column(
                    spacing: 16,
                    children: [
                      MainTextField(
                        controller: nameController,
                        hintText: "Name",
                        leadingIcon: Icon(Icons.person),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Name cannot be empty";
                          }
                          return null;
                        },
                      ),
                      MainTextField(
                        controller: emailController,
                        hintText: "Email",
                        leadingIcon: Icon(Icons.email),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Email cannot be empty";
                          }
                          return null;
                        },
                      ),
                      MainTextField(
                        controller: passwordController,
                        hintText: "Password",
                        leadingIcon: Icon(Icons.lock),
                        trailingIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            )),
                        obscureText: !obscurePassword,
                      ),
                      ElevatedButton(
                          onPressed: signUp,
                          child: MainText(text: "Sign Up", extent: Large())),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(SignInPage.route());
                  },
                  child: RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        text: "Already have an account? ",
                        children: const [
                          TextSpan(
                              text: "Sign In",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline))
                        ]),
                  ),
                ),
              ],
            )));
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

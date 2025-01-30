import 'package:flutter/material.dart';
import 'package:frontend/core/common/extent.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/pages/sign_up_page.dart';
import 'package:frontend/features/home/pages/home_page.dart';
import 'package:frontend/ui/components/center_circular_loading.dart';
import 'package:frontend/ui/components/center_column_container.dart';
import 'package:frontend/ui/components/main_elevated_button.dart';
import 'package:frontend/ui/components/main_text.dart';
import 'package:frontend/ui/components/main_text_field.dart';
import "package:flutter_bloc/flutter_bloc.dart";

class SignInPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignInPage());

  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool obscurePassword = false;
  String? passwordError;

  void signIn() async {
    if (formKey.currentState!.validate()) {
      await context.read<AuthCubit>().login(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is AuthLogin) {
          Navigator.of(context)
              .pushAndRemoveUntil(HomePage.route(), (_) => false);
        }
      },
      builder: (context, state) {
        return Stack(children: [
          CenterColumnContainer(
              isVerticallyCentered: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20,
                children: [
                  MainText(text: "Sign In", extent: ExtraLarge()),
                  Form(
                    key: formKey,
                    child: Column(
                      spacing: 16,
                      children: [
                        MainTextField(
                          controller: emailController,
                          hintText: "Email",
                          leadingIcon: Icon(Icons.person),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Email cannot be empty";
                            }
                            return null;
                          },
                          isEnabled: (state is! AuthLoading),
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
                          isEnabled: (state is! AuthLoading),
                        ),
                        MainElevatedButton(
                          onPressed: signIn,
                          text: "Sign In",
                          isLoading: state is AuthLoading,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(SignUpPage.route());
                    },
                    child: RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          text: "Don't have an account? ",
                          children: const [
                            TextSpan(
                                text: "Sign Up",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline))
                          ]),
                    ),
                  ),
                ],
              )),
          if (state is AuthLoading) CenterCircularLoading(),
        ]);
      },
    ));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

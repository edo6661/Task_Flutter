import 'package:flutter/material.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/pages/sign_in_page.dart';
import 'package:frontend/ui/components/main_elevated_button.dart';
import 'package:frontend/ui/components/main_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Column(
          children: [
            MainText(text: "My Ass"),
            MainElevatedButton(
                onPressed: () async {
                  context.read<AuthCubit>().logout();
                  Navigator.pushAndRemoveUntil(
                      context, SignInPage.route(), (_) => false);
                },
                text: "Logout")
          ],
        );
      },
    );
  }
}

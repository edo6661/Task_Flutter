import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/pages/sign_in_page.dart';
import 'package:frontend/features/home/pages/home_page.dart';
import 'package:frontend/ui/components/configuration_theme.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        // ! inputDecorationTheme: InputDecorationTheme, membuat agar semua input field memiliki textdecoration yang sama
        inputDecorationTheme: ConfigurationTheme.inputDecorationTheme,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: ConfigurationTheme.textTheme,

        elevatedButtonTheme: ConfigurationTheme.elevatedButtonTheme,
        useMaterial3: true,
        fontFamilyFallback: ['Poppins'],
      ),
      // ! kalo ga butuh listener / ga butuh untuk kasih snackbar, bisa pake BlocBuilder
      home: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoggedIn) {
            return const HomePage();
          }
          return const SignInPage();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

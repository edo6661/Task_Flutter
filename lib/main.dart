import 'package:flutter/material.dart';
import 'package:frontend/features/auth/pages/sign_up_page.dart';
import 'package:frontend/ui/components/configuration_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: const SignUpPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

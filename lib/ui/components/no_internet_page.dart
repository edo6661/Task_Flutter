import 'package:flutter/material.dart';
import 'package:frontend/ui/components/center_column_container.dart';
import 'package:frontend/ui/components/main_elevated_button.dart';

class NoInternetPage extends StatelessWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const NoInternetPage());
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CenterColumnContainer(
            child: Column(
          children: [
            Icon(Icons.wifi_off, size: 100, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              "Tidak ada koneksi internet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Pastikan perangkat kamu terhubung ke internet lalu coba lagi.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            MainElevatedButton(
              onPressed: Navigator.of(context).pop,
              text: "Coba lagi",
            ),
          ],
        )),
      ),
    );
  }
}

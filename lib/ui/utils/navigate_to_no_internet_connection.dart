import 'package:flutter/material.dart';
import 'package:frontend/ui/components/no_internet_page.dart';

void navigateToNoInternetConnection(
  BuildContext context,
) {
  if (ModalRoute.of(context)?.settings.name != "NoInternetPage") {
    Navigator.of(context).push(NoInternetPage.route());
  }
}

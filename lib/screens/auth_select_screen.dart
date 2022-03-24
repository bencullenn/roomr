import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roomr/model/auth_screen_settings.dart';
import 'package:roomr/routes/routes.dart';

class AuthSelectScreen extends StatelessWidget {
  AuthSelectScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    final screenSettings =
        ModalRoute.of(context)!.settings.arguments as AuthScreenSettings;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account or Login',
            style: Theme.of(context).textTheme.headline6),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            child: Text(
                "This action requires an account.\nPlease login or create an account to continue.",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          ),
          Padding(
              child: OutlinedButton(
                onPressed: () {
                  debugPrint('Received login click');
                  Get.toNamed(AppRoutes.login, arguments: screenSettings);
                },
                child: const Text('Login To Account'),
              ),
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10)),
          Padding(
              child: OutlinedButton(
                onPressed: () {
                  debugPrint('Received create Search post click');
                  Get.toNamed(AppRoutes.createAccount,
                      arguments: screenSettings);
                },
                child: Text('Create A New Account'),
              ),
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10)),
        ],
      )),
    );
  }
}

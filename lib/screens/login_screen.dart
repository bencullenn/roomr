import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:roomr/blocs/login/login_bloc.dart';
import 'package:roomr/model/auth_screen_settings.dart';
import 'package:roomr/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final authSettings =
        ModalRoute.of(context)!.settings.arguments as AuthScreenSettings;

    //print('Return Screen:' + returnScreen);
    print('Route:' + ModalRoute.of(context).toString());
    return BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
      print('State:' + state.toString());
      if (state is LoginError) {
        print('State is login error');
        _showAlertDialog('Login Error', state.errorMessage);
      } else if (state is LoginSuccess) {
        print('State is login success');
        if (authSettings.returnScreen == null) {
          if (authSettings.destinationScreen != null) {
            Get.toNamed(authSettings.destinationScreen!);
          }
        } else {
          Navigator.popUntil(
              context, ModalRoute.withName(authSettings.returnScreen!));
        }
      }
    }, builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Login', style: Theme.of(context).textTheme.headline6),
          ),
          body: Center(
              child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    //minHeight: 50.0,
                    maxWidth: 500.0,
                  ),
                  child: ListView(children: [
                    Padding(
                        child: Text(
                          'Login to your existing account',
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    Padding(
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), hintText: 'Email'),
                          controller: emailController,
                          autocorrect: false,
                        ),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    Padding(
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Password'),
                          controller: passwordController,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                        ),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                    Padding(
                        child: OutlinedButton(
                          onPressed: () {
                            debugPrint('Received login click');
                            BlocProvider.of<LoginBloc>(context).add(LogInEmail(
                                emailController.text, passwordController.text));
                          },
                          child: const Text('Login'),
                        ),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5)),
                  ]))));
    });
  }

  Future<void> _showAlertDialog(String title, String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

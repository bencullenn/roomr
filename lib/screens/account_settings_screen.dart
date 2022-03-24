import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roomr/blocs/app_settings/app_settings_bloc.dart';
import 'package:roomr/model/auth_screen_settings.dart';
import 'package:roomr/routes/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountSettingsScreen extends StatefulWidget {
  AccountSettingsScreen();

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  _AccountSettingsScreenState();

  Future<void> _showErrorDialog(String title, String content) async {
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

  Future<void> deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Account', style: Theme.of(context).textTheme.headline6),
          centerTitle: true,
        ),
        body: BlocBuilder<AppSettingsBloc, AppSettingsState>(
            builder: (context, state) {
          if (state is Authenticated) {
            return Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      //minHeight: 50.0,
                      maxWidth: 500.0,
                    ),
                    child: Container(
                        child: ListView(children: [
                      Padding(
                          child: OutlinedButton(
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                            ),
                            onPressed: () {
                              debugPrint('Received edit account click');
                              Get.toNamed(AppRoutes.editAccount);
                            },
                            child: Text('Edit Account Details'),
                          ),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5)),
                      Padding(
                          child: OutlinedButton(
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                            ),
                            onPressed: () {
                              debugPrint('Received logout click');
                              BlocProvider.of<AppSettingsBloc>(context)
                                  .add(AuthLogoutRequested());
                            },
                            child: Text(
                              'Log Out',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 10)),
                      /*OutlinedButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                        ),
                        onPressed: () {
                          debugPrint('Received delete account click');
                          _showDeleteDialog();
                        },
                        child: Text('Delete Account'),
                      ),*/
                    ]))));
          } else {
            return Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      //minHeight: 50.0,
                      maxWidth: 500.0,
                    ),
                    child: Container(
                        child: ListView(children: [
                      Padding(
                          child: OutlinedButton(
                            onPressed: () {
                              debugPrint('Login clicked');
                              Get.toNamed(AppRoutes.login,
                                  arguments: AuthScreenSettings(
                                      returnScreen: AppRoutes.home));
                            },
                            child: const Text('Login'),
                          ),
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 5)),
                      Padding(
                          child: OutlinedButton(
                            onPressed: () {
                              debugPrint('Create Account clicked');
                              Get.toNamed(AppRoutes.createAccount,
                                  arguments: AuthScreenSettings(
                                      returnScreen: AppRoutes.home));
                            },
                            child: const Text('Create Account'),
                          ),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5)),
                    ]))));
          }
        }));
  }
}

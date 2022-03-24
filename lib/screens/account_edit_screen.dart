import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:roomr/blocs/account_edit/account_edit_bloc.dart';
import 'package:roomr/model/account.dart';

import '../widgets/loading_dialog_widget.dart';

class AccountEditScreen extends StatefulWidget {
  AccountEditScreen();

  @override
  _AccountEditScreenState createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends State<AccountEditScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  var prefContactMethod = 'Email';

  void _updateAccount() async {
    try {
      BlocProvider.of<AccountEditBloc>(context).add(UpdateAccount(
          email: emailController.text,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          mobileNumber: phoneController.text,
          prefContactMethod: prefContactMethod));
    } catch (error) {
      _showErrorDialog(
          'Update Error', 'Error updating account:' + error.toString());
    }
  }

  void _updateFields(Account account) async {
    print("Updating fields");
    setState(() {
      emailController.text = account.email;
      firstNameController.text = account.firstName;
      lastNameController.text = account.lastName;
      phoneController.text = account.mobileNumber;
      prefContactMethod = account.prefContactMethod;
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AccountEditBloc>(context).add(GetAccountForCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountEditBloc, AccountEditState>(
        listener: (context, state) {
      if (state is AccountUpdateInProgress) {
        showUpdatingAccountDialog(context);
      } else if (state is AccountUpdateSuccess) {
        Navigator.pop(context);
        _showSuccessDialog('Account Updated', 'Account successfully updated.');
      } else if (state is AccountUpdateError) {
        Navigator.pop(context);
        _showErrorDialog(
            'Update Error', 'Error updating account:' + state.errorMessage);
      } else if (state is AccountLoaded) {
        _updateFields(state.account);
      }
    }, builder: (context, state) {
      print("State:" + state.toString());
      if (state is LoadingAccount) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Edit Account', style:  Theme.of(context).textTheme.headline6),
            leading: Builder(
              builder: (BuildContext context) {
                return TextButton(
                  onPressed: () {
                    print('Canceling account update');
                    Navigator.maybePop(context);
                  },
                  child: Text("Cancel"),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                );
              },
            ),
            leadingWidth: 100,
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                //minHeight: 50.0,
                maxWidth: 500.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Loading account details"),
                  CircularProgressIndicator()
                ]),
          )),
        );
      } else if (state is AccountLoadError) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Edit Account', style:  Theme.of(context).textTheme.headline6),
            leading: Builder(
              builder: (BuildContext context) {
                return TextButton(
                  onPressed: () {
                    print('Canceling account update');
                    Navigator.maybePop(context);
                  },
                  child: Text("Cancel"),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                );
              },
            ),
            leadingWidth: 100,
          ),
          body:ConstrainedBox(
      constraints: const BoxConstraints(
      //minHeight: 50.0,
      maxWidth: 500.0,
      ),
      child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      "Error loading account details. Try logging out and back in."),
                ]),
          )),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: Text('Edit Account', style:  Theme.of(context).textTheme.headline6),
            leading: Builder(
              builder: (BuildContext context) {
                return TextButton(
                  onPressed: () {
                    print('Canceling account update');
                    Navigator.maybePop(context);
                  },
                  child: Text("Cancel"),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                );
              },
            ),
            leadingWidth: 100,
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: TextButton(
                  onPressed: () {
                    print('Updating account');
                    _updateAccount();
                  },
                  child: Text("Save"),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                ),
              )
            ],
          ),
          body: Center(
            child:ConstrainedBox(
      constraints: const BoxConstraints(
      //minHeight: 50.0,
      maxWidth: 500.0,
      ),
      child: ListView(children: [
              Center(
                  child: Padding(
                      child: Text('Create a new account using your email'),
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10))),
              Padding(
                  child: Text("First Name"),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
              Padding(
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'First Name'),
                    controller: firstNameController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
              Padding(
                  child: Text("Last Name"),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
              Padding(
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Last Name'),
                    controller: lastNameController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
              Padding(
                  child: Text(
                      "Contact Email Address \n(does not change your login email address)"),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
              Padding(
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Email'),
                    controller: emailController,
                    autocorrect: false,
                    enableSuggestions: false,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value);
                      if (emailValid == false) {
                        return 'Please input a valid email';
                      }
                      return null;
                    },
                  ),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
              Padding(
                  child: Text("Mobile Phone Number"),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
              Padding(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Cell Phone Number',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(.3)),
                      errorStyle: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    autocorrect: false,
                    enableSuggestions: false,
                    inputFormatters: [
                      PhoneInputFormatter(
                        allowEndlessPhone: false,
                      )
                    ],
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your cell phone number';
                      }
                      return null;
                    },
                  ),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Row(
                    children: [
                      Text('Preferred Contact Method: '),
                      DropdownButton<String>(
                        value: prefContactMethod,
                        elevation: 16,
                        style: const TextStyle(color: Colors.blue),
                        underline: Container(
                          height: 2,
                          color: Colors.blueAccent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            prefContactMethod = newValue!;
                          });
                        },
                        items: <String>['Email', 'Text-Message', 'Phone Call']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  )),
              Padding(
                  child: Text(
                      'This is how people will contact you about your listings'),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10)),
            ]),
          )),
        );
      }
    });
  }

  Future<void> _showSuccessDialog(String title, String content) async {
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
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
          ],
        );
      },
    );
  }

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

  showUpdatingAccountDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialogWidget("Updating Listing");
        });
  }
}

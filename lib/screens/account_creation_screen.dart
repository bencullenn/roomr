import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:roomr/blocs/sign_up/sign_up_bloc.dart';
import 'package:roomr/model/auth_screen_settings.dart';
import '../widgets/loading_dialog_widget.dart';
import '../widgets/picker_widget.dart';

class AccountCreationScreen extends StatefulWidget {
  AccountCreationScreen({Key? key}) : super(key: key);

  @override
  _AccountCreationScreenState createState() => _AccountCreationScreenState();
}

class _AccountCreationScreenState extends State<AccountCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final otherReferralMethodController = TextEditingController();
  final _phoneController = TextEditingController();
  var prefContactMethod = 'Email';
  bool passwordVisible = false;
  bool passwordConfirmVisible = false;

  //PhoneNumberUtil phoneUtil = PhoneNumberUtil();
  //RegionInfo region = RegionInfo(name: "United States", code: "US", prefix: 1);
  String referralMethod = "N/A";
  late TextEditingController phoneNumberController = TextEditingController();

  _AccountCreationScreenState() {
    /*phoneNumberController = PhoneNumberEditingController.fromValue(
        phoneUtil, phoneNumberController.value,
        regionCode: region.code, behavior: PhoneInputBehavior.strict);*/
  }

  @override
  Widget build(BuildContext context) {
    final authSettings =
        ModalRoute.of(context)!.settings.arguments as AuthScreenSettings;

    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpInProgress) {
          showCreatingAccountDialog(context);
        } else if (state is SignUpError) {
          Navigator.pop(context);
          print('State is sign up error');
          _showErrorDialog('Sign Up Error', state.errorMessage);
        } else if (state is SignUpSuccess) {
          Navigator.pop(context);
          print('State is sign up success');
          //_showSuccessDialog('Sign Up Success', "Sign up was successful");
          if (authSettings.returnScreen == null) {
            if (authSettings.destinationScreen != null) {
              Get.toNamed(authSettings.destinationScreen!);
            }
          } else {
            Navigator.popUntil(
                context, ModalRoute.withName(authSettings.returnScreen!));
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Create Account',
                  style: Theme.of(context).textTheme.headline6),
            ),
            body: Form(
                key: _formKey,
                child: Center(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          //minHeight: 50.0,
                          maxWidth: 500.0,
                        ),
                        child: SingleChildScrollView(
                            child: Column(children: [
                          Center(
                              child: Padding(
                                  child: Text(
                                    'Basic Info',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  padding:
                                      EdgeInsets.fromLTRB(10, 10, 10, 10))),
                          Padding(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Email'),
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
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toggle the state of passwordVisible variable
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                                controller: passwordController,
                                obscureText: !passwordVisible,
                                enableSuggestions: false,
                                autocorrect: false,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  return null;
                                },
                              ),
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                          Padding(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Re-enter Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      passwordConfirmVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toggle the state of passwordVisible variable
                                      setState(() {
                                        passwordConfirmVisible =
                                            !passwordConfirmVisible;
                                      });
                                    },
                                  ),
                                ),
                                controller: passwordConfirmController,
                                obscureText: !passwordConfirmVisible,
                                enableSuggestions: false,
                                autocorrect: false,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please re-enter your password';
                                  }
                                  return null;
                                },
                              ),
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                          Padding(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'First Name'),
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
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Last Name'),
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
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Cell Phone Number',
                                  hintStyle: TextStyle(
                                      color: Colors.black.withOpacity(.3)),
                                  errorStyle: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                controller: _phoneController,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your cell phone number';
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  PhoneInputFormatter(
                                    allowEndlessPhone: false,
                                  )
                                ],
                              ),
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                          const Divider(
                            height: 20,
                            thickness: 5,
                            indent: 5,
                            endIndent: 5,
                          ),
                          Center(
                              child: Padding(
                                  child: Text(
                                    'Contact Options',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  padding:
                                      EdgeInsets.fromLTRB(10, 10, 10, 10))),
                          Padding(
                              child: Text(
                                  'This is how people will contact you about your listings'),
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 5)),
                          Padding(
                              child: PickerWidget(
                                  title: 'Listing Contact Method: ',
                                  valueList: ['Email', 'Text-Message'],
                                  updateFunction: (value) {
                                    setState(() {
                                      prefContactMethod = value;
                                    });
                                  }),
                              padding: EdgeInsets.fromLTRB(20, 10, 0, 10)),
                          Padding(
                              child: PickerWidget(
                                  title: 'How did you hear about us?  ',
                                  valueList: [
                                    'N/A',
                                    'Instagram',
                                    'Facebook',
                                    'Friend/Word of Mouth',
                                    'Other'
                                  ],
                                  updateFunction: (value) {
                                    setState(() {
                                      referralMethod = value;
                                    });
                                  }),
                              padding: EdgeInsets.fromLTRB(20, 10, 0, 10)),
                          if (referralMethod == 'Other')
                            Padding(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'How did you hear about us?'),
                                  controller: otherReferralMethodController,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter how you heard about us';
                                    }
                                    return null;
                                  },
                                ),
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                          const Divider(
                            height: 20,
                            thickness: 5,
                            indent: 5,
                            endIndent: 5,
                          ),
                          Padding(
                              child: OutlinedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                ),
                                onPressed: () {
                                  debugPrint('Received create account click');

                                  //Check if passwords match
                                  if (passwordController.text !=
                                      passwordConfirmController.text) {
                                    print('Passwords don\'t match');
                                    _showErrorDialog('Passwords don\'t match',
                                        'Please check passwords and try again');
                                    return;
                                  }

                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    _createAccount();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Invalid Data. Check listing and try again.')),
                                    );
                                  }
                                },
                                child: const Text('Create Account',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 30)),
                        ]))))));
      },
    );
  }

  void _createAccount() async {
    try {
      /*PhoneNumber phoneNumber = await PhoneNumberUtil().parse("+1" +
          phoneNumberController.text.replaceAll(new RegExp(r'[^0-9]'), ''));*/
      BlocProvider.of<SignUpBloc>(context).add(SignUpEmail(
          emailController.text,
          passwordController.text,
          firstNameController.text,
          lastNameController.text,
          _phoneController.text,
          prefContactMethod,
          referralMethod,
          otherReferralMethodController.text));
    } catch (e) {
      print(e.toString());
    }
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
              child: const Text('Dismiss'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  showCreatingAccountDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialogWidget("Creating Account");
        });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }
}

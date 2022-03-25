import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:roomr/global_state/auth_state.dart';
import 'package:roomr/services/auth_service.dart';
import 'package:roomr/services/data_service.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  late final AuthState authState;
  late final AuthService authService;
  late final DataService dataService;
  String userUuid = '';

  SignUpBloc() : super(AwaitingSignUp()) {
    this.dataService = Get.find();
    this.authService = Get.find();
    this.authState = Get.find();

    on<SignUpEmail>((event, emit) async {
      emit(SignUpInProgress());
      print("Emitted sign up progress");
      String message =
      await authService.signUpWithEmail(event.email, event.password);
      print('Sign up message:' + message);
      if (message == 'Success') {
        print("Creating account");
        await authService.createAccount(
            email: event.email,
            firstName: event.firstName,
            lastName: event.lastName,
            mobileNumber: event.mobileNumber,
            prefContactMethod: event.prefContactMethod,
            referMethod: event.referMethod,
            otherReferMethodDescription: event.otherReferMethodDescription);
        print("Created account");
        emit(SignUpSuccess());
      } else if (message == 'weak-password') {
        emit(SignUpError('The password provided is too weak.'));
      } else if (message == 'email-already-in-use') {
        emit(SignUpError('An account already exists for given email.'));
      } else {
        emit(SignUpError('Error: ' + message));
      }
    });

    on<SignOut>((event, emit) async {
      emit(AwaitingSignUp());
    });
  }
}

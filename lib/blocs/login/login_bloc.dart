import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:roomr/global_state/auth_state.dart';
import 'package:roomr/services/auth_service.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late final AuthService authService;
  late final AuthState authState;

  LoginBloc() : super(AwaitingLogin()) {
    this.authService = Get.find();
    this.authState = Get.find();

    on<LogInEmail>((event, emit) async {
      print('Logging in');
      String message =
          await authService.logInWithEmail(event.email, event.password);
      print('Log In message:' + message);
      if (message == 'Success') {
        print('Sending login success');
        emit(LoginSuccess());
        emit(AwaitingLogin());
      } else if (message == 'user-not-found') {
        emit(LoginError('No user found for input email.'));
        emit(AwaitingLogin());
      } else if (message == 'wrong-password') {
        emit(LoginError('Wrong password provided for this email.'));
        emit(AwaitingLogin());
      } else {
        emit(LoginError('Error: ' + message));
        emit(AwaitingLogin());
      }
    });
    on<LogOut>((event, emit) async {
      emit(AwaitingLogin());
    });
  }
}

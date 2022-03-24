import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:roomr/model/account.dart';
import 'package:roomr/services/auth_service.dart';
import 'package:roomr/services/data_service.dart';
import 'package:roomr/global_state/auth_state.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  late final AuthService authService;
  late final DataService dataService;
  late final StreamSubscription<User?> _authSubscription;
  AuthState authState = Get.find();

  AppSettingsBloc() : super(UnknownAuthStatus()) {
    this.authService = Get.find();
    this.dataService = Get.find();
    this._authSubscription = authService.getUserStream().listen(_onUserChanged);

    //Convert events to states
    on<AuthStatusChanged>((event, emit) async {
      if (event.user != null) {
        Account? account =
        await dataService.getAccountForUserId(event.user!.uid);
        print("Found Account:" + account.toString());
        if (account != null) {
          authState.isAuthenticated = true;
          authState.currentUser = event.user;
          authState.currentAccount = account;
          emit(Authenticated(account, event.user));
        } else {
          print("Account is null");
          emit(Unauthenticated());
        }
      } else {
        emit(Unauthenticated());
      }
    });
    on<AuthLogoutRequested>((event, emit) async {
      authService.logOut();
      authState.isAuthenticated = false;
      authState.currentUser = null;
      authState.currentAccount = null;
      emit(Unauthenticated());
    });
  }

  void _onUserChanged(User? user) => add(AuthStatusChanged(user));

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}

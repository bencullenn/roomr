import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:roomr/global_state/auth_state.dart';
import 'package:roomr/model/account.dart';
import 'package:roomr/services/data_service.dart';
import 'package:get/get.dart';

part 'account_edit_event.dart';

part 'account_edit_state.dart';

class AccountEditBloc extends Bloc<AccountEditEvent, AccountEditState> {
  late final AuthState authState;
  late final DataService dataService;
  String userUuid = '';

  AccountEditBloc() : super(LoadingAccount()) {
    this.dataService = Get.find();
    this.authState = Get.find();

    on<UpdateAccount>((event, emit) async {
      emit(AccountUpdateInProgress());
      String result = await dataService.updateAccount(
          userID: userUuid,
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email,
          mobileNumber: event.mobileNumber,
          prefContactMethod: event.prefContactMethod);

      Account account = new Account(
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email,
          mobileNumber: event.mobileNumber,
          prefContactMethod: event.prefContactMethod,
          uuid: userUuid,
          referMethod: "",
          otherReferMethodDescription: "");

      if (result == 'success') {
        emit(AccountUpdateSuccess(account));
      } else {
        emit(AccountUpdateError(result));
      }
    });

    on<GetAccountForID>((event, emit) async {
      print("Getting account");
      Account? account = await dataService.getAccountForUserId(event.userID);
      print("Got account:" + account.toString());
      if (account != null) {
        emit(AccountLoaded(account));
      } else {
        emit(AccountLoadError());
      }
    });

    on<ShowLoadError>((event, emit) async {
      emit(AccountLoadError());
    });

    on<GetAccountForCurrentUser>((event, emit) async {
      if (authState.isAuthenticated) {
        print("Launched from constructor");
        print('Getting user UUID');
        userUuid = authState.currentAccount?.uuid ?? "";
        print("User UUID:" + userUuid);
        this.add(GetAccountForID(userID: userUuid));
        print("Sent event");
      } else {
        this.add(ShowLoadError(
            message:
                "An account could not be found for the current user. \n Please try logging in and out or contact customer support."));
      }
    });
  }
}

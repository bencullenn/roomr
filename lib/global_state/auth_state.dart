import 'package:firebase_auth/firebase_auth.dart';
import 'package:roomr/model/account.dart';

class AuthState {
  bool isAuthenticated = false;
  User? currentUser;
  Account? currentAccount;
}

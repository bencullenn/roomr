import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:roomr/model/account.dart';
import 'package:roomr/services/data_service.dart';
import 'package:roomr/global_state/auth_state.dart';

/// Thrown if during the sign up process if a failure occurs.
class SignUpFailure implements Exception {}

/// Thrown during the login process if a failure occurs.
class LogInWithEmailAndPasswordFailure implements Exception {}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final StreamSubscription<User?> _authSubscription;
  late final dataService = Get.find<DataService>();
  AuthState authState = Get.find<AuthState>();
  User? currentUser;
  User? anonUser;
  bool initialLogin = true;

  AuthService(){
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(_onUserChanged);
  }

  Stream<User?> getUserStream() {
    return _auth.authStateChanges();
  }

  Future<void> logOut() async {
    this.currentUser = null;
    await FirebaseAuth.instance.signOut();
  }

  void _onUserChanged(User? user) async {
    if (user != null) {
      Account? account =
          await dataService.getAccountForUserId(user.uid);
      print("Found Account:" + account.toString());
      if (account != null) {
        authState.isAuthenticated = true;
        authState.currentUser = user;
        authState.currentAccount = account;
      } else {
        print("Account is null");
      }
    }
  }

  Future<String> signUpWithEmail(String email, String password) async {
    try {
      //await deleteAnonUser();
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      currentUser = _auth.currentUser;
      authState.currentUser = _auth.currentUser;
      authState.isAuthenticated = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return 'weak-password';
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return 'email-already-in-use';
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
    return 'Success';
  }

  Future<String> logInWithEmail(String email, String password) async {
    try {
      //await deleteAnonUser();
      await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      currentUser = _auth.currentUser;
      authState.currentUser = _auth.currentUser;
      authState.isAuthenticated = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return e.code;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return e.code;
      } else {
        return e.code;
      }
    }
    return 'Success';
  }

  Future<Account?> createAccount(
      {String? firstName,
      String? lastName,
      String? email,
      String? mobileNumber,
      String? prefContactMethod,
        String? referMethod,
        String? otherReferMethodDescription}) async {
    Account? a;
    if (currentUser != null) {
      print("Current user is not null");
      a = new Account(
          firstName: firstName ?? '',
          lastName: lastName ?? '',
          email: email ?? '',
          uuid: currentUser!.uid,
          mobileNumber: mobileNumber ?? '',
          prefContactMethod: prefContactMethod ?? '',
          referMethod: referMethod ?? '',
          otherReferMethodDescription: otherReferMethodDescription ?? '');
      print("Created account object");
      dataService.uploadAccount(a);
      print("Account uploaded");
    } else {
      print('Account could not be created because there is no current user');
      a = null;
    }
    return a;
  }

  Future<String> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email, actionCodeSettings: null);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return e.code;
    }
    return 'success';
  }
}

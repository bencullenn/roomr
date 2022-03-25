class AuthScreenSettings {
  String? destinationScreen;
  String? returnScreen;

  AuthScreenSettings({this.destinationScreen, this.returnScreen});

  @override
  String toString() {
    return 'AuthScreenSettings{destinationScreen: $destinationScreen, returnScreen: $returnScreen}';
  }
}

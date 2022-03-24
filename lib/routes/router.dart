import 'package:flutter/material.dart';
import 'package:roomr/routes/routes.dart';
import 'package:roomr/screens/account_creation_screen.dart';
import 'package:roomr/screens/account_edit_screen.dart';
import 'package:roomr/screens/account_settings_screen.dart';
import 'package:roomr/screens/auth_select_screen.dart';
import 'package:roomr/screens/listing_compose_screen.dart';
import 'package:roomr/screens/listing_detail_screen.dart';
import 'package:roomr/screens/listing_edit_screen.dart';
import 'package:roomr/screens/listing_filters_screen.dart';
import 'package:roomr/screens/login_screen.dart';
import 'package:roomr/screens/root_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.home:
      return _getPageRoute(RootPage(title: "Swap"));
    case AppRoutes.login:
      return _getPageRoute(LoginScreen());
    case AppRoutes.createAccount:
      return _getPageRoute(AccountCreationScreen());
    case AppRoutes.accountSettings:
      return _getPageRoute(AccountSettingsScreen());
    case AppRoutes.authSelect:
      return _getPageRoute(AuthSelectScreen());
    case AppRoutes.composeListing:
      return _getPageRoute(ComposeListingScreen());
    case AppRoutes.listingFilters:
      return _getPageRoute(ListingFiltersScreen());
    case AppRoutes.editListing:
      return _getPageRoute(ListingEditScreen());
    case AppRoutes.editAccount:
      return _getPageRoute(AccountEditScreen());
    case AppRoutes.listingDetails:
      return _getPageRoute(ListingDetailScreen());
    default:
      return _getPageRoute(RootPage(title: "Swap"));
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:roomr/blocs/account_edit/account_edit_bloc.dart';
import 'package:roomr/blocs/home_feed/home_feed_bloc.dart';
import 'package:roomr/blocs/listing_compose/listing_compose_bloc.dart';
import 'package:roomr/blocs/listing_edit/listing_edit_bloc.dart';
import 'package:roomr/blocs/listing_search/listing_search_bloc.dart';
import 'package:roomr/blocs/login/login_bloc.dart';
import 'package:roomr/blocs/app_settings/app_settings_bloc.dart';
import 'package:roomr/blocs/sign_up/sign_up_bloc.dart';
import 'package:roomr/blocs/simple_bloc_observer.dart';
import 'package:roomr/firebase_options.dart';
import 'package:roomr/global_state/auth_state.dart';
import 'package:roomr/routes/navigation_controller.dart';
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
import 'package:roomr/services/auth_service.dart';
import 'package:roomr/services/data_service.dart';
import 'package:roomr/services/places_service.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  BlocOverrides.runZoned(
    () {
      // ...
    },
    blocObserver: SimpleBlocObserver(),
  );
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    print("Error:" + error.toString());
  }
  await setupSingletons();
  runApp(const MyApp());
}

Future<bool> setupSingletons() async {
  Get.put(AuthState());
  Get.put(DataService());
  Get.put(AuthService());
  Get.put(PlacesService());
  Get.put(NavigationController());
  return true;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(),
          ),
          BlocProvider<SignUpBloc>(
            create: (context) => SignUpBloc(),
          ),
          BlocProvider<ListingSearchBloc>(
            create: (context) => ListingSearchBloc(),
          ),
          BlocProvider<HomeFeedBloc>(
            create: (context) => HomeFeedBloc(),
          ),
          BlocProvider<ListingComposeBloc>(
            create: (context) => ListingComposeBloc(),
          ),
          BlocProvider<ListingEditBloc>(
            create: (context) => ListingEditBloc(),
          ),
          BlocProvider<AccountEditBloc>(
            create: (context) => AccountEditBloc(),
          ),
          BlocProvider<AppSettingsBloc>(
            create: (context) => AppSettingsBloc(),
          ),
        ],
        child: GetMaterialApp(
          title: 'Roomr',
          navigatorObservers: [
            //FirebaseAnalyticsObserver(analytics: analytics),
          ],
          theme: ThemeData(
              // Define the default brightness and colors.
              brightness: Brightness.light,
              primaryColor: Colors.blue[400],
              appBarTheme: AppBarTheme(
                  titleTextStyle:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),

              // Define the default font family.
              fontFamily: 'Raleway',

              // Define the default TextTheme. Use this to specify the default
              // text styling for headlines, titles, bodies of text, and more.
              textTheme:
                  GoogleFonts.mulishTextTheme(Theme.of(context).textTheme)
                      .apply(bodyColor: Colors.black)),
          initialRoute: AppRoutes.home,
          getPages: [
            GetPage(name: AppRoutes.home, page: () => RootPage(title: "Swap")),
            GetPage(name: AppRoutes.login, page: () => LoginScreen()),
            GetPage(
                name: AppRoutes.createAccount,
                page: () => AccountCreationScreen()),
            GetPage(
                name: AppRoutes.accountSettings,
                page: () => AccountSettingsScreen()),
            GetPage(name: AppRoutes.authSelect, page: () => AuthSelectScreen()),
            GetPage(
                name: AppRoutes.composeListing,
                page: () => ComposeListingScreen()),
            GetPage(
                name: AppRoutes.listingFilters,
                page: () => ListingFiltersScreen()),
            GetPage(
                name: AppRoutes.editListing, page: () => ListingEditScreen()),
            GetPage(
                name: AppRoutes.editAccount, page: () => AccountEditScreen()),
            GetPage(
                name: AppRoutes.listingDetails,
                page: () => ListingDetailScreen()),
          ],
        ));
  }
}

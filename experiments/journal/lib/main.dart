// Importing necessary packages
import 'package:firebase_core/firebase_core.dart'; // Firebase core for Firebase related operations
import 'package:flutter/material.dart'; // Flutter material design package
import 'package:google_mobile_ads/google_mobile_ads.dart'; // Google mobile ads for displaying ads
import 'package:journal/pages/home.dart'; // Home page of the app
import 'package:journal/bloc/authentication_bloc.dart'; // BLoC for authentication related operations
import 'package:journal/bloc/authentication_bloc_provider.dart'; // Provider for the authentication BLoC
import 'package:journal/bloc/home_bloc.dart'; // BLoC for home page related operations
import 'package:journal/bloc/home_bloc_provider.dart'; // Provider for the home BLoC
import 'package:journal/services/authentication.dart'; // Service for authentication related operations
import 'package:journal/services/db_firestore.dart'; // Service for Firestore database operations
import 'package:journal/pages/login.dart'; // Login page of the app
import 'package:journal/utils/ads_state.dart'; // State management for ads
import 'package:journal/utils/const.dart'; // Constants used in the app
import 'package:journal/utils/pallete.dart'; // Color palette used in the app
import 'package:provider/provider.dart'; // Provider package for state management

// Main function of the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensuring widgets are initialized before running the app
  final initFuture = MobileAds.instance.initialize(); // Initializing mobile ads
  final adState = AdState(initialization: initFuture); // Creating an AdState instance
  await Firebase.initializeApp(); // Initializing Firebase
  runApp(
    Provider.value(
      value: adState, // Providing the adState to the app
      builder: (context, child) => const MyApp(), // Building the app
    ),
  );
}

// MyApp widget which is the root of your application
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState(); // Creating the state for MyApp
}

// State of MyApp
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp(); // Initializing Firebase
    final AuthenticationService _authenticationService =
        AuthenticationService(); // Creating an AuthenticationService instance
    final AuthenticationBloc _authenticationBloc =
        AuthenticationBloc(_authenticationService); // Creating an AuthenticationBloc instance
    return AuthenticationBlocProvider(
      authenticationBloc: _authenticationBloc, // Providing the AuthenticationBloc
      child: StreamBuilder(
        initialData: null,
        stream: _authenticationBloc.user, // Listening to the user stream
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) { // If the snapshot has data, user is logged in
            return HomeBlocProvider(
              homeBloc: HomeBloc(DbFirestoreService(), _authenticationService), // Providing the HomeBloc
              uid: snapshot.data, // User ID from the snapshot
              child: _buildMaterialApp(const Home()), // Building the home page
            );
          } else { // If the snapshot has no data, user is not logged in
            return _buildMaterialApp(const Login()); // Building the login page
          }
        },
      ),
    );
  }

  // Function to build the MaterialApp
  MaterialApp _buildMaterialApp(Widget homepage) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hiding the debug banner
      title: 'Journal', // Title of the app
      theme: ThemeData( // Theme data for the app
        fontFamily: "Wondershine",
        textTheme: ThemeData.light().textTheme.copyWith(
              subtitle1: const TextStyle(
                  fontFamily: "DavidLibre",
                  fontSize: 20,
                  color: Colors.white54),
              button: const TextStyle(
                  fontFamily: "DavidLibre",
                  fontSize: 20,
                  color: Colors.white54),
              headline6: const TextStyle(
                  fontFamily: "DavidLibre",
                  fontSize: 20,
                  color: Colors.white54),
              headline5: const TextStyle(
                  fontFamily: "DavidLibre",
                  fontSize: 20,
                  color: Colors.white54),
              caption: const TextStyle(
                  fontFamily: "DavidLibre",
                  fontSize: 20,
                  color: Colors.white54),
              headline3: const TextStyle(
                  fontFamily: "DavidLibre",
                  fontSize: 20,
                  color: Colors.white54),
              bodyText1: const TextStyle(
                  fontFamily: "Wondershine",
                  fontSize: 40,
                  color: Colors.white60),
              bodyText2: const TextStyle(
                fontFamily: "Wondershine",
                fontSize: 20,
              ),
            ),
        canvasColor: Colors.white,
        bottomAppBarColor: secondaryColor,
        primarySwatch: Palette.kToDark,
      ),
      home: homepage, // Home page of the app
    );
  }
}

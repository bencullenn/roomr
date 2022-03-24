# Roomr

A housing marketplace app for iOS and Android.

## Features
This project is designed to be a starting point for anyone that wants to build a marketplace app in Flutter.
Some of the features include:
- Firestore database to store listings
- Firebase storage to store listing photos
- Firebase Authentication to allow users to create accounts
- Google maps API to enable location search autocomplete
- Cross platform support (iOS and Android)
- Adaptive interface layouts that fit both tablets or phones

## Getting Started

Use the steps below to enable the features that require backend services or API's

Step 1
- Follow the instructions from the [FlutterFire documentation](https://firebase.flutter.dev/docs/cli/) to install the FlutterFire CLI.
- Create a Firebase project and use the FlutterFire CLI to generate a firebase_options.dart file
- Remove the path "/lib/firebase_options.dart" from the .gitignore file if you'd like to check the file into version control.

Step 2
This project has google maps autofill functionality. This requires an API key from the Google Maps console to work.
- Enable the Google Maps "Places API" in Google Cloud and create an API. Follow [this tutorial](https://medium.com/comerge/location-search-autocomplete-in-flutter-84f155d44721) for more detailed instructions.
- Locate the Places Service file (lib/services/places_service.dart) and add your API key where it says 'YOUR API KEY HERE'.

That's it! You can now run the app on a mobile device and it will use the included Firebase project.

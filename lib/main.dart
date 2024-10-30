import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'Models/Colors.dart';
import 'Pages/HomePage.dart';

import 'Pages/LoginPage.dart';
import 'Services/FireBaseServices.dart';
import 'dart:js' as js;

String getEnv(String key) {
  return js.context['env'][key] ?? '';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: getEnv('API_KEY'),
    authDomain: getEnv('AUTH_DOMAIN'),
    projectId: getEnv('PROJECT_ID'),
    storageBucket: getEnv('STORAGE_BUCKET'),
    messagingSenderId: getEnv('MESSAGING_SENDER_ID'),
    appId: getEnv('APP_ID'),
  ));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FireBaseServices()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to FireBaseServices to get updated state
    final firebaseServices = Provider.of<FireBaseServices>(context);

    return MaterialApp(
      debugShowMaterialGrid: false,
      title: 'Mega Mall',
      theme: ThemeData(
        primaryColor: AppColors.blueOcean,
        scaffoldBackgroundColor: AppColors.pureWhite,
        colorScheme: const ColorScheme(
          primary: AppColors.blueOcean,
          secondary: AppColors.earthGreen,
          surface: AppColors.halfGrey,
          background: AppColors.pureWhite,
          error: AppColors.redVelvet,
          onPrimary: AppColors.pureWhite,
          onSecondary: AppColors.pureWhite,
          onSurface: AppColors.halfGrey,
          onBackground: AppColors.halfGrey,
          onError: AppColors.pureWhite,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.halfGrey, fontSize: 30),
          bodyMedium: TextStyle(color: AppColors.softGrey, fontSize: 20),
          titleMedium: TextStyle(color: Colors.black, fontSize: 30),
          titleSmall: TextStyle(
            color: Colors.blue,
            fontSize: 20,
          ),
          titleLarge: TextStyle(color: AppColors.blueOcean, fontSize: 30),
          displaySmall: TextStyle(color: AppColors.blueOcean, fontSize: 15),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: AppColors.blueOcean,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      // Show HomePage if signed in, otherwise show LoginPage
      home: InitialScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = FirebaseAuth.instance;
    return StreamBuilder(
      stream: firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return LoginPage();
          }
          return HomePage();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/MyModels/pushnotifications.dart';
import 'package:meditation_app/MyProviders/darkmode.dart';
import 'package:meditation_app/firebase_options.dart';
import 'package:meditation_app/landing.dart';
import 'package:meditation_app/notifications.dart';
import 'package:meditation_app/splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await pushNotifications().pushNotification();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  Future checkLoggedInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      isLoggedIn = loggedIn;
    });
  }

  @override
  void initState() {
    super.initState();
    checkLoggedInStatus();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          routes: {
            Notify.route: (context) => const Notify(),
          },
          debugShowCheckedModeBanner: false,
          /*theme: themeProvider.isDarkMode
              ? ThemeData.dark().copyWith(
                  textTheme: GoogleFonts.robotoTextTheme(
                    ThemeData.dark().textTheme,
                  ),
                )
              : ThemeData.light().copyWith(
                 brightness: Brightness.light,
                  useMaterial3: true,
                  textTheme: GoogleFonts.robotoTextTheme(
                    ThemeData.light().textTheme,
                  ),
                ),*/
          theme: ThemeData(
            useMaterial3: true,
            textTheme: GoogleFonts.robotoTextTheme(
              Theme.of(context).textTheme,
            ),
            primarySwatch: Colors.deepPurple,
          ),
          home: isLoggedIn ? const LandingScreen() : const SplashScreen(),
        );
      }),
    );
  }
}

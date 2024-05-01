import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_challengein/firebase_options.dart';
import 'package:mobile_challengein/pages/auth/auth_wrapper.dart';
import 'package:mobile_challengein/pages/auth/sign_in_page.dart';
import 'package:mobile_challengein/provider/auth_provider.dart';
import 'package:mobile_challengein/provider/history_provider.dart';
import 'package:mobile_challengein/provider/saving_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SavingProvider(),
        ),
        ChangeNotifierProxyProvider<SavingProvider, HistoryProvider>(
          update: (context, value, previous) {
            if (previous == null) {
              return HistoryProvider();
            }
            if (value.isOnTrx) {
              previous.refreshGetHistory();
              value.onDoneTrx();
            }
            return previous;
          },
          create: (context) => HistoryProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container(),
        ),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

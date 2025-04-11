import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workforce_app/providers/theme_provider.dart';
import 'package:workforce_app/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workforce_app/theme/theme.dart';
import 'package:workforce_app/utils/route_utils.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) {
    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    return MaterialApp(
      onGenerateRoute: RouteUtils.onGenerateRoute,
      debugShowCheckedModeBanner: false,
      title: 'WorkForce',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}

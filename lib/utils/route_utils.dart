import 'package:flutter/material.dart';
import 'package:workforce_app/constants/string.dart';
import 'package:workforce_app/screens/Chat/chat.dart';
import 'package:workforce_app/screens/Chat/message.dart';
import 'package:workforce_app/screens/auth.dart';
import 'package:workforce_app/screens/public_profile.dart';
import 'package:workforce_app/screens/review.dart';
import 'package:workforce_app/screens/splash.dart';
import 'package:workforce_app/screens/tabs.dart';
import 'package:workforce_app/screens/work_form.dart';
import 'package:workforce_app/screens/worker.dart';
import 'package:workforce_app/screens/workforce.dart';
import 'package:workforce_app/wrapper/wrapper.dart';

class RouteUtils {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case auth:
        return MaterialPageRoute(builder: (context) => const AuthScreen());
      case wrapper:
        return MaterialPageRoute(builder: (context) => const Wrapper());
      case worker:
        final String categoryName = settings.arguments as String? ?? "";
        return MaterialPageRoute(
            builder: (context) => WorkerScreen(
                  categoryName: categoryName,
                ));
      case tabs:
        final int pageIndex = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
          builder: (context) => Tabs(initialPageIndex: pageIndex),
        );
      case join:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final bool joined = args["joined"] as bool? ?? false;
        final String title = args["title"] as String? ?? "Join WorkForce";
        return MaterialPageRoute(
          builder: (context) => WorkForm(
            title: title,
            isJoin: joined,
          ),
        );
      case viewProfile:
        final String docId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (context) => PublicProfileScreen(
            id: docId,
          ),
        );
      case review:
        final String docId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (context) => ReviewScreen(
            id: docId,
          ),
        );
      case workforce:
        return MaterialPageRoute(
          builder: (context) => Workforce(),
        );
      case chat:
        return MaterialPageRoute(
          builder: (context) => ChatScreen(),
        );
      case msg:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final String userId = args["userId"] as String? ?? "";
        final String currentUserId = args["currentUserId"] as String? ?? "";
        final String userName = args["userName"] as String? ?? "...";
        final String userImage = args["userImage"] as String? ?? "";
        return MaterialPageRoute(
          builder: (context) => MessageScreen(
            userId: userId,
            currentUserId: currentUserId,
            userName: userName,
            userImage: userImage,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No Route Found'),
            ),
          ),
        );
    }
  }
}

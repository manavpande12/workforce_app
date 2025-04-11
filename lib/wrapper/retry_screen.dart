import 'package:flutter/material.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/custom_button.dart';

class RetryScreen extends StatelessWidget {
  final void Function() onLogOut;
  final void Function() onRetry;
  const RetryScreen({super.key, required this.onLogOut, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).brightness == Brightness.dark
                  ? bgrey
                  : grey,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "⚠️ Slow Connection Detected! \n\n"
                    "We are trying to verify your account, but it’s taking longer than expected. 🚀\n\n"
                    "This may be due to a slow internet connection or Your account has been deleted. \n\n"
                    "If the issue persists, check your internet connection or contact support. 🛠️",
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            icon: Icons.exit_to_app,
                            iClr: black,
                            iSize: 25,
                            bgClr: yellow,
                            fgClr: black,
                            text: "Log Out",
                            onTap: onLogOut,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            icon: Icons.replay_outlined,
                            iClr: white,
                            iSize: 25,
                            bgClr: red,
                            fgClr: white,
                            text: "Retry",
                            onTap: onRetry,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:motiwalajewels/Exitdialuge.dart';
import 'package:motiwalajewels/web_view.dart';

class InternetConnection extends StatefulWidget {
  const InternetConnection({super.key});

  @override
  State<InternetConnection> createState() => _InternetConnectionState();
}

class _InternetConnectionState extends State<InternetConnection> {
  @override
  Widget build(BuildContext context) {
    Connectivity connectivity = Connectivity();

    return Scaffold(
      body: StreamBuilder<ConnectivityResult>(
        stream: connectivity.onConnectivityChanged.map((event) => event.first),
        builder: (context, snapshot) {
          return InternetConnectionWidget(
            snapshot: snapshot,
            widget: const WebViewStack(),
          );
        },
      ),
    );
  }
}

class InternetConnectionWidget extends StatelessWidget {
  final AsyncSnapshot<ConnectivityResult> snapshot;
  final Widget widget;
  const InternetConnectionWidget({
    required this.snapshot,
    required this.widget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    switch (snapshot.connectionState) {
      case ConnectionState.active:
        final state = snapshot.data!;
        switch (state) {
          case ConnectivityResult.none:
            return const NoInternetDialog();
          default:
            return widget;
        }
      default:
        return const Center(child: CircularProgressIndicator());
      // return const Center(child: Text(""));
      // return const NoInternetDialog();
    }
  }
}

class NoInternetDialog extends StatefulWidget {
  const NoInternetDialog({super.key});

  @override
  State<NoInternetDialog> createState() => _NoInternetDialogState();
}

class _NoInternetDialogState extends State<NoInternetDialog> {
  String adUrl = 'assets/images/dog1.jpg';
  bool isLoading = false;

  void retry() {
    // Set isLoading to true
    setState(() {
      isLoading = true;
    });

    // Wait for 2 seconds, then set isLoading to false
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _refreshAd() {
    List<String> customAdImages = [
      'assets/images/dog1r.webp',
      'assets/images/dog2r.webp',
      'assets/images/dog3.jpg',
      'assets/images/dog3r.webp',
    ];

    setState(() {
      adUrl = customAdImages[Random().nextInt(customAdImages.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        debugPrint("🚪 WillPopScope triggered");
        bool shouldExit = await ExitConfirmationDialog(context);
        debugPrint("❓ Exit dialog result: $shouldExit");
        return shouldExit;
      },
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Linear Progress Indicator
              if (isLoading)
                LinearProgressIndicator(
                  minHeight: 4,
                  value: null,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  backgroundColor: Colors.yellow,
                ),

              // Spacing below the status bar
              const SizedBox(height: 10),

              // Ad Banner
              Container(
                height: 550, // Adjusted height
                width: screenWidth * 0.8, // Set width to 80% of the screen
                color: Colors.grey[300],
                child: Image.asset(
                  adUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Center(child: Text("Ad Not Available")),
                ),
              ),

              // Add a small Spacer to reduce extra space
              const SizedBox(height: 20),

              const Text(
                "Oops! No Internet",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Please check your network connection and try again.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),

              // Add a Spacer to push the button towards the bottom
              const SizedBox(height: 70),

              ElevatedButton(
                onPressed: () {
                  _refreshAd();
                  retry();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A539A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: const Text("Try Again", style: TextStyle(fontSize: 18)),
              ),

              const SizedBox(height: 20), // Small spacing before bottom edge
            ],
          ),
        ),
      ),
    );
  }
}

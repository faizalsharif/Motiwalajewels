import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:motiwalajewels/Exitdialuge.dart';
import 'package:motiwalajewels/provider.dart';

import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class WebViewStack extends StatefulWidget {
  const WebViewStack({super.key});

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack>
    with TickerProviderStateMixin {
  late WebViewController _controller;
  late AnimationController _animationController;
  bool _hasShownLoadingIndicator =
      false; // Track if loading indicator was already shown

  bool isRefreshing = false;
  double pullDistance = 0.0;
  bool _isLoading = true; // Tracks how far the user pulls down
  late AnimationController _controller1;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AppProvider>(context, listen: false);
    // Continuously rotate
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setUserAgent("MyFlutterAppWebView")
          ..addJavaScriptChannel(
            "ScrollHandler",
            onMessageReceived: (message) {
              if (message.message == "refresh" && !isRefreshing) {
                _refreshPage();
              }
            },
          )
          ..addJavaScriptChannel(
            "PullDistanceHandler",
            onMessageReceived: (message) {
              if (message.message == "reset") {
                setState(() => pullDistance = 0);
              } else {
                double distance = double.tryParse(message.message) ?? 0;
                if (distance > 0) {
                  setState(() => pullDistance = distance);
                }
              }
            },
          )
          ..addJavaScriptChannel(
            "DebugLogger",
            onMessageReceived: (message) {
              print("🐞 DebugLogger: ${message.message}");
            },
          )
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) {
                setState(() {
                  _isLoading = true;
                  // Show the loading indicator
                  if (_isLoading && !_hasShownLoadingIndicator) {
                    print("✅ Loading indicator niot shown");
                    setState(() {
                      provider.setLoading(false);
                    });
                  } else {
                    print("✅ Loading indicator shown");
                    provider.setLoading(true);
                  }
                });
                return NavigationDecision.navigate; // Always allow navigation
              },

              onPageStarted: (url) {
                provider.setLoading(true);
                if (!_hasShownLoadingIndicator) {
                  setState(() {
                    _isLoading = true; // Show loading indicator
                  });
                }
                Future.delayed(const Duration(seconds: 5), () {
                  _controller.runJavaScript("""
      const footer = document.querySelector('footer');
      const aboveFooter = document.querySelector('.container.d-lg-block');
      const footerSection = document.querySelector('section.footer-widget.green_bg');

      if (footer) {
        footer.style.display = 'none';
        DebugLogger.postMessage('✅ Footer hidden in WebView');
      } else {
        DebugLogger.postMessage('❌ Footer not found');
      }

      if (aboveFooter) {
        aboveFooter.style.display = 'none';
        DebugLogger.postMessage('✅ Above footer container hidden in WebView');
      } else {
        DebugLogger.postMessage('❌ Above footer container not found');
      }

      if (footerSection) {
        footerSection.style.display = 'none';
        DebugLogger.postMessage('✅ Footer section hidden in WebView');
      } else {
        DebugLogger.postMessage('❌ Footer section not found');
      }
    """);
                });

                print("redirecting it to homepge");
                Future.delayed(const Duration(seconds: 4), () {
                  setState(() {
                    _isLoading = false; // Hide loading indicator
                    _hasShownLoadingIndicator = true;
                    provider.setLoading(false); // Mark as shown
                  });
                });
              },
              onPageFinished: (url) {
                _injectJavaScriptScrollListener();
              },
            ),
          )
          ..loadRequest(Uri.parse('https://motiwalajewels.in/'));

    initFilePicker();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..stop();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller1.dispose(); // Dispose of the animation controller

    // Dispose of the WebViewController (if needed)
    _controller.clearCache();
    _controller.clearLocalStorage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        debugPrint("🚪 onWillPop triggered");

        bool canGoBack = await _controller.canGoBack();
        debugPrint("⬅️ WebView can go back: $canGoBack");

        if (canGoBack) {
          debugPrint("🔙 Going back in WebView history");
          await _controller.goBack();
          return false; // Prevent exit
        } else {
          debugPrint(
            "❌ No history to go back, showing exit confirmation dialog",
          );
          bool shouldExit = await ExitConfirmationDialog(context);
          debugPrint("❓ Exit confirmation result: $shouldExit");

          return shouldExit; // Exit only if user confirms
        }
      },

      child: SafeArea(
        child: Consumer<AppProvider>(
          builder: (context, provider, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Scaffold(
                  body: Column(
                    children: [
                      Visibility(
                        visible: provider.isLoading,
                        child: const LinearProgressIndicator(
                          minHeight: 4,
                          value: null,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF959492),
                          ),
                          backgroundColor: Color(0xFF24231E),
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            WebViewWidget(controller: _controller),
                            if (_isLoading && !_hasShownLoadingIndicator)
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/1.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center, // Centers everything vertically
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .center, // Centers everything horizontally
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [],
                                    ),

                                    const SizedBox(height: 575),

                                    // Lottie Animation
                                    Lottie.asset(
                                      'assets/images/Animation - 1743660005413.json',
                                      width: 45,
                                      height: 100,
                                      fit: BoxFit.fill,
                                    ),

                                    const SizedBox(height: 30),

                                    // Percentage Animation
                                    TweenAnimationBuilder<double>(
                                      tween: Tween<double>(begin: 0, end: 100),
                                      duration: const Duration(seconds: 8),
                                      builder: (context, value, child) {
                                        return Text(
                                          '${value.toInt()}%',
                                          style: const TextStyle(
                                            fontFamily: 'Futura',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF24231E),
                                          ),
                                          textAlign: TextAlign.center,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ✅ Animated Pull-to-Refresh Indicator
                if (pullDistance > 0 || isRefreshing)
                  Positioned(
                    top:
                        pullDistance > 100
                            ? 100
                            : pullDistance, // Moves downward
                    child: RotationTransition(
                      turns: _animationController,
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.refresh,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// ✅ Inject JavaScript for Pull-to-Refresh
  void _injectJavaScriptScrollListener() async {
    await _controller.runJavaScript("""
    (function() {
  let isRefreshing = false;
  let startY = 0;
  let isPulling = false;

  document.addEventListener('touchstart', function(e) {
    if (window.scrollY === 0) {
      startY = e.touches[0].clientY;
      isPulling = true;
      e.preventDefault(); // Prevent default touch behavior
    }
  });

  document.addEventListener('touchmove', function(e) {
    if (!isPulling || isRefreshing) return;

    let currentY = e.touches[0].clientY;
    let pullDistance = currentY - startY;

    window.PullDistanceHandler.postMessage(pullDistance.toString());

    if (pullDistance > 80) { 
      isRefreshing = true;
      window.ScrollHandler.postMessage("refresh");
    }
    e.preventDefault(); // Prevent default touch behavior
  });

  document.addEventListener('touchend', function() {
    isPulling = false;
    window.PullDistanceHandler.postMessage("reset");
  });
})();

    """);
  }

  /// ✅ Refresh WebView When Pulling Down
  Future<void> _refreshPage() async {
    setState(() {
      isRefreshing = true;
      pullDistance = 100;
    });

    _animationController.repeat();
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.setLoading(true);

    await _controller.reload();

    provider.setLoading(false);
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isRefreshing = false;
      pullDistance = 0;
    });

    _animationController.stop();
    _animationController.reset();
  }

  /// ✅ File Picker for Uploads
  void initFilePicker() async {
    if (Platform.isAndroid) {
      final AndroidWebViewController androidController =
          (_controller.platform as AndroidWebViewController);
      await androidController.setOnShowFileSelector(_androidFilePicker);
    }
  }

  Future<List<String>> _androidFilePicker(FileSelectorParams params) async {
    try {
      final attachment = await FilePicker.platform.pickFiles();
      if (attachment == null) return [];
      return [File(attachment.files.single.path!).uri.toString()];
    } catch (e) {
      return [];
    }
  }
}

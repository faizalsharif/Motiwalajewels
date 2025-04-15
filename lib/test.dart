import 'package:flutter/material.dart';
import 'package:motiwalajewels/web_view.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WebViewStack()),
          );
        },
      ),
    );
  }
}

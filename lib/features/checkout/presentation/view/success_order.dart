import 'package:flutter/material.dart';

class SuccessOrder extends StatelessWidget {
  const SuccessOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Success order")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("data"),
          ),
        ],
      ),
    );
  }
}

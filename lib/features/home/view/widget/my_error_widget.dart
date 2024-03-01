import 'package:flutter/material.dart';


class MyErrorWidget extends StatelessWidget {
  const MyErrorWidget({super.key, this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/error_icon.png',
          width:25,
        ),
        const SizedBox(height: 15),
        Text(
          text == null ? 'Something went wrong' : text!,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
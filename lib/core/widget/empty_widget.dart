import 'package:flutter/material.dart';


class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/empty_box.png',
            width: 100,
          ),
          const SizedBox(height: 15),
          Text(
            text == null ? 'There is no Items' : text!,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

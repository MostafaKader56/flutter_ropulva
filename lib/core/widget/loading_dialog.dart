import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SpinKitPulsingGrid(
      color: Constants.mainColor,
      size: 100,
    );
  }
}

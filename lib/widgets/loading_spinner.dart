import 'package:elevate_reg_app_2/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpinKitWaveSpinner(
      color: Colors.yellow,
      waveColor: MyColors.primayGreen,
      trackColor: Colors.yellow,
    );
  }
}

class LoadingSpinnerFullScreen extends StatelessWidget {
  const LoadingSpinnerFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitWaveSpinner(
          color: Colors.yellow,
          size: 70,
          waveColor: MyColors.primayGreen,
          trackColor: Colors.yellow,
        ),
      ),
    );
  }
}

class LoadingSpinnerFullScreenWithLoader extends StatefulWidget {
  final int val;
  const LoadingSpinnerFullScreenWithLoader({required this.val, super.key});

  @override
  State<LoadingSpinnerFullScreenWithLoader> createState() =>
      _LoadingSpinnerFullScreenWithLoaderState();
}

class _LoadingSpinnerFullScreenWithLoaderState
    extends State<LoadingSpinnerFullScreenWithLoader> {
  @override
  void initState() {
    super.initState();
    loaderVal = widget.val;
  }

  @override
  void didUpdateWidget(covariant LoadingSpinnerFullScreenWithLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    loaderVal = widget.val;
  }

  late int loaderVal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SpinKitWaveSpinner(
            color: Colors.yellow,
            size: 70,
            waveColor: MyColors.primayGreen,
            trackColor: Colors.yellow,
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Loading student data ',
              ),
              Text(
                '$loaderVal%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: MyColors.primayGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

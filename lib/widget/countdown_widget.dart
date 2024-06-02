import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_challengein/provider/saving_provider.dart';
import 'package:provider/provider.dart';

class CountdownWidget extends StatefulWidget {
  const CountdownWidget({super.key});

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  late Timer _timer;
  double _progress = 0.0;
  late Duration _totalDuration;
  late Duration _elapsedDuration;

  @override
  void initState() {
    super.initState();
    final timeData = Provider.of<SavingProvider>(context, listen: false);
    _totalDuration = timeData.topUpModel!.qrExpired!
        .difference(timeData.topUpModel!.createdAt!);
    _elapsedDuration =
        DateTime.now().difference(timeData.topUpModel!.createdAt!);
    _progress = _elapsedDuration.inSeconds / _totalDuration.inSeconds;
    _startTimer();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        final timeData = Provider.of<SavingProvider>(context, listen: false);
        _elapsedDuration =
            DateTime.now().difference(timeData.topUpModel!.createdAt!);
        _progress = _elapsedDuration.inSeconds / _totalDuration.inSeconds;

        if (_progress >= 1.0) {
          _progress = 1.0;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SavingProvider>(
      builder: (context, timeData, child) {
        _totalDuration = timeData.topUpModel!.qrExpired!
            .difference(timeData.topUpModel!.createdAt!);
        _elapsedDuration =
            DateTime.now().difference(timeData.topUpModel!.createdAt!);
        _progress = _elapsedDuration.inSeconds / _totalDuration.inSeconds;

        if (_progress >= 1.0) {
          _progress = 1.0;
        }

        if (_progress == 0) {
          timeData.checkQrExpired();
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                value: _progress,
              ),
              SizedBox(height: 20),
              Text(
                'Time remaining: ${(_totalDuration - _elapsedDuration).inSeconds} seconds',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}

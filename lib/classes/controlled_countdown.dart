import 'package:circular_countdown/circular_countdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timer_controller/timer_controller.dart';

class ControlledCountdownPage extends StatelessWidget {
  final String title;
  const ControlledCountdownPage({Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _Countdowns(
            title: title,
          ),
        ],
      ),
    );
  }
}

class _Countdowns extends StatefulWidget {
  final String title;
  const _Countdowns({Key? key, required this.title}) : super(key: key);

  @override
  __CountdownsState createState() => __CountdownsState();
}

class __CountdownsState extends State<_Countdowns> {
  late TimerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TimerController.seconds(10);
    _controller.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TimerControllerListener(
      controller: _controller,
      listenWhen: (previousValue, currentValue) =>
          previousValue.status != currentValue.status,
      listener: (context, timerValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          _StatusSnackBar(
            'Status: ${describeEnum(timerValue.status)}',
          ),
        );
        Navigator.pop(context);
      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TimerControllerBuilder(
              controller: _controller,
              builder: (context, timerValue, _) {
                Color? timerColor;
                switch (timerValue.status) {
                  case TimerStatus.running:
                    timerColor = Colors.green;
                    break;
                  case TimerStatus.paused:
                    timerColor = Colors.grey;
                    break;
                  case TimerStatus.finished:
                    timerColor = Colors.red;
                    break;
                  default:
                }
                return Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  spacing: 40,
                  runSpacing: 40,
                  children: <Widget>[
                    CircularCountdown(
                      diameter: 250,
                      countdownTotal: _controller.initialValue.remaining,
                      countdownRemaining: timerValue.remaining,
                      countdownCurrentColor: timerColor,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusSnackBar extends SnackBar {
  _StatusSnackBar(
    String title,
  ) : super(
          content: Text(title),
          duration: const Duration(seconds: 1),
        );
}

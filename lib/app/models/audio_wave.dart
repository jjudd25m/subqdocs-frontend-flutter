library audio_wave;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../core/common/global_controller.dart';

class AudioWaveBar {
  AudioWaveBar({required this.heightFactor, this.color = Colors.red, this.radius = 50.0, this.gradient}) : assert(heightFactor <= 1), assert(heightFactor >= 0);

  double heightFactor;
  Color color;
  double radius;
  final Gradient? gradient;
}

class AudioWave extends StatefulWidget {
  const AudioWave({
    // required this.bars,
    this.height = 100,
    this.width = 200,
    this.spacing = 5,
    this.alignment = 'center',
    this.animation = true,
    this.animationLoop = 0,
    this.beatRate = const Duration(milliseconds: 200),
    super.key,
  });

  // final List<AudioWaveBar> bars;

  final double height;
  final double width;
  final double spacing;
  final String alignment;
  final bool animation;
  final int animationLoop;
  final Duration beatRate;

  @override
  _AudioWaveState createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  int countBeat = 0;

  // List<AudioWaveBar>? bars;
  Timer? timer;
  final GlobalController globalController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(AudioWave oldWidget) {
    super.didUpdateWidget(oldWidget);
    // bars = widget.bars;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double width = (widget.width - (widget.spacing * 30)) / 30;

    return SizedBox(
      height: widget.height + 30,
      width: widget.width,
      child: Obx(() {
        return Row(
          children: [
            Wrap(
              crossAxisAlignment:
                  widget.alignment == 'top'
                      ? WrapCrossAlignment.start
                      : widget.alignment == 'bottom'
                      ? WrapCrossAlignment.end
                      : WrapCrossAlignment.center,
              spacing: widget.spacing,
              children: [
                if (globalController.samples != null)
                  for (final bar in globalController.samples)
                    Container(
                      height:
                          bar.heightFactor >= 0.0 && bar.heightFactor <= 0.1
                              ? 6
                              : bar.heightFactor > 0.5
                              ? bar.heightFactor * widget.height + 10
                              : bar.heightFactor * widget.height,
                      width: width,
                      decoration: BoxDecoration(gradient: bar.gradient, color: bar.color, borderRadius: BorderRadius.circular(bar.radius)),
                    ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

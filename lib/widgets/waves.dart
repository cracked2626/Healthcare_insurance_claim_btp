import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

Widget buildCard({
    Color backgroundColor = Colors.transparent,
    double height = 180.0,
    double width = double.infinity,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: Card(
        elevation: 12.0,
        clipBehavior: Clip.antiAlias,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child: WaveWidget(
          config: CustomConfig(
            gradients: [
              [Colors.red, const Color(0xEEF44336)],
              [Colors.red.shade800, const Color(0x77E57373)],
              [Colors.orange, const Color(0x66FF9800)],
              [Colors.yellow, const Color(0x55FFEB3B)]
            ],
            durations: [35000, 19440, 10800, 6000],
            heightPercentages: [0.20, 0.23, 0.25, 0.30],
            gradientBegin: Alignment.bottomLeft,
            gradientEnd: Alignment.topRight,
            blur: const MaskFilter.blur(BlurStyle.solid, 10.0),
          ),
          backgroundColor: Colors.white,
          // backgroundImage: backgroundImage,
          size: const Size(double.maxFinite, double.maxFinite),
          waveAmplitude: 0,
        ),
      ),
    );
  }
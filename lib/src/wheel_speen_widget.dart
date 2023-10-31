import 'dart:math';

import 'package:flutter/material.dart';

class WheelSpinController {
  late void Function() startWheel;
  late void Function(int index) stopWheel;
}

class WheelSpin extends StatefulWidget {
  final WheelSpinController controller;
  // final String pathImage;
  final double withWheel;
  final int pieces;
  final double offset;
  final bool isShowTextTest;
  final int speed;
  final Color textColor;
  const WheelSpin(
      {Key? key,
      required this.controller,
      required this.withWheel,
      this.offset = 0,
      required this.pieces,
      this.isShowTextTest = false,
      this.speed = 300,
      this.textColor = Colors.white})
      : super(key: key);

  @override
  State<WheelSpin> createState() => _WheelSpinState(controller);
}

class _WheelSpinState extends State<WheelSpin> with TickerProviderStateMixin {
  _WheelSpinState(WheelSpinController _controller) {
    _controller.startWheel = startWheel;
    _controller.stopWheel = stopWheel;
  }

  late AnimationController _controllerStart;
  late AnimationController _controllerFinish;

  late AnimationController _controllerMiddle;

  late Animation<double> _animationFinish;
  late Animation<double> _animationStart;

  late Animation<double> _animationMiddle;

  int statusWheel = 0;

  bool isNhanKetQua = false;
  int indexResuft = 0;
  double angle = 0;
  int pieces = 0;

  bool isStart = false;
  @override
  void initState() {
    super.initState();
    pieces = widget.pieces;
    _controllerStart = AnimationController(
      duration: Duration(milliseconds: widget.speed),
      vsync: this,
    );
    _controllerFinish = AnimationController(
      duration: Duration(milliseconds: widget.speed * 2),
      vsync: this,
    );

    _controllerMiddle = AnimationController(
      duration: Duration(milliseconds: widget.speed),
      vsync: this,
    );

    _animationFinish = CurvedAnimation(
      parent: _controllerFinish,
      curve: Curves.decelerate,
    );
    _animationStart = CurvedAnimation(
      parent: _controllerStart,
      curve: Curves.linear,
    );

    _animationMiddle = CurvedAnimation(
      parent: _controllerMiddle,
      curve: Curves.linear,
    );
    _controllerStart.addStatusListener((status) {
      if (!isStart) return;
      if (status == AnimationStatus.completed) {
        if (!isNhanKetQua) {
          _controllerStart.reset();
          _controllerStart.forward();
        } else {
          setState(() {
            statusWheel = 1;
            //
            _controllerStart.stop();

            _controllerMiddle.forward();
            // isStart = false;
          });
        }
      }
    });
    _controllerMiddle.addListener(() {
      if (!isStart) return;
      double radiaus = indexResuft / pieces + widget.offset;
      if (_controllerMiddle.value >= radiaus) {
        setState(() {
          statusWheel = 2;
          angle = radiaus * 2 * pi;

          _controllerMiddle.stop();
          _controllerFinish.forward();
          // isStart = false;
        });
      }
    });
    _animationFinish.addListener(() {
      if (!isStart) return;
      double radiaus = indexResuft / pieces + widget.offset;
      if (_controllerMiddle.value >= radiaus) {
        setState(() {
          statusWheel = 2;
          angle = radiaus * 2 * pi;

          _controllerFinish.stop();
          _controllerFinish.forward();
          isStart = false;
          isNhanKetQua = false;
        });
      }
    });
  }

  reset() {
    setState(() {});
    isStart = false;
    statusWheel = 0;
    angle = 0;
    _controllerMiddle.reset();
    _controllerFinish.reset();
    _controllerStart.reset();

    isNhanKetQua = false;
  }

  void nhanketqua(int index) {
    isNhanKetQua = true;
    indexResuft = index;
  }

  Animation<double> getAnimation() {
    if (statusWheel == 0) return _animationStart;
    if (statusWheel == 1) return _animationMiddle;
    return _animationFinish;
  }

  @override
  void dispose() {
    if (_controllerStart.isAnimating) _controllerStart.dispose();
    if (_controllerFinish.isAnimating) _controllerFinish.dispose();
    if (_controllerMiddle.isAnimating) _controllerMiddle.dispose();
    super.dispose();
  }

  void startWheel() {
    reset();
    isStart = true;
    _controllerStart.forward();
  }

  void stopWheel(int index) {
    nhanketqua(index);
  }

  createLabels() {
    List<Widget> lsText = [];
    for (int i = 1; i <= pieces; i++) {
      lsText.add(Transform.rotate(
        angle: -i * pi * 2 / pieces + widget.offset,
        child: SizedBox(
          width: widget.withWheel,
          height: widget.withWheel,
          child: Stack(
            children: [
              Positioned(
                left: widget.withWheel / 2.05,
                top: widget.withWheel / 6,
                child: Transform.rotate(
                  angle: pi / 6,
                  child: Text(
                    i.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return SizedBox(
      width: widget.withWheel,
      height: widget.withWheel,
      child: Stack(
        children: lsText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: getAnimation(),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Transform.rotate(
          angle: angle,
          child: Container(
              decoration: (isNhanKetQua)
                  ? const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/Roulette.png"),
                        fit: BoxFit.fitHeight,
                        opacity: 0.4,
                      ),
                    )
                  : const BoxDecoration(color: Colors.transparent),
              child: Visibility(
                  visible: widget.isShowTextTest, child: createLabels())),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'wheel_speen_widget.dart';

class Spinner extends StatefulWidget {
  final String? title;
  final Color? titleColor;
  final String? description;
  final Color? descriptionColor;
  final List<String> gifts;
  final String pathImage;
  final String iconPath;

  const Spinner({
    Key? key,
    this.title,
    this.titleColor,
    this.description,
    this.descriptionColor,
    required this.gifts,
    required this.pathImage,
    required this.iconPath,
  }) : super(key: key);

  @override
  _SpinnerState createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late String _selectedGift;

  //AudioCache _audioCache;
  WheelSpinController wheelSpinController = WheelSpinController();
  @override
  void initState() {
    super.initState();
    // _audioCache = AudioCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // TODO: add the title
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        10, MediaQuery.of(context).size.height * 0.07, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: widget.title ?? "Take your chances!\n\n",
                            style: TextStyle(
                              color:
                                  widget.titleColor ?? const Color(0xFFD80497),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: widget.description ??
                                    "Spin the wheel for a chance to snag countless gifts!",
                                style: TextStyle(
                                  color: widget.descriptionColor ??
                                      const Color(0xFFA7A7A7),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: -(MediaQuery.of(context).size.height * 0.4),
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.pathImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: WheelSpin(
                controller: wheelSpinController,
                withWheel: MediaQuery.of(context).size.height * 0.8,
                pieces: 10,
                speed: 500, //defuaft is 500
                isShowTextTest: true,
                pathImage: widget.pathImage,
                // offset: 119 / 10, //random 1/10 pieces defuaft is zero
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.35,
            left: 0,
            right: 0,
            child: Image.asset(
              widget.iconPath,
              height: MediaQuery.of(context).size.height * 0.08,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () async {
          wheelSpinController.startWheel();
          //await _audioCache.play('mp3/wheel-spinning.wav');
          _selectedGift = _getRandomGift();

          Timer(const Duration(seconds: 5), () {
            wheelSpinController.stopWheel(widget.gifts.indexOf(_selectedGift));
            // show pop up
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("You won !"),
                  content: Text("You won a $_selectedGift"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"),
                    ),
                  ],
                );
              },
            );
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Text(
            "Start !",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  String _getRandomGift() {
    final random = Random();
    return widget.gifts[random.nextInt(widget.gifts.length)];
  }
}

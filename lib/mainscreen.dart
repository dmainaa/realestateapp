import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realestateapp/constants.dart';
import 'package:realestateapp/customnavbar.dart';
import 'package:realestateapp/mapscreen.dart';
import 'package:realestateapp/showup.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  bool showSet = false;

  double _locationContainerWidth = 0.0;
  double _pictureSize = 0.0;
  bool showLocation = false;
  bool showHelloMessage = false;
  bool showBubbles = false;
  bool showGallery1 = false;
  bool showGallery2 = false;
  bool showGallery3 = false;
  bool showGallery4 = false;
  bool showBottomNav = false;

  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _galleryController;
  late Animation<Offset> _galleryAnimation;

  AnimationController? _bottomAnimationController;
  Animation<Offset>? _bottomAnimation;

  @override
  void initState() {
    super.initState();
    increaseLocationWidgetWidth();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _galleryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _galleryAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _galleryController,
        curve: Curves.elasticIn,
      ),
    );
    Future.delayed(
      const Duration(milliseconds: 4700),
      () {
        setState(() {
          showGallery1 = true;
        });
      },
    );
    Future.delayed(
      const Duration(milliseconds: 5200),
      () {
        setState(() {
          showGallery2 = true;
        });
      },
    );
    Future.delayed(
      const Duration(milliseconds: 5200),
      () {
        setState(() {
          showGallery3 = true;
        });
      },
    );
    Future.delayed(
      const Duration(milliseconds: 5700),
      () {
        setState(() {
          showGallery4 = true;
        });
      },
    );
    Future.delayed(
      const Duration(milliseconds: 6000),
      () {
        setState(() {
          showBottomNav = true;
          _bottomAnimationController = AnimationController(
            vsync: this,
            duration: const Duration(seconds: 1),
          );
          _bottomAnimation = Tween<Offset>(
            begin: const Offset(0, 1),
            end: const Offset(0, -0.1),
          ).animate(CurvedAnimation(
            parent: _bottomAnimationController!,
            curve: Curves.easeOut,
          ));

          // Start the animation when the page loads
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _bottomAnimationController?.forward();
          });
        });
      },
    );
  }

  void increaseLocationWidgetWidth() {
    Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        if (_locationContainerWidth < 180) {
          setState(() {
            _locationContainerWidth += 30;
          });
        }
        if (_pictureSize < 43) {
          setState(() {
            _pictureSize += 10;
          });
        }
        Future.delayed(
          const Duration(milliseconds: 1200),
          () {
            setState(() {
              showLocation = true;
            });
          },
        );
        Future.delayed(const Duration(milliseconds: 1500), () {
          setState(() {
            showHelloMessage = true;
          });
        });
        Future.delayed(const Duration(milliseconds: 2500), () {
          setState(() {
            showBubbles = true;
            _controller.forward();
          });
          Future.delayed(
            const Duration(milliseconds: 800),
            () {
              setState(() {
                showSet = true;
              });
            },
          );
          timer.cancel();
        });
        Future.delayed(const Duration(milliseconds: 1500), () {
          setState(() {
            _galleryController.forward();
          });
          timer.cancel();
        });
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _galleryController.dispose();
    super.dispose();
  }

  ViewController _viewController = Get.put(ViewController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => _viewController.mainSelected.value
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      MyColors.whiteColor,
                      MyColors.brownColor,
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(height: 20),
                      _buildTopRow(),
                      const SizedBox(height: 30),
                      if (showHelloMessage) _buildHelloMessage(),
                      _buildIntroText(),
                      const SizedBox(height: 30),
                      if (showBubbles) _buildBubbles(),
                      const SizedBox(height: 20),
                      if (showSet) _buildImageGallery(),
                      const SizedBox(
                        height: 110,
                      ),
                    ],
                  ),
                ),
              )
            : const MapScreen(),
      ),
      bottomSheet: showBottomNav
          ? Theme(
              data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
              child: SlideTransition(
                position: _bottomAnimation!,
                child: CustomBottomNavigationBar(),
              ),
            )
          : null,
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? const Color(0xfffbb018) : Colors.black,
      ),
      padding: const EdgeInsets.all(8),
      child: Icon(
        icon,
        color: isActive ? Colors.white : Colors.grey,
      ),
    );
  }

  Widget _buildTopRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AnimatedContainer(
            width: _locationContainerWidth,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutCirc,
            child: showLocation
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          "assets/gps.png",
                          color: MyColors.darkBrown,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Text(
                        "Saint Petersburg",
                        style: TextStyle(
                          fontFamily: 'Euclid Circular A',
                          color: MyColors.darkBrown,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  )
                : null,
          ),
          const Expanded(child: SizedBox()),
          AnimatedContainer(
            height: _pictureSize,
            width: _pictureSize,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInCirc,
            child: ClipOval(
              child: Image.asset(
                "assets/girl.jpeg",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelloMessage() {
    return const Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text(
        "Hi, Marina",
        style: TextStyle(
          fontFamily: 'Euclid Circular A',
          color: MyColors.darkBrown,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _buildIntroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: ShowUp(
            delay: 2000,
            child: const Text(
              "let's select your",
              style: TextStyle(
                  fontFamily: 'Euclid Circular A',
                  fontSize: 33,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: ShowUp(
            delay: 2200,
            child: const Text(
              "perfect place",
              style: TextStyle(fontFamily: 'Euclid Circular A', fontSize: 33),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBubbles() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 165,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBubble("BUY", MyColors.buyColor, 1034),
          _buildBubble("RENT", Colors.white, 2212),
        ],
      ),
    );
  }

  Widget _buildBubble(String text, Color color, int offers) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Container(
          width: 165 * value,
          height: 165 * value,
          decoration: BoxDecoration(
              color: color,
              borderRadius: text == "BUY"
                  ? BorderRadius.circular(100 * value)
                  : BorderRadius.circular(25 * value)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                    fontFamily: 'Euclid Circular A',
                    fontSize: 17 * value,
                    color: color == Colors.white
                        ? MyColors.darkBrown
                        : Colors.white),
              ),
              const SizedBox(height: 10),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Text(
                    "${(offers * _animation.value).toInt().toString().split("")[0]} ${(offers * _animation.value).toInt().toString().substring(1)}",
                    style: TextStyle(
                        fontFamily: 'Euclid Circular A Bold',
                        fontSize: 35 * value,
                        color: color == Colors.white
                            ? MyColors.darkBrown
                            : Colors.white,
                        fontWeight: FontWeight.bold),
                  );
                },
              ),
              Text(
                "offers",
                style: TextStyle(
                    fontFamily: 'Euclid Circular A',
                    fontSize: 15 * value,
                    color: color == Colors.white
                        ? MyColors.darkBrown
                        : Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageGallery() {
    var width = MediaQuery.of(context).size.width;
    return SlideTransition(
      position: _galleryAnimation,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(25)),
        padding: const EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Stack(
                  children: [
                    Image.asset("assets/realestate1.jpeg"),
                    if (showGallery1)
                      TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 500),
                        tween: Tween(begin: width * 0.77, end: width * 0.05),
                        builder: (context, value, child) {
                          return Positioned(
                            bottom: 15,
                            left: 20,
                            right: value,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color(0xffd6c4b5)
                                      .withOpacity(0.90)),
                              padding: const EdgeInsets.all(2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (value == width * 0.05)
                                            Text(
                                              hypotheticalAddresses[0],
                                              style: const TextStyle(
                                                  fontFamily:
                                                      'Euclid Circular A',
                                                  fontSize: 20),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: MyColors.sliderForeground,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                  ],
                )),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.46,
                      height: 325,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 325,
                                child: Image.asset(
                                  "assets/realestate2.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if (showGallery2)
                                TweenAnimationBuilder(
                                  duration: const Duration(milliseconds: 500),
                                  tween: Tween(
                                      begin: width * 0.77, end: width * 0.024),
                                  builder: (context, value, child) {
                                    return Positioned(
                                      bottom: 10,
                                      left: 10,
                                      right: value,
                                      child: SizedBox(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 1580 / value,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  color: const Color(0xffd6c4b5)
                                                      .withOpacity(0.90)),
                                              padding: const EdgeInsets.all(2),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Expanded(
                                                      child: SizedBox(
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        if (value ==
                                                            width * 0.024)
                                                          Text(
                                                            hypotheticalAddresses[
                                                                1],
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Euclid Circular A',
                                                                fontSize: 12),
                                                          ),
                                                      ],
                                                    ),
                                                  )),
                                                  Container(
                                                    height: 40,
                                                    width: 40,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: MyColors
                                                            .sliderForeground,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100)),
                                                    child: const Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                            ],
                          ))),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.46,
                  height: 325,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: SizedBox(
                            height: 158,
                            width: MediaQuery.of(context).size.width * 0.46,
                            child: Stack(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.46,
                                  child: Image.asset(
                                    "assets/realestate3.webp",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (showGallery3)
                                  TweenAnimationBuilder(
                                    duration: const Duration(milliseconds: 500),
                                    tween: Tween(
                                        begin: width * 0.77,
                                        end: width * 0.024),
                                    builder: (context, value, child) {
                                      return Positioned(
                                        bottom: 10,
                                        left: 10,
                                        right: value,
                                        child: Container(
                                          width: 1580 / value,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: const Color(0xffd6c4b5)
                                                  .withOpacity(0.90)),
                                          padding: const EdgeInsets.all(2),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: SizedBox(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      hypotheticalAddresses[2],
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Euclid Circular A',
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                              Container(
                                                height: 40,
                                                width: 40,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: MyColors
                                                        .sliderForeground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                                child: const Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                              ],
                            )),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: SizedBox(
                            height: 158,
                            width: MediaQuery.of(context).size.width * 0.46,
                            child: Stack(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.46,
                                  child: Image.asset(
                                    "assets/realestate4.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (showGallery4)
                                  TweenAnimationBuilder(
                                    duration: const Duration(milliseconds: 500),
                                    tween: Tween(
                                        begin: width * 0.77,
                                        end: width * 0.024),
                                    builder: (context, value, child) {
                                      return Positioned(
                                        bottom: 10,
                                        left: 10,
                                        right: value,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 1510 / value,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  color: const Color(0xffd6c4b5)
                                                      .withOpacity(0.90)),
                                              padding: const EdgeInsets.all(2),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: SizedBox(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          hypotheticalAddresses[
                                                              3],
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Euclid Circular A',
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                                  Container(
                                                    height: 40,
                                                    width: 40,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: MyColors
                                                            .sliderForeground,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100)),
                                                    child: const Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  var hypotheticalAddresses = [
    "Gladkova St., 25",
    "Gubina St., 11",
    "Trefoleva St., 43",
    "Sedova St., 22"
  ];
}

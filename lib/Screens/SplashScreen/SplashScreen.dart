import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/AuthenticationScreen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ---------------- MODEL CLASS ----------------
class splashModel {
  String title;
  String description;
  String imagePage;
  String tabText;
  String IconPath;
  int index;

  splashModel({
    required this.title,
    required this.IconPath,
    required this.description,
    required this.imagePage,
    required this.tabText,
    required this.index,
  });
}

// ---------------- SCREEN WIDGET ----------------
class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Data Source
  List<splashModel> splashItem = [
    splashModel(
      title: "Nourishing Every Baby".tr,
      IconPath: "assets/logIcon.png".tr,
      description:
          "A caring platform designed to support babies with safe milk sharing and daily care tracking.".tr,
      imagePage: "assets/ss1.png",
      tabText: "Log",
      index: 0,
    ),
    splashModel(
      title: "Track Baby’s Daily Care".tr,
      IconPath: "assets/reportIcon.png".tr,
      description:
          "Log feeding, diaper changes, and sleep patterns to understand your baby’s routine better".tr,
      imagePage: "assets/ss2.png",
      tabText: "Report",
      index: 1,
    ),
    splashModel(
      title: "Connect with Milk Donors".tr,
      IconPath: "assets/connectIcon.png",
      description:
          "Find trusted breast milk donors nearby and build a safe, supportive connection.".tr,
      imagePage: "assets/ss3.png",
      tabText: "Connect",
      index: 2,
    ),
    splashModel(
      title: "Chat & Manage Profiles".tr,
      IconPath: "assets/message.png",
      description:
          "Communicate securely with donors and manage multiple baby profiles in one place.".tr,
      imagePage: "assets/ss4.png",
      tabText: "Message",
      index: 3,
    ),
  ];

  int currentIndex = 0;

  // Controllers
  PageController imageController = PageController();
  PageController textController = PageController();
  CarouselSliderController tabController = CarouselSliderController();

  // Animation Constants for Perfect Sync
  final Duration _animDuration = Duration(milliseconds: 600);
  final Curve _animCurve = Curves.easeInOutCubic;

  /// ---------------------------------------------------
  ///  CENTRAL FUNCTION → Controls ALL movements
  /// ---------------------------------------------------
  void goToPage(int index) {
    if (index >= splashItem.length || index < 0) {
      Get.off(() => Authenticationscreen(), transition: Transition.rightToLeft);
    }
    ;

    setState(() => currentIndex = index);

    // Animate all controllers together
    imageController.animateToPage(
      index,
      duration: _animDuration,
      curve: _animCurve,
    );

    textController.animateToPage(
      index,
      duration: _animDuration,
      curve: _animCurve,
    );

    tabController.animateToPage(
      index,
      duration: _animDuration,
      curve: _animCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      // bottomNavigationBar: ,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffFFE8E8), Color(0xffFFF5F0), Color(0xffFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---------------- TOP BAR (SKIP) ----------------
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.off(
                          () => Authenticationscreen(),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: Text(
                        "Skip".tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ---------------- IMAGES ----------------
              SizedBox(
                height: height * .40,
                child: PageView(
                  controller: imageController,
                  // If user swipes image manually, sync the rest
                  onPageChanged: (value) {
                    if (currentIndex != value) {
                      setState(() => currentIndex = value);
                      textController.animateToPage(
                        value,
                        duration: _animDuration,
                        curve: _animCurve,
                      );
                      tabController.animateToPage(
                        value,
                        duration: _animDuration,
                        curve: _animCurve,
                      );
                    }
                  },
                  children: [
                    for (var data in splashItem)
                      Image.asset(data.imagePage, fit: BoxFit.contain),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // ---------------- TABS (Carousel) ----------------
              CarouselSlider(
                carouselController: tabController,
                options: CarouselOptions(
                  viewportFraction: .35,
                  height: 40,
                  enableInfiniteScroll: false,
                  scrollPhysics:
                      NeverScrollableScrollPhysics(), // Locked, controlled by buttons/swipe only
                  initialPage: 0,
                ),
                items: [
                  for (var data in splashItem)
                    GestureDetector(
                      onTap: () => goToPage(data.index),
                      child: AnimatedContainer(
                        duration: Duration(
                          milliseconds: 300,
                        ), // Smooth color transition
                        height: 30,
                        width: 120,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color:
                              (currentIndex == data.index)
                                  ? Color(0xffF1D2D9)
                                  : Color(0xffE7E7E7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              data.IconPath,
                              width: 20,
                              color:
                                  (currentIndex == data.index)
                                      ? Color(0xffED7754)
                                      : Color(0xffB2A9A4),
                            ),
                            SizedBox(width: 10),
                            Text(
                              data.tabText,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color:
                                    (currentIndex == data.index)
                                        ? Color(0xffED7754)
                                        : Color(0xffB2A9A4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: 20),

              // ---------------- TEXT CONTENT ----------------
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  // height: height * .20,
                  child: PageView(
                    controller: textController,
                    physics: NeverScrollableScrollPhysics(), // Locked
                    children: [
                      for (var data in splashItem)
                        Column(
                          children: [
                            Text(
                              data.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff2C2C2C),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              data.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff2C2C2C),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              // SizedBox(height: height * .),

              // ---------------- DOT INDICATOR ----------------
              SmoothPageIndicator(
                controller: imageController, // CONNECTED TO IMAGE CONTROLLER
                count: splashItem.length,
                effect: ExpandingDotsEffect(
                  expansionFactor: 3.2,
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                  dotColor: Color(0xffD1D5DC),
                  activeDotColor: Color(0xffFF9B9B),
                ),
                onDotClicked: (index) => goToPage(index),
              ),

              InkWell(
                onTap: () {
                  if (currentIndex == splashItem.length - 1) {
                    // Handle 'Get Started' Action here (e.g., Navigate to Home)
                    Get.off(
                      () => Authenticationscreen(),
                      transition: Transition.rightToLeft,
                    );
                  } else {
                    goToPage(currentIndex + 1);
                  }
                },
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    (currentIndex == 0)
                        ? "Get Started".tr
                        : (currentIndex == 3)
                        ? "Login Now".tr
                        : "Next".tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

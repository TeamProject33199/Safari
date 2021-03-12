import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project/constants_colors.dart';
import 'package:project/locale_language/localization_delegate.dart';
import 'package:project/view/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  static const String id = "onBoarding_screen";

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? whiteColor : grey500Color,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: transparent,
      body: Stack(
        children: <Widget>[
          PageView(
            physics: ClampingScrollPhysics(),
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              Stack(
                children: [
                  Image(
                    image: AssetImage(
                      'assets/images/tour.jpg',
                    ),
                    fit: BoxFit.cover,
                    width: screenWidth,
                    height: screenHeight,
                  ),
                  Center(
                    child: Transform.translate(
                      offset: Offset(0, -100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Text(
                            AppLocalization.of(context)
                                .getTranslated("on_boarding_description1"),
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 34,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            AppLocalization.of(context)
                                .getTranslated("on_boarding_description2"),
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Image(
                    image: AssetImage(
                      'assets/images/car.jpg',
                    ),
                    fit: BoxFit.cover,
                    width: screenWidth,
                    height: screenHeight,
                  ),
                  Center(
                    child: Transform.translate(
                      offset: Offset(0, -100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Text(
                            AppLocalization.of(context)
                                .getTranslated("on_boarding_description3"),
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 34,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            AppLocalization.of(context)
                                .getTranslated("on_boarding_description4"),
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Image(
                    image: AssetImage(
                      'assets/images/hotel.jpg',
                    ),
                    fit: BoxFit.cover,
                    width: screenWidth,
                    height: screenHeight,
                  ),
                  Center(
                    child: Transform.translate(
                      offset: Offset(0, -100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Text(
                            AppLocalization.of(context)
                                .getTranslated("on_boarding_description5"),
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            AppLocalization.of(context)
                                .getTranslated("on_boarding_description6"),
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Transform.translate(
            offset: Offset(0, 40),
            child: Container(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  updateSeen();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return LoginScreen();
                  }));
                },
                child: Text(
                  AppLocalization.of(context).getTranslated("button_skip1"),
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, 180),
            child: Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),
            ),
          ),
          _currentPage != _numPages - 1
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    child: Transform.translate(
                      offset: Offset(0, -10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            AppLocalization.of(context)
                                .getTranslated("button_next1"),
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 24.0,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Icon(
                            Icons.arrow_forward,
                            color: whiteColor,
                            size: 32.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Text(''),
          _currentPage == _numPages - 1
              ? Transform.translate(
                  offset: Offset(0, -70),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(whiteColor),

                        ),

                        child: Text(
                          AppLocalization.of(context)
                              .getTranslated("button_start"),
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 30,
                            letterSpacing: 1,
                          ),
                        ),
                        onPressed: () {
                          updateSeen();
                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return LoginScreen();
                          }));
                        },
                      ),
                    ),
                  ),
                )
              : Text(''),
        ],
      ),
    );
  }

  void updateSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("seen", true);
  }
}

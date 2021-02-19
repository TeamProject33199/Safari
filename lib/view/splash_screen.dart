import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project/view/on_boarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer_screens/animated_drawer_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "splash_screen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isSeen = false;
  bool _isLogged = false;


  @override
  void initState() {
    _checkSeen();
    _checkLoggedIn();
    super.initState();
  }


  delayRoute() {
    Future.delayed(Duration(seconds: 3), () {}).then((value) {
      if (_isSeen) if (_isLogged)
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AnimatedDrawer()));
      else
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      else
        Navigator.of(context).pushReplacementNamed(OnBoardingScreen.id);
    });
  }

  _checkLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.containsKey("KeepMeLoggedIn")) {
      _isLogged = (pref.getBool('KeepMeLoggedIn') ?? false);
    }
  }

  _checkSeen() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.containsKey("seen")) {
      _isSeen = (pref.getBool('seen') ?? false);
    }
    delayRoute();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Image(
            image: AssetImage("assets/images/air.jpg"),
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Transform.translate(
                offset: Offset(0, 30),
                child: Center(
                  child: Image.asset(
                    "assets/images/splashlogo1.png",
                    fit: BoxFit.fill,
                    width: 220,
                    height: 120,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 90),
                child: Divider(
                  color: Colors.white,
                  height: 1.5,
                  thickness: 2,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Hotels . Tours . Cars",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Transform.translate(
                  offset: Offset(0, 180),
                  child: SpinKitRing(
                    color: Colors.white,
                    size: 45,
                    lineWidth: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

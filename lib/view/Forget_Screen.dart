import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/Controllers/internet_connection/customfun.dart';
import 'package:project/Controllers/internet_connection/locator.dart';
import 'package:project/constants_colors.dart';
import 'package:project/locale_language/localization_delegate.dart';
import 'package:project/view/login_screen.dart';

class ForgetScreen extends StatefulWidget {
  @override
  _ForgetScreenState createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  var registerKey = GlobalKey<ScaffoldState>();
  FirebaseAuth _auth = FirebaseAuth.instance;

  var _formKey = GlobalKey<FormState>();
  OutlineInputBorder borderE = OutlineInputBorder(
    borderSide: BorderSide(
      color: primary200Color,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(50),
  );

  OutlineInputBorder borderF = OutlineInputBorder(
    borderSide: BorderSide(
      width: 2,
      color: primaryColor,
    ),
    borderRadius: BorderRadius.circular(50),
  );
  var funcFile = locator<CustomFunction>();
  bool sendMe=false;
  bool connected=false;
  int alreadyConnected=0;
  Timer timer;

  @override
  void initState() {
    internetCheck();
    checkMyInternet();
    timer = Timer.periodic(Duration(seconds: 20), (Timer t) => internetCheck());
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Theme(
      data: ThemeData(fontFamily: 'SFDisplay'),
      child: Stack(
        children: [
          _background(context,screenHeight,screenWidth),
          Scaffold(
            key: registerKey,
            backgroundColor: transparent,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: Offset(0, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 35,right: 35),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                            elevation: 8,
                            child: Image(
                              image: AssetImage("assets/images/icon_app1.png"),
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 35, top: 10,right: 35),
                          child: Text(
                            "${AppLocalization.of(context).getTranslated("login_description1")}\n${AppLocalization.of(context).getTranslated("login_description2")}",
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 32,
                                height: 1.2,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Expanded(
                    child: Container(
                      width: screenWidth,
                      height: screenHeight,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                      ),
                      child: _form(context,screenWidth),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _background(BuildContext context,screenHeight,screenWidth) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      width: screenWidth,
      height: screenHeight * 0.45,
      imageUrl:
          "https://images.pexels.com/photos/3727255/pexels-photo-3727255.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  Widget _form(BuildContext context,screenWidth) {

    return ListView(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              AppLocalization.of(context).getTranslated("text_forget_password"),
              style: TextStyle(
                  fontSize: 32,
                  color: primaryColor,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(
                    color: blackColor,
                  ),
                  decoration: InputDecoration(
                    labelText: AppLocalization.of(context).getTranslated("text_username_forget"),
                    labelStyle: TextStyle(inherit: true, color: blackColor),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: primaryColor,
                    ),
                    fillColor: whiteColor,
                    border: borderE,
                    focusedBorder: borderF,
                    disabledBorder: borderE,
                    enabledBorder: borderE,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return AppLocalization.of(context).getTranslated("required_field_email_forget");
                    } else if (!RegExp(
                            "^[a-zA-Z0-9.!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*")
                        .hasMatch(value)) {
                      return AppLocalization.of(context).getTranslated("validated_field_email_forget");
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: screenWidth,
                  height: 55,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: RaisedButton(
                    color: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Text(
                      AppLocalization.of(context).getTranslated("button_submit"),
                      style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        letterSpacing: 1.1,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        try {
                          checkMyInternet();
                          if (sendMe) {
                            await _auth
                                .sendPasswordResetEmail(
                              email: _emailController.text.trim(),
                            )
                                .catchError((onError) =>
                                print(
                                    'Error sending email verification $onError'))
                                .then((value) =>
                                print('Successfully sent email verification'))
                                .then((_) =>
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen())));
                          } else{
                        Fluttertoast.showToast(msg: "YOU NOT CONNECTED TO INTERNET", toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb:2,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                        print("YOU NOT CONNECTED TO INTERNET");
                      }

                        }catch (e) {
                          registerKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text("$e"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalization.of(context).getTranslated("text_i_have_an_account_register"),
                      style: TextStyle(
                          fontSize: 18,
                          color: grey600Color,
                          fontWeight: FontWeight.bold),
                    ),
                    FlatButton(
                      minWidth: 0,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        AppLocalization.of(context).getTranslated("flat_button_login_register"),
                        style: TextStyle(
                          fontSize: 18,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  internetCheck() async {
    var internet = await funcFile.isInternet();
    var internet2 = await funcFile.checkInternetAccess();

    if (internet && internet2) {
      if(mounted==false){
        return;
      }
      setState(() {
        connected=true;
      });
      if(alreadyConnected==0&&connected==true){
        funcFile.showInSnackBar(networkstate:connected,scaffoldKey: registerKey);
        if(mounted==false){
          return;
        }
        setState(() {
          alreadyConnected=1;
        });
      }
    } else {
      if(mounted==false){
        return;
      }
      setState(() {
        connected=false;
        alreadyConnected=0;
      });

      funcFile.showInSnackBar(networkstate:connected,scaffoldKey: registerKey);
    }
  }

  checkMyInternet(){
    funcFile.isInternet().then((value) {
      funcFile.checkInternetAccess().then((value2) {

        if( value && value2){
          if(mounted==false){
            return;
          }
          setState(() {
            sendMe= true;
          });
        }else{
          if(mounted==false){
            return;
          }
          setState(() {
            sendMe= false;
          });
        }
      });
    });

  }

}

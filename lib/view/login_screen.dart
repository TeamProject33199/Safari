import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:project/Controllers/authentication/provider_auth.dart';
import 'package:project/Controllers/internet_connection/customfun.dart';
import 'package:project/Controllers/internet_connection/locator.dart';
import 'package:project/constants_colors.dart';
import 'package:project/locale_language/localization_delegate.dart';
import 'package:project/models/prograss_model_hud.dart';
import 'package:project/view/Forget_Screen.dart';
import 'package:project/view/register.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drawer_screens/animated_drawer_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var loginKey = GlobalKey<ScaffoldMessengerState>();

  bool keepMeLoggedIn = false;
  bool _obscureText = false;

  var funcFile = locator<CustomFunction>();
  bool sendMe=false;
  bool connected=false;
  int alreadyConnected=0;
  Timer timer;

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
    var authProvider = Provider.of<AuthProvider>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Theme(
      data: ThemeData(fontFamily: 'SFDisplay'),
      child: Stack(
        children: [
          _background(context,screenWidth,screenHeight),
          Scaffold(
            backgroundColor: transparent,
            key: loginKey,
            body: ModalProgressHUD(
              inAsyncCall: Provider.of<prograssHud>(context).isLoading,
              child: SafeArea(
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
                                image:
                                    AssetImage("assets/images/icon_app1.png"),
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 35, top: 10,right: 35,),
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
                      height: 45,
                    ),
                    Expanded(
                      child: Container(
                        width: screenWidth,
                        height: screenHeight,
                        decoration: BoxDecoration(
                          color: grey50Color,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35),
                          ),
                        ),
                        child: _form(context, authProvider),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _background(BuildContext context,screenWidth,screenHeight) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      width: screenWidth,
      height: screenHeight * 0.45,
      imageUrl:
          "https://images.pexels.com/photos/3727255/pexels-photo-3727255.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  Widget _form(BuildContext context, authProvider) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
           AppLocalization.of(context).getTranslated("text_login"),
            style: TextStyle(
                fontSize: 32, color: primaryColor, fontWeight: FontWeight.bold,),
            textAlign: TextAlign.center,
          ),
        ),
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  style: TextStyle(
                    color: blackColor,
                  ),
                  decoration: InputDecoration(
                      labelText:AppLocalization.of(context).getTranslated("text_username_login"),
                      labelStyle: TextStyle(inherit: true, color: blackColor),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: primaryColor,
                      ),
                      fillColor: whiteColor,
                      filled: true,
                      enabledBorder: borderE,
                      focusedBorder: borderF,
                      border: borderE),
                  validator: (value) {
                    if (value.isEmpty) {
                      return AppLocalization.of(context).getTranslated("required_field_email_login");
                    } else if (!RegExp(
                            "^[a-zA-Z0-9.!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*")
                        .hasMatch(value)) {
                      return AppLocalization.of(context).getTranslated("validated_field_email_login");
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: _passwordController,
                  style: TextStyle(
                    color: blackColor,
                  ),
                  obscureText: !_obscureText,
                  decoration: InputDecoration(
                      prefixStyle: TextStyle(
                        color: whiteColor,
                      ),
                      labelText: AppLocalization.of(context).getTranslated("text_password_login"),
                      labelStyle: TextStyle(inherit: true, color: blackColor),
                      prefixIcon: Icon(
                        Icons.lock_outlined,
                        color: primaryColor,
                      ),
                      suffixIcon: IconButton(
                        color: primaryColor,
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      fillColor: whiteColor,
                      filled: true,
                      enabledBorder: borderE,
                      focusedBorder: borderF,
                      border: borderE),
                  validator: (value) {
                    if (value.isEmpty) {
                      return AppLocalization.of(context).getTranslated("required_field_password_login");
                    } else if (value.length < 6) {
                      return AppLocalization.of(context).getTranslated("strength_field_password_login");
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: InkWell(
                    child: Align(
                      alignment: AppLocalization.of(context).locale.languageCode=="ar"?Alignment.centerLeft:Alignment.centerRight,
                      child: Text(
                        AppLocalization.of(context).getTranslated("button_forget_password"),
                        style: TextStyle(
                          fontSize: 14,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgetScreen()));
                    },
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                        activeColor: primaryColor,
                        value: keepMeLoggedIn,
                        onChanged: (value) {
                          setState(() {
                            keepMeLoggedIn = value;
                          });
                        }),
                    Text(
                      AppLocalization.of(context).getTranslated("text_remember_me"),
                      style: TextStyle(color: blackColor, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Builder(
                  builder: (context) => Container(
                    width: double.infinity,
                    height: 55,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(primaryColor),shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),),),
                      child: Text(
                        AppLocalization.of(context).getTranslated("button_login"),
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 1.1,
                        ),
                      ),
                      onPressed: () async {
                        final model = Provider.of<prograssHud>(context, listen: false);

                        if (_formKey.currentState.validate()) {
                          model.changeLoading(true);

                          if (keepMeLoggedIn == true) {
                            keepUserLoggedIn();
                          }
                          checkMyInternet();
                          if (sendMe){
                            if (await authProvider.login(_emailController.text.trim(), _passwordController.text.trim()) != null) {
                              model.changeLoading(false);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AnimatedDrawer(),
                                ),
                              );
                            }
                            else {
                              model.changeLoading(false);
                              loginKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text(authProvider.errorMessage.toString()),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }

                          }else{
                            model.changeLoading(false);
                            Fluttertoast.showToast(msg: "YOU NOT CONNECTED TO INTERNET", toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb:2,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            print("YOU NOT CONNECTED TO INTERNET");
                          }

                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalization.of(context).getTranslated("text_create_new_user"),
                      style: TextStyle(
                          fontSize: 16,
                          color: grey600Color,
                          fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                     // minWidth: 0,
                      style: ButtonStyle(minimumSize: MaterialStateProperty.all(Size.zero)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()));
                      },
                      child: Text(
                        AppLocalization.of(context).getTranslated("flat_button_register"),
                        style: TextStyle(
                          fontSize: 16,
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
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalization.of(context).getTranslated("text_or_login_with"),
                    style: TextStyle(
                        fontSize: 16,
                        color: grey500Color,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                _bottom(context, authProvider),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottom(BuildContext context, AuthProvider authProvider) {
    final model = Provider.of<prograssHud>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: Image(
            image: AssetImage("assets/images/google.png"),
            fit: BoxFit.cover,
            width: 35,
            height: 35,
          ),
          onTap: () async {
            model.changeLoading(true);

            setState(() {
              keepMeLoggedIn = true;
            });
            if (keepMeLoggedIn == true) {
              keepUserLoggedIn();
            }

            if (await authProvider.signInWithGoogle() != null) {
              model.changeLoading(false);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AnimatedDrawer(),
                ),
              );
            } else {
              model.changeLoading(false);
              loginKey.currentState.showSnackBar(
                SnackBar(
                  content: Text(authProvider.errorMessage),
                  duration: Duration(seconds: 2),
                ),
              );
            }
            await authProvider.saveGoogleUser();
          },
        ),
        SizedBox(
          width: 25,
        ),
        GestureDetector(
          child: Image(
            image: AssetImage("assets/images/facebook.png"),
            fit: BoxFit.cover,
            width: 35,
            height: 35,
          ),
          onTap: () async {
            setState(() {
              keepMeLoggedIn = true;
            });
            if (keepMeLoggedIn == true) {
              keepUserLoggedIn();
            }
            if (await authProvider.handleFacebookLogin() != null) {
              model.changeLoading(false);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AnimatedDrawer(),
                ),
              );
            } else {
              model.changeLoading(false);
              loginKey.currentState.showSnackBar(
                SnackBar(
                  content: Text(authProvider.errorMessage),
                  duration: Duration(seconds: 2),
                ),
              );
            }
            await authProvider.saveFaceBookUser();
          },
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
        funcFile.showInSnackBar(networkstate:connected,context: context);
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

      funcFile.showInSnackBar(networkstate:connected,context: context);
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


  void keepUserLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("KeepMeLoggedIn", keepMeLoggedIn);
  }
}

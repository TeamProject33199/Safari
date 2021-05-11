import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:project/Controllers/authentication/provider_auth.dart';
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
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  String currentUser ;
  CollectionReference travelerCollection = FirebaseFirestore.instance.collection('Travelers');

    var _formKey = GlobalKey<FormState>();
 var  _formKey2 = GlobalKey<FormState>();
  var loginKey = GlobalKey<ScaffoldMessengerState>();

  bool keepMeLoggedIn = false;
  bool _obscureText = false;



  String genderValue;
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
  TextStyle _labelStyle = TextStyle(color: blackColor, inherit: true);

  void radioButtonChanges(String value) {
    setState(() {
      genderValue = value;
    });
  }
  // ignore: missing_return
  Stream<DocumentSnapshot> passData()  {
    try {
      travelerCollection.doc(FirebaseAuth.instance.currentUser.uid).get().then((value) {
        if(mounted==false){
          return;
        }
        setState(() {
          currentUser = value.data()["traveler_id"];
        });
      });
    } catch (e) {
      print("${e.toString()}");
    }
  }

  @override
  void initState() {
    setState(() {
      genderValue = "Male";
    });
    passData();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
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
          _background(context, screenWidth, screenHeight),
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
                            padding: const EdgeInsets.only(left: 35, right: 35),
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
                            padding: const EdgeInsets.only(
                              left: 35,
                              top: 10,
                              right: 35,
                            ),
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

  Widget _background(BuildContext context, screenWidth, screenHeight) {
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
              fontSize: 32,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
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
                      labelText: AppLocalization.of(context)
                          .getTranslated("text_username_login"),
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
                      return AppLocalization.of(context)
                          .getTranslated("required_field_email_login");
                    } else if (!RegExp(
                            "^[a-zA-Z0-9.!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*")
                        .hasMatch(value)) {
                      return AppLocalization.of(context)
                          .getTranslated("validated_field_email_login");
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
                      labelText: AppLocalization.of(context)
                          .getTranslated("text_password_login"),
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
                      return AppLocalization.of(context)
                          .getTranslated("required_field_password_login");
                    } else if (value.length < 6) {
                      return AppLocalization.of(context)
                          .getTranslated("strength_field_password_login");
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
                      alignment:
                          AppLocalization.of(context).locale.languageCode ==
                                  "ar"
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                      child: Text(
                        AppLocalization.of(context)
                            .getTranslated("button_forget_password"),
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
                      AppLocalization.of(context)
                          .getTranslated("text_remember_me"),
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
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(primaryColor),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        AppLocalization.of(context)
                            .getTranslated("button_login"),
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

                            if (await authProvider.login(_emailController.text.trim(), _passwordController.text.trim()) != null) {
                              model.changeLoading(false);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AnimatedDrawer(),
                                ),
                              );
                            } else {
                              model.changeLoading(false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      authProvider.errorMessage.toString()),
                                  duration: Duration(seconds: 2),
                                ),
                              );
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
                      AppLocalization.of(context)
                          .getTranslated("text_create_new_user"),
                      style: TextStyle(
                          fontSize: 16,
                          color: grey600Color,
                          fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      // minWidth: 0,
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size.zero)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()));
                      },
                      child: Text(
                        AppLocalization.of(context)
                            .getTranslated("flat_button_register"),
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
                    AppLocalization.of(context)
                        .getTranslated("text_or_login_with"),
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

  Widget _bottom(BuildContext cox, AuthProvider authProvider) {
    final model = Provider.of<prograssHud>(cox, listen: false);

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

              currentUser!=null?Navigator.pushReplacement(cox, MaterialPageRoute(builder: (cox) => AnimatedDrawer(),),
            ) :otherDataGoogle(cox,authProvider);
            } else {
              model.changeLoading(false);
              ScaffoldMessenger.of(cox).showSnackBar(
                SnackBar(
                  content: Text(authProvider.errorMessage),
                  duration: Duration(seconds: 2),
                ),
              );
            }
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
           // model.changeLoading(true);

            setState(() {
              keepMeLoggedIn = true;
            });
            if (keepMeLoggedIn == true) {
              keepUserLoggedIn();
            }
            if (await authProvider.handleFacebookLogin() != null) {
            //  model.changeLoading(false);
              otherDataFb(cox,authProvider);
            } else {
            //  model.changeLoading(false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(authProvider.errorMessage),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
        ),
      ],
    );
  }


  void otherDataGoogle(BuildContext cx,AuthProvider authProvider) {
    final model = Provider.of<prograssHud>(cx, listen: false);

    showModalBottomSheet(
        context: cx,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) => Padding(
              padding: EdgeInsets.only(
                //  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 10,
                  right: 10,
                  top: 15
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          AppLocalization.of(bc)
                              .getTranslated("add_other_data"),
                          style: TextStyle(
                              color: blackColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLines: 1,
                        controller: _addressController,
                        style: TextStyle(
                          color: blackColor,
                        ),
                        decoration: InputDecoration(
                          labelText: AppLocalization.of(bc)
                              .getTranslated("text_address"),
                          labelStyle: _labelStyle,
                          prefixIcon: Icon(
                            Icons.person,
                            color: primaryColor,
                          ),
                          fillColor: whiteColor,
                          focusedBorder: borderF,
                          enabledBorder: borderE,
                          border: borderE,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppLocalization.of(bc)
                                .getTranslated("required_field_address");
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLines: 1,
                        maxLength: 11,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          color: blackColor,
                        ),
                        decoration: InputDecoration(
                          labelText: AppLocalization.of(context)
                              .getTranslated("text_phone"),
                          labelStyle: _labelStyle,
                          prefixIcon: Icon(
                            Icons.person,
                            color: primaryColor,
                          ),
                          fillColor: whiteColor,
                          focusedBorder: borderF,
                          enabledBorder: borderE,
                          border: borderE,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppLocalization.of(context)
                                .getTranslated("required_field_phone");
                          } else if (value.length < 11) {
                            return AppLocalization.of(context)
                                .getTranslated("check_digits_field_phone");
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Radio(
                                value: AppLocalization.of(context)
                                    .getTranslated("text_male"),
                                groupValue: genderValue,
                                onChanged: (value) {
                                  setState(() {
                                    genderValue = value;
                                  });
                                  radioButtonChanges(value);
                                },
                                activeColor: primaryColor,
                              ),
                              Text(
                                AppLocalization.of(context)
                                    .getTranslated("text_male"),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Radio(
                                value: AppLocalization.of(context)
                                    .getTranslated("text_female"),
                                groupValue: genderValue,
                                onChanged: (value) {
                                  setState(() {
                                    genderValue = value;
                                  });
                                  radioButtonChanges(value);
                                },
                                activeColor: primaryColor,
                              ),
                              Text(
                                AppLocalization.of(context)
                                    .getTranslated("text_female"),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width*0.25,
                            child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(primaryColor),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey2.currentState.validate()) {
                                    model.changeLoading(true);
                                    authProvider.saveGoogleUser(_addressController.text,_phoneController.text,genderValue);
                                    model.changeLoading(false);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (bc) => AnimatedDrawer(),
                                      ),
                                    );
                                    ScaffoldMessenger.of(bc).showSnackBar(SnackBar(
                                        content: Text(
                                            "You Added Data  Successful")));
                                    print("You Added Data  Successful");
                                  }
                                },
                                child: Text(
                                  AppLocalization.of(bc)
                                      .getTranslated("button_add_otherData"),
                                  style: TextStyle(color: whiteColor),

                                )),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void otherDataFb(BuildContext cox,AuthProvider authProvider) {
    final model = Provider.of<prograssHud>(cox, listen: false);

    showModalBottomSheet(
        context: cox,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) => Padding(
              padding: EdgeInsets.only(
                //  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 10,
                  right: 10,
                  top: 15
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          AppLocalization.of(bc)
                              .getTranslated("add_other_data"),
                          style: TextStyle(
                              color: blackColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLines: 1,
                        controller: _addressController,
                        style: TextStyle(
                          color: blackColor,
                        ),
                        decoration: InputDecoration(
                          labelText: AppLocalization.of(bc)
                              .getTranslated("text_address"),
                          labelStyle: _labelStyle,
                          prefixIcon: Icon(
                            Icons.person,
                            color: primaryColor,
                          ),
                          fillColor: whiteColor,
                          focusedBorder: borderF,
                          enabledBorder: borderE,
                          border: borderE,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppLocalization.of(bc)
                                .getTranslated("required_field_address");
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLines: 1,
                        maxLength: 11,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          color: blackColor,
                        ),
                        decoration: InputDecoration(
                          labelText: AppLocalization.of(bc)
                              .getTranslated("text_phone"),
                          labelStyle: _labelStyle,
                          prefixIcon: Icon(
                            Icons.person,
                            color: primaryColor,
                          ),
                          fillColor: whiteColor,
                          focusedBorder: borderF,
                          enabledBorder: borderE,
                          border: borderE,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppLocalization.of(bc)
                                .getTranslated("required_field_phone");
                          } else if (value.length < 11) {
                            return AppLocalization.of(context)
                                .getTranslated("check_digits_field_phone");
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Radio(
                                value: AppLocalization.of(bc)
                                    .getTranslated("text_male"),
                                groupValue: genderValue,
                                onChanged: (value) {
                                  setState(() {
                                    genderValue = value;
                                  });
                                  radioButtonChanges(value);
                                },
                                activeColor: primaryColor,
                              ),
                              Text(
                                AppLocalization.of(bc)
                                    .getTranslated("text_male"),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Radio(
                                value: AppLocalization.of(bc)
                                    .getTranslated("text_female"),
                                groupValue: genderValue,
                                onChanged: (value) {
                                  setState(() {
                                    genderValue = value;
                                  });
                                  radioButtonChanges(value);
                                },
                                activeColor: primaryColor,
                              ),
                              Text(
                                AppLocalization.of(bc)
                                    .getTranslated("text_female"),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width*0.25,
                            child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(primaryColor),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey2.currentState.validate()) {
                                    model.changeLoading(true);
                                    authProvider.saveFaceBookUser(_addressController.text,_phoneController.text,genderValue);
                                    model.changeLoading(false);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (bc) => AnimatedDrawer(),
                                      ),
                                    );
                                    ScaffoldMessenger.of(bc).showSnackBar(SnackBar(
                                        content: Text(
                                            "You Added Data  Successful")));
                                    print("You Added Data  Successful");
                                  }
                                },
                                child: Text(
                                  AppLocalization.of(bc)
                                      .getTranslated("button_add_otherData"),
                                  style: TextStyle(color: whiteColor),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }



  void keepUserLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("KeepMeLoggedIn", keepMeLoggedIn);
  }
}

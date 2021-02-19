import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:project/Controllers/authentication/provider_auth.dart';
import 'package:project/Controllers/firestore/DataBase.dart';
import 'package:project/Controllers/internet_connection/customfun.dart';
import 'package:project/Controllers/internet_connection/locator.dart';
import 'package:project/constants_colors.dart';
import 'package:project/locale_language/localization_delegate.dart';
import 'package:project/models/prograss_model_hud.dart';
import 'package:project/models/users.dart';
import 'package:project/view/login_screen.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DataBase dataBase = DataBase();

  bool _obscureText1 = false;
  bool _obscureText2 = false;
  File _image;
  String _url;

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

  String genderValue;
  String choice;

  var funcFile = locator<CustomFunction>();
  bool sendMe=false;
  bool connected=false;
  int alreadyConnected=0;
  Timer timer;

  void radioButtonChanges(String value) {
    setState(() {
      genderValue = value;
      switch (value) {
        case 'Male':
          choice = value;

          break;
        case 'Female':
          choice = value;
          break;
        default:
          choice = null;
      }
      return choice;
    });
  }

  @override
  void initState() {
    setState(() {
      choice = "Male";
      genderValue = "Male";
    });
    internetCheck();
    checkMyInternet();
    timer = Timer.periodic(Duration(seconds: 20), (Timer t) => internetCheck());
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
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
          _background(context,screenWidth,screenHeight),
          Scaffold(
            backgroundColor: transparent,
            key: _scaffoldKey,
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
                      height: 45,
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

  Widget _form(BuildContext context,screenWidth) {
    var authProvider = Provider.of<AuthProvider>(context);

    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalization.of(context).getTranslated("flat_button_register"),
                style: TextStyle(
                    fontSize: 32,
                    color: primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          child: CustomPaint(
                            painter: CirclePainter(),
                            child: CircleAvatar(
                              backgroundColor: transparent,
                              backgroundImage:
                                  _image != null ? FileImage(_image) : null,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showPicker(context);
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: _image != null
                              ? transparent
                              : primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalization.of(context).getTranslated("text_upload_photo"),
                    style: TextStyle(color: grey700Color),
                  ),
                ],
              ),
            ],
          ),
        ),
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 25, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  maxLines: 1,
                  controller: _fullNameController,
                  style: TextStyle(
                    color: blackColor,
                  ),
                  decoration: InputDecoration(
                    labelText: AppLocalization.of(context).getTranslated("text_full_name1"),
                    labelStyle: _labelStyle,
                    prefixIcon: Icon(
                      Icons.person,
                      color: primaryColor,
                    ),
                    fillColor: Colors.white,
                    focusedBorder: borderF,
                    enabledBorder: borderE,
                    border: borderE,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return AppLocalization.of(context).getTranslated("required_field_full_name");
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: AppLocalization.of(context).getTranslated("text_username_register"),
                    labelStyle: _labelStyle,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: primaryColor,
                    ),
                    fillColor: Colors.white,
                    focusedBorder: borderF,
                    enabledBorder: borderE,
                    border: borderE,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return AppLocalization.of(context).getTranslated("required_field_email_register");
                    } else if (!RegExp("^[a-zA-Z0-9.!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*").hasMatch(value)) {
                      return AppLocalization.of(context).getTranslated("validated_field_email_register");
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _passwordController,
                  style: TextStyle(
                    color: blackColor,
                  ),
                  obscureText: !_obscureText1,
                  decoration: InputDecoration(
                    prefixStyle: TextStyle(
                      color: grey50Color,
                    ),
                    labelText: AppLocalization.of(context).getTranslated("text_password_register"),
                    labelStyle: _labelStyle,
                    prefixIcon: Icon(
                      Icons.lock_outlined,
                      color: primaryColor,
                    ),
                    suffixIcon: IconButton(
                      color: primaryColor,
                      icon: Icon(
                        _obscureText1 ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText1 = !_obscureText1;
                        });
                      },
                    ),
                    fillColor: whiteColor,
                    focusedBorder: borderF,
                    enabledBorder: borderE,
                    border: borderE,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return AppLocalization.of(context).getTranslated("required_field_password_register");
                    } else if (value.length < 6) {
                      return AppLocalization.of(context).getTranslated("strength_field_password_register");
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  style: TextStyle(
                    color: blackColor,
                  ),
                  obscureText: !_obscureText2,
                  decoration: InputDecoration(
                    prefixStyle: TextStyle(
                      color: grey50Color,
                    ),
                    labelText: AppLocalization.of(context).getTranslated("text_confirm_password"),
                    labelStyle: _labelStyle,
                    prefixIcon: Icon(
                      Icons.lock_outlined,
                      color: primaryColor,
                    ),
                    suffixIcon: IconButton(
                      color: primaryColor,
                      icon: Icon(
                        _obscureText2 ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText2 = !_obscureText2;
                        });
                      },
                    ),
                    fillColor: whiteColor,
                    focusedBorder: borderF,
                    enabledBorder: borderE,
                    border: borderE,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return AppLocalization.of(context).getTranslated("required_field_confirm_password");
                    } else if (value != _passwordController.text) {
                      return AppLocalization.of(context).getTranslated("match_field_confirm_password");
                    } else if (value.length < 6) {
                      return AppLocalization.of(context).getTranslated("strength_field_confirm_password");
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  maxLength: 11,
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  style: TextStyle(
                    color: blackColor,
                  ),
                  decoration: InputDecoration(
                    labelText: AppLocalization.of(context).getTranslated("text_phone"),
                    labelStyle: _labelStyle,
                    prefixIcon: Icon(
                      Icons.phone,
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
                      return AppLocalization.of(context).getTranslated("required_field_phone");
                    } else if (value.length < 11) {
                      return AppLocalization.of(context).getTranslated("check_digits_field_phone");
                    } else
                      return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  keyboardType: TextInputType.streetAddress,
                  controller: _addressController,
                  style: TextStyle(
                    color: blackColor,
                  ),
                  decoration: InputDecoration(
                    labelText: AppLocalization.of(context).getTranslated("text_address"),
                    labelStyle: _labelStyle,
                    prefixIcon: Icon(
                      Icons.location_city,
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
                      return AppLocalization.of(context).getTranslated("required_field_address");
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      children: [
                        Radio(
                          value: AppLocalization.of(context).getTranslated("text_male"),
                          groupValue: genderValue,
                          onChanged: radioButtonChanges,
                          activeColor: primaryColor,
                        ),
                        Text(
                          AppLocalization.of(context).getTranslated("text_male"),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Radio(
                          value: AppLocalization.of(context).getTranslated("text_female"),
                          groupValue: genderValue,
                          onChanged: radioButtonChanges,
                          activeColor: primaryColor,
                        ),
                        Text(
                          AppLocalization.of(context).getTranslated("text_female"),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
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
                      AppLocalization.of(context).getTranslated("button_register"),
                      style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1.1,
                      ),
                    ),
                    onPressed: () async {
                      final model = Provider.of<prograssHud>(context, listen: false);

                      if (_formKey.currentState.validate() && _image != null) {
                        model.changeLoading(true);
                        checkMyInternet();
                        if(sendMe){
                          if (await authProvider.signUp(
                              _emailController.text.trim(),
                              _passwordController.text.trim()) !=
                              null) {
                            model.changeLoading(false);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          } else {
                            model.changeLoading(false);
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text(authProvider.errorMessage.toString()),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                          await _uploadImage(_image);
                          await storeData(context,authProvider);
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
                SizedBox(
                  height: 20,
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
                            decoration: TextDecoration.underline),
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

  Future _uploadImage(File image) async {

    FirebaseStorage  storage = FirebaseStorage.instanceFor(bucket: "gs://safari-726f0.appspot.com");
    final Reference storageReference = storage.ref().child(p.basename(image.path));
    await storageReference.putFile(image).whenComplete(()async{
      await storageReference.getDownloadURL().then((value){
        _url=value;
      });
    });

    return _url;
  }

  Future storeData(BuildContext context,AuthProvider authProvider) async {

    await dataBase.addTraveler(
      Travelers(
        id: authProvider.currentUser(),
        username: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _fullNameController.text.trim(),
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
        gender: choice,
        image: _url,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future getImageFromGallery() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please select Your Image")));
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please select Your Image")));
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(
                        Icons.photo_library,
                        color: primaryColor,
                      ),
                      title: Text(
                        AppLocalization.of(context).getTranslated("text_gallery"),
                        style: TextStyle(color: primaryColor),
                      ),
                      onTap: () {
                        getImageFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(
                      Icons.photo_camera,
                      color: primaryColor,
                    ),
                    title: Text(
                      AppLocalization.of(context).getTranslated("text_camera"),
                      style: TextStyle(color: primaryColor),
                    ),
                    onTap: () {
                      getImageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
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
        funcFile.showInSnackBar(networkstate:connected,scaffoldKey:_scaffoldKey);
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

      funcFile.showInSnackBar(networkstate:connected,scaffoldKey:_scaffoldKey);
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

class CirclePainter extends CustomPainter {
  final _paint = Paint()
    ..color = primaryColor
    ..strokeWidth = 1
    // Use [PaintingStyle.fill] if you want the circle to be filled.
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

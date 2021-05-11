import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/Controllers/authentication/provider_auth.dart';
import 'package:project/constants_colors.dart';
import 'file:///D:/project/SafariProject-master/lib/locale_language/constants_languages.dart';
import 'package:project/locale_language/dropdown_languages.dart';
import 'package:project/locale_language/localization_delegate.dart';
import 'package:project/main.dart';
import 'package:project/view/drawer_screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../login_screen.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  String text = 'https://play.google.com/store/apps/details?id=com.safari.project';
  String subject = 'Safari App';

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).getTranslated("settings_title"),
          style: TextStyle(
              color: blackColor, fontSize: 24, fontWeight: FontWeight.w600),
        ),
        backgroundColor: transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: DropdownButton(
                  underline: Container(),
                  iconEnabledColor: primaryColor,
                  iconDisabledColor: primaryColor,
                  isExpanded: true,
                  icon: Icon(FontAwesomeIcons.chevronDown),
                  iconSize: 16,
                  hint: Text(
                    AppLocalization.of(context).getTranslated("change_language"),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: grey900Color,
                    ),
                  ),
                  style: TextStyle(
                      color: grey900Color,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                  items: Language.LanguageList()
                      .map<DropdownMenuItem<Language>>((lang) {
                    return DropdownMenuItem(
                      value: lang,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(lang.flag),
                          Text(
                            lang.name,
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (Language value) {
                    setState(() {
                      _changeLanguage(value);
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(
                  AppLocalization.of(context).getTranslated("text_profile_settings"),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                trailing: Icon(
                  FontAwesomeIcons.solidUserCircle,
                  color: primaryColor,
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
              ),
              ListTile(
                title: Text(
                  AppLocalization.of(context).getTranslated("text_privacy"),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                trailing: Icon(
                  Icons.privacy_tip,
                  color: primaryColor,
                ),
                onTap: () {
                  _privacyPolicy();
                },
              ),
              ListTile(
                title: Text(
                  AppLocalization.of(context).getTranslated("text_share"),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                trailing: Icon(
                  Icons.share,
                  color: primaryColor,
                ),
                onTap: () {
                  final RenderBox box = context.findRenderObject();
                  Share.share(text, subject: subject, sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                },
              ),

              Padding(
                padding: const EdgeInsets.only(top: 70,bottom: 50),
                child: InkWell(
                  onTap: () {
                    _logOut(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalization.of(context).getTranslated("text_logout_settings"),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: redColor),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.logout,
                        color: redColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  _privacyPolicy() async {
    const url = 'https://safari.flycricket.io/privacy.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text( throw 'Could not launch $url')));


    }
  }

  void _logOut(BuildContext context,) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("KeepMeLoggedIn");
    await authProvider.logout();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

}
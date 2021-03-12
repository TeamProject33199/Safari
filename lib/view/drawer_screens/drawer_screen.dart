import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/Controllers/authentication/provider_auth.dart';
import 'package:project/Controllers/firestore/DataBase.dart';
import 'package:project/constants_colors.dart';
import 'package:project/locale_language/localization_delegate.dart';
import 'package:project/models/Provider_Offset.dart';
import 'package:project/models/users.dart';
import 'package:project/view/drawer_screens/settings_screen.dart';
import 'favorite/favorites_screen.dart';
import 'package:project/view/login_screen.dart';
import 'package:project/view/drawer_screens/contactus_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification/notifications_screen.dart';
import 'profile_screen.dart';

class DrawerScreen extends StatefulWidget {

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  CollectionReference travelerCollection =
      FirebaseFirestore.instance.collection('Travelers');
  User firebaseUser;
  FirebaseAuth _auth = FirebaseAuth.instance;

  // ignore: missing_return
  Stream<DocumentSnapshot> getData()  {

    try {

      if (_auth.currentUser != null) {
        firebaseUser = _auth.currentUser;
      }
      return DataBase().getTraveler(Travelers(id: firebaseUser.uid));

    } catch (e) {
      print("${e.toString()}");
    }

  }


  @override
  void initState() {

     getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var providerType = Provider.of<ProviderOffset>(context, listen: false);

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: AppLocalization.of(context).locale.languageCode == 'ar'
          ? EdgeInsets.only(top: 50, bottom: 45, right: 15)
          : EdgeInsets.only(top: 50, bottom: 45, left: 15),
      color: primaryColor,
      child: StreamBuilder<DocumentSnapshot>(
        stream: getData(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.hasData) {
            var data = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: whiteColor,
                      child: CachedNetworkImage(
                        imageUrl: data["image"] == null
                            ? "https://png.pngtree.com/png-clipart/20190516/original/pngtree-users-vector-icon-png-image_3723374.jpg"
                            : data["image"],
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: 60,
                        height: 60,
                        imageBuilder:(context, imageProvider)=> CircleAvatar(
                          radius: 30,
                          backgroundColor: transparent,
                          backgroundImage: imageProvider,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      AppLocalization.of(context).locale.languageCode ==
                          'ar'
                          ? const EdgeInsets.only(right: 15)
                          : const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data["fullName"] == null
                                ? "Profile Name"
                                : data["fullName"],
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            data["username"] == null
                                ? "UserName"
                                : data["username"],
                            style: TextStyle(
                                color: grey400Color, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          providerType.drawerClose();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.home,
                              color: whiteColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocalization.of(context)
                                  .getTranslated("text_home"),
                              style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return FavoritesScreen();
                              }));
                          providerType.drawerClose();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: whiteColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocalization.of(context)
                                  .getTranslated("text_favorites"),
                              style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return NotificationScreen(index: 0,);
                              }));
                          providerType.drawerClose();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.notifications,
                              color: whiteColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocalization.of(context)
                                  .getTranslated("text_notification"),
                              style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return ProfileScreen();
                              }));
                          providerType.drawerClose();
                        },
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.solidUserCircle,
                              color: whiteColor,
                              size: 22,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocalization.of(context)
                                  .getTranslated("text_profile"),
                              style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return ContactUsScreen();
                              }));
                          providerType.drawerClose();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.help,
                              color: whiteColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocalization.of(context)
                                  .getTranslated("text_contact_us"),
                              style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return SettingScreen();
                            }));
                        providerType.drawerClose();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.settings,
                            color: whiteColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            AppLocalization.of(context)
                                .getTranslated("text_settings"),
                            style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 2,
                      height: 20,
                      color: whiteColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        await _logout(context, providerType);
                      },
                      child: Text(
                        AppLocalization.of(context)
                            .getTranslated("text_logout"),
                        style: TextStyle(
                            color: whiteColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }else
            return Text("No Data");
        },
      ),
    );
  }

  Future _logout(BuildContext context, ProviderOffset offset) async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("KeepMeLoggedIn");
    await authProvider.logout().whenComplete(() {
      if(offset.isDrawerOpen){
         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()),(Route<dynamic> route) => false);
         AppLocalization.of(context).locale.languageCode=='ar'? offset.drawerCloseAR():offset.drawerClose();
      }
      AppLocalization.of(context).locale.languageCode=='ar'? offset.drawerCloseAR():offset.drawerClose();

      print("User signOut Success");
     }).catchError((error) => print(error.toString()));

    AppLocalization.of(context).locale.languageCode=='ar'? offset.drawerCloseAR():offset.drawerClose();

  }
}

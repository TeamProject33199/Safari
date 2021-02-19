import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Controllers/firestore/DataBase.dart';
import 'package:project/constants_colors.dart';
import 'package:project/locale_language/localization_delegate.dart';
import 'package:project/models/users.dart';
import 'package:project/view/services_tabs_screens/car_search_stream.dart';
import 'package:project/view/services_tabs_screens/tour_search_stream.dart';
import '../drawer_screens/profile_screen.dart';
import 'hotel_search_stream.dart';

// ignore: must_be_immutable
class ServicesScreen extends StatefulWidget {
  int selectedIndex = 0;

  ServicesScreen({this.selectedIndex});

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
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
    super.initState();
    getData();
    _tabController = TabController(
        initialIndex: widget.selectedIndex, length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalization.of(context).getTranslated("services_title"),
            style: TextStyle(
                color: blackColor, fontSize: 24, fontWeight: FontWeight.w600),
          ),
          backgroundColor: grey50Color,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: primaryColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProfileScreen();
                }));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10, top: 6, left: 10),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: primaryColor,
                  child: CircleAvatar(
                    backgroundColor: whiteColor,
                    radius: 23,
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: getData(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text(snapshot.error);
                          } else if (snapshot.hasData) {
                            var data=snapshot.data;
                            return CircleAvatar(
                              backgroundColor: transparent,
                              backgroundImage: NetworkImage(data["image"] ==
                                  null
                                  ? "https://png.pngtree.com/png-clipart/20190516/original/pngtree-users-vector-icon-png-image_3723374.jpg"
                                  : data["image"]),
                              radius: 21.5,
                            );
                          }else
                            return Center(child: CircularProgressIndicator(),);
                        }),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.10,
              width: MediaQuery.of(context).size.width,
              child: TabBar(
                indicatorPadding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                controller: _tabController,
                labelColor: primaryColor,
                indicatorColor: primaryColor,
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelColor: grey600Color,
                tabs: [
                  Text(AppLocalization.of(context)
                      .getTranslated("text_tab1_services")),
                  Text(AppLocalization.of(context)
                      .getTranslated("text_tab2_services")),
                  Text(AppLocalization.of(context)
                      .getTranslated("text_tab3_services")),
                ],
              ),
            ),
            Flexible(
              child: TabBarView(
                controller: _tabController,
                children: [

                  HotelSearchStream(),
                  TourSearchStream(),
                  CarSearchStream(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

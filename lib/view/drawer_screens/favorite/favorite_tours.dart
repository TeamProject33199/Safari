import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Controllers/firestore/DataBase.dart';
import 'package:project/constants_colors.dart';
import 'package:project/locale_language/localization_delegate.dart';
import 'package:project/models/tour.dart';
import 'package:project/models/users.dart';
import 'package:project/view/details_screens/tour_details.dart';

class FavoritesTours extends StatefulWidget {

  @override
  _FavoritesToursState createState() => _FavoritesToursState();

  FavoritesTours();
}

class _FavoritesToursState extends State<FavoritesTours> {
  _FavoritesToursState();


  @override
  Widget build(BuildContext context) {
    String currentUser = FirebaseAuth.instance.currentUser.uid;

    return StreamBuilder(
      stream: AppLocalization.of(context).locale.languageCode=="ar"?DataBase().getFavoriteTourAr(Travelers(id: currentUser)):DataBase().getFavoriteTour(Travelers(id: currentUser)),
      builder:(context,AsyncSnapshot<dynamic>snapshot){
        if(snapshot.hasData){
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Tour tour=snapshot.data[index];
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 10,
                    bottom: 5,
                  ),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ToursDetailsScreen(tour:tour ,)));

                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width * 0.25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                left: AppLocalization.of(context)
                                    .locale
                                    .languageCode ==
                                    "ar"
                                    ? Radius.circular(0)
                                    : Radius.circular(15),
                                right: AppLocalization.of(context)
                                    .locale
                                    .languageCode ==
                                    "ar"
                                    ? Radius.circular(15)
                                    : Radius.circular(0),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(tour.tourPhotos[0]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: AppLocalization.of(context)
                                          .locale
                                          .languageCode ==
                                          "ar"
                                          ? EdgeInsets.only(right: 12, top: 12)
                                          : EdgeInsets.only(left: 12, top: 12),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width*0.45,
                                        child: AutoSizeText(
                                          tour.placeName,
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w500),
                                          softWrap: true,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: AppLocalization.of(context)
                                          .locale
                                          .languageCode ==
                                          'ar'
                                          ? const EdgeInsets.only(right: 9,)
                                          : const EdgeInsets.only(left: 9, top: 8),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_sharp,
                                            color: primaryColor,
                                            size: 16,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width*0.45,
                                            child: AutoSizeText(
                                              '${tour.tourCountry}, ${tour.tourCity}',
                                              style: TextStyle(),
                                              maxLines: 1,
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: AppLocalization.of(context)
                                          .locale
                                          .languageCode ==
                                          "ar"
                                          ? const EdgeInsets.only(right: 12,)
                                          : const EdgeInsets.only(left: 12, top: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${tour.tourPrice.toInt()}' + ' ${AppLocalization.of(context).locale.languageCode=="ar"?"\جنيه":"\EGP"}',
                                            style: TextStyle(
                                              color: pink600Color.withOpacity(0.8),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: AppLocalization.of(context)
                                      .locale
                                      .languageCode ==
                                      "ar"
                                      ? const EdgeInsets.only(
                                      top: 12, bottom: 14, left: 12)
                                      : const EdgeInsets.only(
                                      top: 12, bottom: 16, right: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star_rate_rounded,
                                            size: 19,
                                            color: orangeColor,
                                          ),
                                          Text(
                                            '${tour.tourRate}',
                                            style: TextStyle(
                                                color: grey700Color,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

              });
        }else if(snapshot.hasError){
          return Text(snapshot.error.toString());
        }else
          return Center(child: CircularProgressIndicator(),);


      },
    );
  }
}
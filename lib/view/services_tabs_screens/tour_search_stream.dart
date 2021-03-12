import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Controllers/firestore/DataBase.dart';
import 'package:project/constants_colors.dart';
import 'package:project/locale_language/localization_delegate.dart';
import 'package:project/models/tour.dart';
import 'package:project/view/details_screens/tour_details.dart';
import 'package:project/view/services_tabs_screens/tour_service.dart';
import 'package:provider/provider.dart';

class TourSearchStream extends StatefulWidget {
  @override
  _TourSearchStreamState createState() => _TourSearchStreamState();
}

class _TourSearchStreamState extends State<TourSearchStream> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Tour>>.value(
      initialData: [],
      value:AppLocalization.of(context).locale.languageCode=="ar"?DataBase().getAllToursAr :DataBase().getAllTours,
      catchError: (_, err) => throw Exception(err),
      child: ToursService(),
    );
  }

}

class TourSearch extends StatefulWidget {

 final List<Tour> tourList;

  TourSearch({@required this.tourList});

  @override
  _TourSearchState createState() => _TourSearchState();
}

class _TourSearchState extends State<TourSearch> {
  @override
  Widget build(BuildContext context) {
    String currentUser = FirebaseAuth.instance.currentUser.uid;

    return Expanded(
      child: ListView.builder(
          itemCount:
              widget.tourList != null && widget.tourList.length > 0 ? widget.tourList.length : 0,
          itemBuilder: (context, index) {
            final Tour currentTour = widget.tourList[index];
            var isFav = currentTour.favTours.contains(currentUser);

            return Padding(
              padding: const EdgeInsets.only(top: 15),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ToursDetailsScreen(tour: currentTour,),),);
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
                      CachedNetworkImage(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width * 0.25,
                        imageUrl: currentTour.tourPhotos[0],
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        imageBuilder:(context, imageProvider)=> Container(
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
                              image:imageProvider,
                              fit: BoxFit.cover,
                            ),
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
                                        currentTour.placeName,
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: AppLocalization.of(context)
                                      .locale
                                      .languageCode ==
                                      'ar'
                                      ? const EdgeInsets.only(right: 9)
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
                                          "${currentTour.tourCountry}, ${currentTour.tourCity}",
                                          style: TextStyle(),
                                          maxLines:1,
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
                                      ? const EdgeInsets.only(right: 12,top: 4)
                                      : const EdgeInsets.only(left: 12, top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${currentTour.tourPrice.toInt()}' +
                                            '${AppLocalization.of(context).locale.languageCode=="ar"?" \جنيه":" \EGP"} ',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if(isFav){
                                        AppLocalization.of(context).locale.languageCode=="ar"?deleteFavoriteAr(currentTour.tourId) :deleteFavorite(currentTour.tourId);
                                      }else{
                                        AppLocalization.of(context).locale.languageCode=="ar"? deleteFavoriteAr(currentTour.tourId):addFavorite(currentTour.tourId);
                                      }

                                    },
                                    child: Icon(
                                      Icons.favorite,
                                      color:isFav? redAccentColor:Colors.grey,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star_rate_rounded,
                                        size: 19,
                                        color: orangeColor,
                                      ),
                                      Text(
                                        '${currentTour.tourRate}',
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
          }),
    );
  }
  Future addFavorite(tourId) async {
    String currentUser = FirebaseAuth.instance.currentUser.uid;

    await DataBase().addFavoritesTour(
        tourId: tourId,
        travellerId: currentUser
    );
  }

  Future deleteFavorite(tourId) async {
    String currentUser = FirebaseAuth.instance.currentUser.uid;

    await DataBase().removeFavoritesTour(
        tourId: tourId,
        travellerId: currentUser
    );
  }


  Future addFavoriteAr(tourId) async {
    String currentUser = FirebaseAuth.instance.currentUser.uid;

    await DataBase().addFavoritesTourAr(
        tourId: tourId,
        travellerId: currentUser
    );
  }

  Future deleteFavoriteAr(tourId) async {
    String currentUser = FirebaseAuth.instance.currentUser.uid;

    await DataBase().removeFavoritesTourAr(
        tourId: tourId,
        travellerId: currentUser
    );
  }
}

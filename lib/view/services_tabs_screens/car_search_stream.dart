import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Controllers/firestore/DataBase.dart';
import 'package:project/constants_colors.dart';
import 'package:project/locale_language/localization_delegate.dart';
import 'package:project/models/car.dart';
import 'package:project/view/details_screens/car_details.dart';
import 'package:project/view/services_tabs_screens/car_service.dart';
import 'package:provider/provider.dart';

class CarSearchStream extends StatefulWidget {
  @override
  _CarSearchStreamState createState() => _CarSearchStreamState();
}

class _CarSearchStreamState extends State<CarSearchStream> with AutomaticKeepAliveClientMixin{





  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamProvider<List<Cars>>.value(
      initialData: [],
      value:AppLocalization.of(context).locale.languageCode=="ar"? DataBase().getAllCarsAr:DataBase().getAllCars,
      catchError: (_, err) => throw Exception(err),
      child: CarsService(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


}

class CarSearch extends StatelessWidget {

  final List<Cars> carList;

  CarSearch({@required this.carList});


  @override
  Widget build(BuildContext context) {
    String currentUser = FirebaseAuth.instance.currentUser.uid;

    return Expanded(
      child: ListView.builder(
          cacheExtent: 9999,
          itemCount: carList != null && carList.length > 0 ? carList.length : 0,
          itemBuilder: (context, index) {
            Cars currentCar = carList[index];

            var isFav = currentCar.favCars.contains(currentUser);

            return Padding(
              padding: const EdgeInsets.only(top: 15),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CarsDetailsScreen(car: currentCar,)));
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
                        imageUrl: currentCar.carPhotos[0],
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
                              right: AppLocalization.of(context).locale.languageCode == "ar" ? Radius.circular(15) : Radius.circular(0),
                            ),
                            image: DecorationImage(
                              image: imageProvider,
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
                                      currentCar.carName,
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
                                      AutoSizeText(
                                        "${currentCar.carCountry}, ${currentCar.carCity}",
                                        style: TextStyle(),
                                        maxLines: 1,
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: AppLocalization.of(context)
                                      .locale
                                      .languageCode ==
                                      "ar"
                                      ? const EdgeInsets.only(right: 12, top: 4)
                                      : const EdgeInsets.only(left: 12, top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${currentCar.priceOfDay.toInt()}' +
                                            '${AppLocalization.of(context).locale.languageCode=="ar"?" \????????":" \EGP"} ',
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
                                     AppLocalization.of(context).locale.languageCode=="ar"?deleteFavorite(currentCar.id):deleteFavorite(currentCar.id);
                                      }else{
                                        AppLocalization.of(context).locale.languageCode=="ar"?addFavorite(currentCar.id):addFavorite(currentCar.id);
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
                                        '${currentCar.carRate}',
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

  Future addFavorite(carId) async {
    String currentUser = FirebaseAuth.instance.currentUser.uid;
    await DataBase().addFavoritesCar(
        carId: carId,
        travellerId: currentUser
    );

    await DataBase().addFavoritesCarAr(
        carId: carId,
        travellerId: currentUser
    );
  }

  Future deleteFavorite(carId) async {
    String currentUser = FirebaseAuth.instance.currentUser.uid;

    await DataBase().removeFavoritesCar(
        carId: carId,
        travellerId: currentUser
    );
    await DataBase().removeFavoritesCarAr(
        carId: carId,
        travellerId: currentUser
    );
  }

}

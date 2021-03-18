import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/Controllers/firestore/DataBase.dart';
import 'package:project/constants_colors.dart';
import 'package:project/locale_language/localization_delegate.dart';
import 'package:project/models/booking_car.dart';
import 'package:project/models/users.dart';

class CarsNotifications extends StatefulWidget {


  @override
  _CarsNotificationsState createState() => _CarsNotificationsState();
}

class _CarsNotificationsState extends State<CarsNotifications> {

  @override
  Widget build(BuildContext context) {
    String currentUser=FirebaseAuth.instance.currentUser.uid;
    return StreamBuilder(
      stream:AppLocalization.of(context).locale.languageCode=="ar"?DataBase().getBookingCar(Travelers(id: currentUser)) :DataBase().getBookingCar(Travelers(id: currentUser)),
      builder:(context,AsyncSnapshot<List<BookingCar>>snapshot){
        if(snapshot.hasData){
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                BookingCar car=snapshot.data[index];
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 10,
                    bottom: 5,
                  ),
                  child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      children: [
                        Row(
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
                                  image: NetworkImage(car.carPhoto),
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
                                          width: MediaQuery.of(context).size.width*0.60,
                                          child: AutoSizeText(
                                            car.carName,
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
                                            ? const EdgeInsets.only(right: 9,)
                                            : const EdgeInsets.only(left: 9, top: 8),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 5,right: 3,left: 3),
                                              child: Icon(FontAwesomeIcons.calendarAlt,size: 16,color: primaryColor,),
                                            ),
                                            Text(
                                              '${car.startOfLease} --->>> ${car.endOfLease}',
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
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${car.totalPrice}' + ' ${AppLocalization.of(context).locale.languageCode=="ar"?"\جنيه":"\EGP"}',
                                                  style: TextStyle(
                                                    color: pink600Color.withOpacity(0.8),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: AppLocalization.of(context).locale.languageCode=="ar"?Alignment.bottomLeft:Alignment.bottomRight,
                          child: Padding(
                            padding: AppLocalization.of(context).locale.languageCode=="ar"?const EdgeInsets.only(
                                left: 12,bottom: 5 ):const EdgeInsets.only(right: 12,bottom: 5),
                            child: SizedBox(
                              height: 30,
                              width: 80,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(8),
                                  backgroundColor:MaterialStateProperty.all(red900Color),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),

                                child: Text(
                                  AppLocalization.of(context)
                                      .getTranslated('button_cancel_hotels'),
                                  style: TextStyle(color: whiteColor),
                                ),
                                onPressed: () {
                                  _onWillPop(context, car, currentUser);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
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
  Future<bool> _onWillPop(context,car,currentUser) async {
    return (await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalization.of(context)
            .getTranslated("alert_exit1")),
        content: Text(AppLocalization.of(context)
            .getTranslated("alert_cancel2")),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalization.of(context)
                .getTranslated("alert_button2")),
          ),
          TextButton(
            onPressed: () async {
               await DataBase().deletePaymentCar(BookingCar(bookingId: car.bookingId), Travelers(id: currentUser));
               await DataBase().deleteBookingCar(BookingCar(bookingId: car.bookingId), Travelers(id: currentUser));
              Navigator.of(context).pop();
            },
            child: Text(AppLocalization.of(context)
                .getTranslated("alert_button1"),),),
        ],
      ),
    )) ??
        false;
  }
}
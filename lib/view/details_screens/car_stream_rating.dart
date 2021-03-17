import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project/Controllers/firestore/DataBase.dart';
import 'package:project/constants_colors.dart';
import 'package:project/locale_language/localization_delegate.dart';
import 'package:project/models/car.dart';
import 'package:project/models/rating_car.dart';
import 'package:project/models/users.dart';

class CarRatingStream extends StatefulWidget {
  final Cars carId;

  CarRatingStream({this.carId});

  @override
  _CarRatingStreamState createState() => _CarRatingStreamState();
}

class _CarRatingStreamState extends State<CarRatingStream> {
  @override
  Widget build(BuildContext context) {
    String currentUser = FirebaseAuth.instance.currentUser.uid;

    return StreamBuilder(
      stream: AppLocalization.of(context).locale.languageCode == "ar"
          ? DataBase().getAllCarCommentAr(widget.carId)
          : DataBase().getAllCarComment(widget.carId),
      // ignore: missing_return
      builder: (context, AsyncSnapshot<List<CarRating>> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (!snapshot.hasData) {
          return Container();
        } else if (snapshot.data.isEmpty) {
          return Container(
            child: Center(
              child: Text('No Data'),
            ),
          );
        } else
          return Expanded(
            child: ListView.builder(
              // key: Key("${snapshot.data.length}"),
              itemCount: snapshot.data != null && snapshot.data.length > 0
                  ? snapshot.data.length
                  : 0,
              itemBuilder: (context, index) {
                final CarRating currentRate = snapshot.data[index];

                return currentRate.rateId == currentUser
                    ? Builder(
                      builder:(cx)=> Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          secondaryActions: [
                            IconSlideAction(
                              iconWidget: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    AppLocalization.of(context)
                                        .getTranslated("delete_rate"),
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                              color: Colors.transparent,
                              onTap: () async{
                                if (AppLocalization.of(context).locale.languageCode == "ar") {
                                 await DataBase().deleteRatingCarAr(currentRate,
                                      Travelers(id: currentUser), widget.carId);
                                 await DataBase().deleteRatingCar(currentRate,
                                      Travelers(id: currentUser), widget.carId);
                                }else{
                                  await DataBase().deleteRatingCar(currentRate,
                                      Travelers(id: currentUser), widget.carId);
                                  await  DataBase().deleteRatingCarAr(currentRate,
                                      Travelers(id: currentUser), widget.carId);
                                }

                                setState(() {
                                  snapshot.data.removeAt(index);
                                });
                                ScaffoldMessenger.of(cx).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "${AppLocalization.of(context).getTranslated("snack_delete")}"),
                                  ),
                                );
                              },
                            ),
                          ],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundColor: primaryColor,
                                          child: CircleAvatar(
                                            backgroundColor: whiteColor,
                                            radius: 22,
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  currentRate.photoUrl),
                                              radius: 20,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    AppLocalization.of(context)
                                                                .locale
                                                                .languageCode ==
                                                            "ar"
                                                        ? const EdgeInsets.only(
                                                            right: 10)
                                                        : const EdgeInsets.only(
                                                            left: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.40,
                                                      child: AutoSizeText(
                                                        currentRate.username,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: pink600Color),
                                                        maxLines: 1,
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${AppLocalization.of(context).locale.languageCode == "ar" ? currentRate.timeStamp : currentRate.timeStamp}",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: grey600Color),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    AppLocalization.of(context)
                                                                .locale
                                                                .languageCode ==
                                                            "ar"
                                                        ? const EdgeInsets.only(
                                                            top: 2, right: 8)
                                                        : const EdgeInsets.only(
                                                            top: 2, left: 8),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      (Icons.star_rate_rounded),
                                                      color: orangeColor,
                                                      size: 20,
                                                    ),
                                                    SizedBox(width: 2),
                                                    Text(
                                                      currentRate.rate.toString(),
                                                      style: TextStyle(
                                                          color: grey700Color,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(currentRate.comment),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: primaryColor,
                                      child: CircleAvatar(
                                        backgroundColor: whiteColor,
                                        radius: 22,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              currentRate.photoUrl),
                                          radius: 20,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: AppLocalization.of(context)
                                                        .locale
                                                        .languageCode ==
                                                    "ar"
                                                ? const EdgeInsets.only(
                                                    right: 10)
                                                : const EdgeInsets.only(
                                                    left: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.40,
                                                  child: AutoSizeText(
                                                    currentRate.username,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: pink600Color),
                                                    maxLines: 1,
                                                    softWrap: true,
                                                  ),
                                                ),
                                                Text(
                                                  "${AppLocalization.of(context).locale.languageCode == "ar" ? currentRate.timeStamp : currentRate.timeStamp}",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: grey600Color),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: AppLocalization.of(context)
                                                        .locale
                                                        .languageCode ==
                                                    "ar"
                                                ? const EdgeInsets.only(
                                                    top: 2, right: 8)
                                                : const EdgeInsets.only(
                                                    top: 2, left: 8),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  (Icons.star_rate_rounded),
                                                  color: orangeColor,
                                                  size: 20,
                                                ),
                                                SizedBox(width: 2),
                                                Text(
                                                  currentRate.rate.toString(),
                                                  style: TextStyle(
                                                      color: grey700Color,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(currentRate.comment),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
              },
            ),
          );
      },
    );
  }
}

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:intl/intl.dart';
import 'package:project/Controllers/firestore/DataBase.dart';
import 'package:project/constants_colors.dart';
import 'package:project/locale_language/localization_delegate.dart';
import 'package:project/models/rating_tour.dart';
import 'package:project/models/booking_tour.dart';
import 'package:project/models/tour.dart';
import 'package:project/models/users.dart';
import 'package:project/view/booking/booking_tour.dart';
import 'package:project/view/details_screens/tour_stream_rating.dart';

class ToursDetailsScreen extends StatefulWidget {
  final Tour tour;

  ToursDetailsScreen({this.tour});

  @override
  _ToursDetailsScreenState createState() => _ToursDetailsScreenState();
}

class _ToursDetailsScreenState extends State<ToursDetailsScreen>
    with SingleTickerProviderStateMixin {
  var _formKey = GlobalKey<FormState>();
  TextEditingController _addCommentController = TextEditingController();
  TextEditingController _updateCommentController = TextEditingController();
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

  TabController _tabController;
  double currentSliderValue = 1;
  double priceOfTour;

  double numOfRating = 0;
  double updateNumOfRating = 0;
  int lines = 0;
  int currentPos = 0;
  int duration;
  int totalPrice;
  Iterable<String> sliderImages = [];
  Timer timer;
  DateTime startOfTour;

  DateFormat format = DateFormat("HH:mm ");
  DateFormat format2 = DateFormat.yMd();
  DateTime time = DateTime.now();

  String timeReview;
  String startTour;
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  CollectionReference travelerCollection = FirebaseFirestore.instance.collection('Travelers');
  final CollectionReference tourCollection = FirebaseFirestore.instance.collection("Tours");

  String username, photoUrl;
  String currentUser = FirebaseAuth.instance.currentUser.uid;
  var isFav;
  String rateId;
  // ignore: missing_return
  Stream<DocumentSnapshot> getData()  {
    try {
      travelerCollection.doc(currentUser).get().then((value) {
        username = value.data()["fullName"];
        photoUrl = value.data()["image"];
      });
    } catch (e) {
      print("${e.toString()}");
    }
  }

  // ignore: missing_return
  Stream<List<TourRating>> getRate() {
    tourCollection
        .doc(widget.tour.tourId)
        .collection("TourRating").where("rateId",isEqualTo: currentUser)
        .snapshots()
        .listen((data) {
      if(data.docs.length>0){
        data.docs.forEach((element) {
          if (element != null)
          {
            if(mounted==false){
              return ;
            }

            setState(() {
              rateId = element.data()["rateId"];
              _updateCommentController.text=element.data()["comment"];
              updateNumOfRating=element.data()["rate"];
            });
          }
        });
      }else{
        if(mounted==false){
          return ;
        }
        setState(() {
          rateId=null;
        });
      }

    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    startOfTour = DateTime.now();
    sliderImages = widget.tour.tourPhotos.getRange(0, 3);
    priceOfTour = widget.tour.tourPrice;
    duration = widget.tour.duration;
    timeReview = format.format(time);
    startTour=format2.format(startOfTour);
    timer = Timer.periodic(Duration(microseconds: 500), (Timer t) {
      if(mounted==false){
        return ;
      }
      setState(() {
        totalPrice = (priceOfTour * currentSliderValue).toInt();
      });
    });
    getData();
    isFav = widget.tour.favTours.contains(currentUser);
    getRate();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _addCommentController.dispose();
    _updateCommentController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          _background(context),
          Scaffold(
            key: _scaffoldKey,
            backgroundColor: transparent,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(
                AppLocalization.of(context).getTranslated("details_title"),
                style: TextStyle(color: whiteColor),
              ),
              centerTitle: true,
              backgroundColor: transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: whiteColor),
                onPressed: () {
                  Navigator.pop(context,isFav);
                },
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 115,
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: grey50Color,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                    ),
                    child: _bodyContent(context),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 168,
            right: AppLocalization.of(context).locale.languageCode == "ar"
                ? null
                : 25,
            left: AppLocalization.of(context).locale.languageCode == "ar"
                ? 25
                : null,
            child: MaterialButton(
              height: 25,
              minWidth: 25,
              color: whiteColor,
              onPressed: () {
                if (isFav) {
                  setState(() {
                    isFav=!isFav;
                    AppLocalization.of(context).locale.languageCode=="ar"? deleteFavoriteAr():deleteFavorite();
                  });
                } else {
                  setState(() {
                    isFav=!isFav;
                    AppLocalization.of(context).locale.languageCode=="ar"?addFavoriteAr() :addFavorite();
                  });
                }
              },
              child: isFav
                  ? Icon(
                      Icons.favorite,
                      color: redAccentColor,
                      size: 30,
                    )
                  : Icon(
                      Icons.favorite_border_outlined,
                      color: redAccentColor,
                      size: 30,
                    ),
              padding: EdgeInsets.all(14),
              shape: CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _background(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider.builder(
            options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.4,
                autoPlay: true,
               // enlargeCenterPage: true,
                viewportFraction: 1,
                aspectRatio: 2.0,
                initialPage: 0,
                scrollDirection: Axis.horizontal,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentPos = index;
                  });
                }),
            itemCount: sliderImages.length,
            itemBuilder: (BuildContext context, int itemIndex,int realId) {
              return MyImageView(widget.tour.tourPhotos[itemIndex]);
            }),
        Padding(
          padding: const EdgeInsets.only(top: 170),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildPageIndicator(sliderImages),
          ),
        ),
      ],
    );
  }

  Widget _bodyContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.tour.placeName,
              style: TextStyle(
                  color: pink600Color,
                  fontSize: 30,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: AppLocalization.of(context).locale.languageCode == "ar"
                ? const EdgeInsets.only(left: 20, right: 16, top: 5, bottom: 5)
                : const EdgeInsets.only(left: 16, right: 20, top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      (Icons.star_rate_rounded),
                      color: orangeColor,
                    ),
                    SizedBox(width: 2),
                    Text(
                      widget.tour.tourRate.toString(),
                      style: TextStyle(
                        color: grey700Color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_sharp,
                      color: deepPurpleColor,
                      size: 18,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "${widget.tour.tourCountry}, ${widget.tour.tourCity}",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: grey700Color),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 0.12,
            child: TabBar(
              controller: _tabController,
              labelColor: primaryColor,
              indicatorColor: primaryColor,
              unselectedLabelColor: grey800Color,
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
              labelStyle: TextStyle(fontWeight: FontWeight.w600),
              indicatorPadding:
                  EdgeInsets.symmetric(vertical: 8, horizontal: 40),
              tabs: [
                Text(AppLocalization.of(context)
                    .getTranslated("text_about_details")),
                Text(
                    AppLocalization.of(context).getTranslated("text_overview")),
                Text(AppLocalization.of(context).getTranslated("text_photos")),
                Text(AppLocalization.of(context).getTranslated("text_reviews")),
              ],
            ),
          ),
          Flexible(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding:
                            AppLocalization.of(context).locale.languageCode ==
                                "ar"
                                ? const EdgeInsets.only(left: 23, right: 30)
                                : const EdgeInsets.only(left: 30, right: 23),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalization.of(context)
                                      .getTranslated("text_start_of_tour"),
                                  style: TextStyle(
                                      color: blackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                InkWell(
                                  child: Row(
                                    children: [
                                      Text(
                                        "${startOfTour.day} - ${startOfTour.month} - ${startOfTour.year}",
                                        style: TextStyle(
                                            color: grey700Color,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: grey700Color,
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      pickDateStart();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalization.of(context)
                                          .getTranslated("text_duration"),
                                      style: TextStyle(
                                          color: blackColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "$duration" +
                                          " " +
                                          "${widget.tour.tourCity=="الجيزة"?AppLocalization.of(context)
                                              .getTranslated("text_hours"):widget.tour.tourCity=="القاهرة"?AppLocalization.of(context)
                                              .getTranslated("text_hours"):widget.tour.tourCity=="Giza"?AppLocalization.of(context)
                                              .getTranslated("text_hours"):widget.tour.tourCity=="Cairo"?AppLocalization.of(context)
                                              .getTranslated("text_hours"):AppLocalization.of(context)
                                              .getTranslated("text_days")}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: grey700Color),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalization.of(context)
                                          .getTranslated("text_price_of_day"),
                                      style: TextStyle(
                                          color: blackColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${priceOfTour.toInt()}' +  '${AppLocalization.of(context).locale.languageCode=="ar"?"\جنيه":"\EGP"} ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: grey700Color),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Slider(
                                  value: currentSliderValue,
                                  max: 5,
                                  divisions: 4,
                                  min: 1,
                                  activeColor: deepPurpleColor,
                                  inactiveColor: deepPurpleColor.withOpacity(0.3),
                                  label: currentSliderValue.toInt().toString(),
                                  onChanged: (
                                      double value,
                                      ) {
                                    setState(() {
                                      currentSliderValue = value;
                                    });
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      currentSliderValue.toInt().toString() + " ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: grey800Color),
                                    ),
                                    Text(
                                      AppLocalization.of(context)
                                          .getTranslated("text_person"),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: grey800Color),
                                    ),
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
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: Text(
                      widget.tour.tourOverview,
                      style: TextStyle(color: grey700Color, fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
                  child: GridView.count(
                    crossAxisCount: 3,
                    children:
                        List.generate(widget.tour.tourPhotos.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: FullScreenWidget(
                          child: Hero(
                            tag: "image$index",
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                width: 60,
                                height: 60,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: widget.tour.tourPhotos[index],
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 25, right: 17),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.50,
                              child: Text(
                                AppLocalization.of(context)
                                    .getTranslated("text_ques_tour"),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: primaryColor),
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              _showReview();
                            },
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            child: Container(
                              width:rateId !=null? MediaQuery.of(context).size.width * 0.3:MediaQuery.of(context).size.width * 0.25,
                              child: rateId !=null
                                  ? Text(
                                AppLocalization.of(context)
                                    .getTranslated("text_update_review"),
                                style: TextStyle(color: pink600Color),
                              )
                                  : Text(
                                AppLocalization.of(context)
                                    .getTranslated("text_add_review"),
                                style: TextStyle(color: pink600Color),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TourRatingStream(
                        tourId: Tour(tourId: widget.tour.tourId),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      '$totalPrice' +
                          AppLocalization.of(context).getTranslated("text_le"),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: pink600Color),
                    ),
                    Text(
                      AppLocalization.of(context)
                          .getTranslated("text_total_price"),
                      style: TextStyle(
                        color: grey800Color,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                  width: 170,
                  child: RaisedButton(
                    color: primaryColor,
                    colorBrightness: Brightness.dark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Text(
                      AppLocalization.of(context).getTranslated("button_book"),
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 18,
                        letterSpacing: 1.1,
                      ),
                    ),
                    onPressed: () async {
                      AppLocalization.of(context).locale.languageCode=="ar"? await addDataAr():await addDataEn();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingTourScreen(
                            tour: widget.tour,
                            startOfBooking: startOfTour,
                            duration: duration,
                            totalPrice: totalPrice,
                            persons: currentSliderValue.toInt(),

                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Future addDataEn() async {
    await DataBase().addBookingTour(
        BookingTour(
          bookingId: widget.tour.tourId,
          duration: duration,
          totalPrice: totalPrice,
          numOfPersons: currentSliderValue.toInt(),
          startOfTour: startTour,
          placeName: widget.tour.placeName,
          tourPhoto: widget.tour.tourPhotos[0],
          paid: false,
        ),
        Travelers(
          id: currentUser,
        ));
  }

  Future addDataAr() async {
    await DataBase().addBookingTourAr(
        BookingTour(
          bookingId: widget.tour.tourId,
          duration: duration,
          totalPrice: totalPrice,
          numOfPersons: currentSliderValue.toInt(),
          startOfTour: startTour,
          placeName: widget.tour.placeName,
            tourPhoto: widget.tour.tourPhotos[0],
          paid: false,
        ),
        Travelers(
          id: currentUser,
        ));
  }


  Future addReview() async {
    await DataBase().addRatingTour(
        TourRating(
          rateId: currentUser,
          comment: _addCommentController.text,
          rate: numOfRating,
          timeStamp: timeReview,
          username: username,
          photoUrl: photoUrl,

        ),
        Travelers(
          id: currentUser,
        ),
        Tour(
          tourId: widget.tour.tourId,
        ));
  }

  Future updateReview() async {
    await DataBase().updateRatingTour(
        TourRating(
          rateId: currentUser,
          comment: _updateCommentController.text,
          rate: updateNumOfRating,
          timeStamp: timeReview,
          username: username,
          photoUrl: photoUrl,

        ),
        Travelers(
          id: currentUser,
        ),
        Tour(
          tourId: widget.tour.tourId,
        ));
  }


  List<Widget> _buildPageIndicator(images) {
    List<Widget> list = [];
    for (int i = 0; i < images.length; i++) {
      list.add(i == currentPos ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? whiteColor : grey500Color,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Future<DateTime> pickDateStart() async {
    final DateTime dateStart = await showDatePicker(
      context: context,
      initialDate: startOfTour,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (dateStart != null) {
      setState(() {
        startOfTour = dateStart;
      });
    }
    return dateStart;
  }

  void _showReview() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 10,
                right: 10,
                top: 10,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${AppLocalization.of(context).getTranslated("text_share_ex")} ${widget.tour.placeName}",
                              style: TextStyle(
                                  color: blackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            Text(
                              AppLocalization.of(context).getTranslated("text_help_ex"),
                              style: TextStyle(
                                  color: grey400Color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: grey700Color,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "${AppLocalization.of(context).getTranslated("text_rate")}  ${widget.tour.placeName}:",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RatingBar.builder(
                                initialRating: rateId !=null?updateNumOfRating:numOfRating,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 3.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  if(rateId !=null){
                                    setState(() {
                                      this.updateNumOfRating = rating;
                                    });
                                  }else{
                                    setState(() {
                                      this.numOfRating = rating;
                                    });
                                  }
                                },
                              ),
                              Text(
                                "${rateId !=null?updateNumOfRating:numOfRating} /5.0",
                                style:
                                    TextStyle(color: grey700Color, fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: grey700Color,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        minLines: 1,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        maxLength: 300,
                        controller: rateId !=null?_updateCommentController:_addCommentController,
                        style: TextStyle(
                          color: blackColor,
                        ),
                        decoration: InputDecoration(
                          labelText: AppLocalization.of(context).getTranslated("text_your_review"),
                          labelStyle: _labelStyle,
                          prefixIcon: Icon(
                            Icons.rate_review,
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
                            return "Enter Your Review";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                AppLocalization.of(context)
                                    .getTranslated("button_cancel_profile"),
                                style: TextStyle(color: redColor),
                              )),
                          FlatButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  if(rateId !=null){
                                    await updateReview().then((_) {
                                      Navigator.pop(context);
                                      _scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Your Review Updated Success")));
                                    }).catchError((error) {
                                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                                          content: Text(
                                              "Your Review Updated Failed $error")));
                                    });
                                    setState((){});

                                  }else{
                                    await addReview().then((_) {
                                      Navigator.pop(context);
                                      _addCommentController.clear();
                                      _scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Your Review Added Success")));
                                    }).catchError((error) {
                                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                                          content: Text(
                                              "Your Review Added Failed $error")));
                                    });
                                    setState((){});

                                  }

                                }
                              },
                              child:rateId !=null
                                  ? Text(
                                "${AppLocalization.of(context).getTranslated("text_update_review")}",
                                style: TextStyle(color: primaryColor),
                              )
                                  : Text(
                                "${AppLocalization.of(context).getTranslated("text_add_review")}",
                                style: TextStyle(color: primaryColor),
                              ),
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
  Future addFavorite() async {

    await DataBase().addFavoritesTour(
        tourId:  widget.tour.tourId,
        travellerId: currentUser
    );
  }

  Future deleteFavorite() async {

    await DataBase().removeFavoritesTour(
        tourId:  widget.tour.tourId,
        travellerId: currentUser
    );
  }

  Future addFavoriteAr() async {

    await DataBase().addFavoritesTourAr(
        tourId:  widget.tour.tourId,
        travellerId: currentUser
    );
  }

  Future deleteFavoriteAr() async {

    await DataBase().removeFavoritesTourAr(
        tourId:  widget.tour.tourId,
        travellerId: currentUser
    );
  }

}

class MyImageView extends StatelessWidget {
  final String imgPath;

  MyImageView(this.imgPath);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CachedNetworkImage(
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.4,
      imageUrl: imgPath,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:project/Controllers/firestore/DataBase.dart';
import 'package:project/Controllers/payment/payment_service.dart';
import 'package:project/constants_colors.dart';
import 'package:project/locale_language/localization_delegate.dart';
import 'package:project/models/booking_tour.dart';
import 'package:project/models/payment_tour.dart';
import 'package:project/models/tour.dart';
import 'package:project/models/users.dart';
import 'package:project/view/drawer_screens/animated_drawer_screen.dart';
import 'package:project/view/drawer_screens/notification/notifications_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class BookingTourScreen extends StatefulWidget {
  final Tour tour;
  final DateTime startOfBooking;
  final int duration, totalPrice;
  final int persons;

  BookingTourScreen(
      {this.tour,
      this.startOfBooking,
      this.duration,
      this.totalPrice,
      this.persons});

  @override
  _BookingTourScreenState createState() => _BookingTourScreenState(
      tour: tour,
      startOfBooking: startOfBooking,
      duration: duration,
      totalPrice: totalPrice,
      persons: persons);
}

class _BookingTourScreenState extends State<BookingTourScreen> {
  Tour tour;
  DateTime startOfBooking;
  int duration, totalPrice;
  int persons;

  _BookingTourScreenState(
      {this.tour,
      this.startOfBooking,
      this.duration,
      this.totalPrice,
      this.persons});

  DateFormat format = DateFormat("yyyy-MM-dd ");
  String bookingDate;

  int currentPos = 0;
  Iterable<String> sliderImages = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    bookingDate = format.format(startOfBooking).toString();
    sliderImages = tour.tourPhotos.getRange(0, 3);
    StripeService.init();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    requestIOSPermission();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    tz.initializeTimeZones();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      child: Stack(
        children: [
          _background(context),
          Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                "Booking",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: whiteColor),
                onPressed: () {
                  Navigator.pop(context);
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
                      color: Colors.white,
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
            itemBuilder: (BuildContext context, int itemIndex) {
              return MyImageView(tour.tourPhotos[itemIndex]);
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
      padding: const EdgeInsets.only(top: 36),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppLocalization.of(context).locale.languageCode == "ar"
                  ? const EdgeInsets.only(
                      right: 25,
                    )
                  : EdgeInsets.only(left: 25),
              child: Column(
                children: [
                  Text(
                    tour.placeName,
                    style: TextStyle(
                        color: pink600Color,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppLocalization.of(context).locale.languageCode == "ar"
                  ? const EdgeInsets.only(
                      left: 18, right: 20, top: 5, bottom: 5)
                  : const EdgeInsets.only(
                      left: 20, right: 18, top: 5, bottom: 5),
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
                        "${tour.tourRate}",
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
                        "${tour.tourCountry}, ${tour.tourCity}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: grey700Color),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalization.of(context)
                            .getTranslated("text_category"),
                        style: TextStyle(
                            color: blackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${tour.categoryName}",
                        style: TextStyle(
                            color: grey700Color, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalization.of(context)
                            .getTranslated("text_persons"),
                        style: TextStyle(
                            color: blackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        persons.toString(),
                        style: TextStyle(
                            color: grey700Color, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
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
                            AppLocalization.of(context)
                                .getTranslated("text_days"),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: grey700Color),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalization.of(context)
                            .getTranslated("text_booking_date"),
                        style: TextStyle(
                            color: blackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            "$bookingDate",
                            style: TextStyle(
                                color: grey700Color,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppLocalization.of(context)
                                .getTranslated("text_total_booking"),
                            style: TextStyle(
                                fontSize: 20,
                                color: blackColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "$totalPrice",
                        style: TextStyle(
                            fontSize: 18,
                            color: pink600Color,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        AppLocalization.of(context).getTranslated("text_le"),
                        style: TextStyle(
                            fontSize: AppLocalization.of(context)
                                        .locale
                                        .languageCode ==
                                    "ar"
                                ? 20
                                : 18,
                            color: pink600Color,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: double.infinity,
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: RaisedButton(
                      colorBrightness: Brightness.dark,
                      color: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: Text(
                        AppLocalization.of(context)
                            .getTranslated("text_checkout"),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 1.1,
                        ),
                      ),
                      onPressed: () async {
                        await _checkOut(context);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  Future _checkOut(BuildContext context) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: AppLocalization.of(context).locale.languageCode=="ar"?'من فضلك انتظر....':'Please wait...');
    await dialog.show();
    var response = await StripeService.payWithNewCard(
        amount: '$totalPrice', currency: 'EGP');
    await dialog.hide();

    if (response.success == true) {
      AppLocalization.of(context).locale.languageCode=="ar"?await addPaymentAr() :await addPayment();
      await _showDialog(response);
      AppLocalization.of(context).locale.languageCode=="ar"? await updatePayBookingAr(): await updatePayBooking();
      await scheduleNotification(tour.placeName,"${ AppLocalization.of(context).locale.languageCode=="ar"?"$bookingDate تم الحجز في ":"Your Booking in  $bookingDate"}");

    } else {
      await _showDialog(response);
      return null;
    }
  }

  Future addPayment() async {
    String currentUser = FirebaseAuth.instance.currentUser.uid;
    await DataBase().addPaymentTour(
        PaymentTour(
          paymentId: tour.tourId,
          paymentDate: DateTime.now(),
          paymentPrice: totalPrice,
        ),
        Travelers(
          id: currentUser,
        ));
  }

  Future addPaymentAr() async {
    String currentUser = FirebaseAuth.instance.currentUser.uid;
    await DataBase().addPaymentTourAr(
        PaymentTour(
          paymentId: tour.tourId,
          paymentDate: DateTime.now(),
          paymentPrice: totalPrice,
        ),
        Travelers(
          id: currentUser,
        ));
  }

  Future updatePayBooking() async{
    String currentUser=FirebaseAuth.instance.currentUser.uid;
    await DataBase().updateBookingTour(BookingTour(
        bookingId: widget.tour.tourId
    ), Travelers(id: currentUser));
  }

  Future updatePayBookingAr() async{
    String currentUser=FirebaseAuth.instance.currentUser.uid;
    await DataBase().updateBookingTourAr(BookingTour(
        bookingId: widget.tour.tourId
    ), Travelers(id: currentUser));
  }

  Future _showDialog(response) async {
    return (await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: response.success == true
                ? Lottie.asset("assets/images/success.json")
                : Lottie.asset("assets/images/failed.json"),
            content: response.success == true
                ? Text(
              AppLocalization.of(context).locale.languageCode=="ar"?"تهانينا نجحت العمليه": response.message,
                    style: TextStyle(
                        color: blackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )
                : Text(
              AppLocalization.of(context).locale.languageCode=="ar"?"للاسف فشلت العمليه": response.message,
                    style: TextStyle(
                        color: blackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            actions: <Widget>[
              FlatButton(
                onPressed: () => response.success == true
                    ? Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AnimatedDrawer()))
                    : Navigator.pop(context),
                child: AppLocalization.of(context).locale.languageCode=="ar"?Text('حسنا'):Text('Ok'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      {
        print('notification payload: ' + payload);
      }

      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NotificationScreen(payload: payload, index: 1)),
      );
    }
  }

  Future<void> scheduleNotification(String title, String content) async {
    var scheduledNotificationDateTime =
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      icon: "@mipmap/launcher_icon",
      playSound: true,
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      content,
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      payload: " $title \n $content ",
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  requestIOSPermission() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(
                    payload: payload,
                    index: 1,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }


}

class MyImageView extends StatelessWidget {
  final String imgPath;

  MyImageView(this.imgPath);

  @override
  Widget build(BuildContext context) {
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

import 'package:cloud_firestore/cloud_firestore.dart';

class BookingTour{

  String bookingId,placeName;
  int totalPrice,numOfPersons,duration;
  String startOfTour;
  String tourPhoto;
  bool paid;


  BookingTour({
    this.bookingId,
    this.duration,
    this.totalPrice,
    this.numOfPersons,
    this.startOfTour,
    this.placeName,
    this.tourPhoto,
    this.paid,
  });

  List<BookingTour> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return BookingTour(
        bookingId: doc.get('booking_Id') ?? '',
        duration: doc.get('duration') ?? '',
        totalPrice: doc.get('totalPrice') != null ? doc.get(
            'totalPrice') is double ? doc.get('totalPrice') : doc.get(
            'totalPrice') is String ? double.parse(
            doc.get('totalPrice')):doc.get('totalPrice').toInt() : '',
        numOfPersons: doc.get('numOfPersons') ?? '',
        startOfTour: doc.get('startOfTour') ?? '',
        placeName: doc.get('PlaceName') ?? '',
        tourPhoto: doc.get('TourPhotos') ?? "",
        paid: doc.get("paid")??false,

      );
    }).toList();
  }



  Map<String, dynamic> toJson() {
    return {
      'booking_Id': bookingId,
      'duration': duration,
      'totalPrice': totalPrice,
      'numOfPersons': numOfPersons,
      'startOfTour':startOfTour,
      'PlaceName':placeName,
      'TourPhotos': tourPhoto,
      'paid':paid,
    };
  }
}
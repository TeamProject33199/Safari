import 'package:cloud_firestore/cloud_firestore.dart';

class BookingCar{

  String bookingId,carType,carName;
  int totalPrice,duration;
  String  startOfLease, endOfLease;
  String carPhoto;
  bool paid;

  BookingCar({
    this.bookingId,
    this.duration,
    this.carType,
    this.totalPrice,
    this.startOfLease,
    this.endOfLease,
    this.carName,
    this.carPhoto,
    this.paid
  });

  List<BookingCar> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return BookingCar(
        bookingId: doc.get('booking_Id') ?? '',
        duration: doc.get('duration') ?? '',
        totalPrice: doc.get('totalPrice') != null ? doc.get(
            'totalPrice') is double ? doc.get('totalPrice') : doc.get(
            'totalPrice') is String ? double.parse(
            doc.get('totalPrice')):doc.get('totalPrice').toInt() : '',
        carType: doc.get('carType') ?? '',
        startOfLease: doc.get('startOfLease') ?? '',
        endOfLease: doc.get('endOfLease') ?? '',
        carName: doc.get('CarName') ?? '',
        carPhoto: doc.get('CarPhotos') ?? "",
        paid: doc.get('paid') ?? false,
      );
    }).toList();
  }



  Map<String, dynamic> toJson() {
    return {
      'booking_Id': bookingId,
      'duration': duration,
      'totalPrice': totalPrice,
      'carType': carType,
      'startOfLease': startOfLease,
      'endOfLease': endOfLease,
      'CarName': carName,
      'CarPhotos': carPhoto,
      'paid':paid,
    };
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/payment_car.dart';
import 'package:project/models/payment_hotel.dart';
import 'package:project/models/payment_tour.dart';
import 'package:project/models/rating_car.dart';
import 'package:project/models/rating_tour.dart';
import 'package:project/models/booking_car.dart';
import 'package:project/models/booking_hotel.dart';
import 'package:project/models/booking_tour.dart';
import 'package:project/models/car.dart';
import 'package:project/models/hotel.dart';
import 'package:project/models/rating_hotel.dart';
import 'package:project/models/tour.dart';
import 'package:project/models/users.dart';

class DataBase {
  final CollectionReference hotelCollection =
  FirebaseFirestore.instance.collection("Hotels");
  final CollectionReference hotelArCollection =
  FirebaseFirestore.instance.collection("HotelAr");
  final CollectionReference carCollection =
  FirebaseFirestore.instance.collection("Cars");
  final CollectionReference carArCollection =
  FirebaseFirestore.instance.collection("CarsAr");
  final CollectionReference tourCollection =
  FirebaseFirestore.instance.collection("Tours");
  final CollectionReference tourArCollection =
  FirebaseFirestore.instance.collection("ToursAr");
  final CollectionReference travelerCollection =
  FirebaseFirestore.instance.collection("Travelers");


  Future<void> addTraveler(Travelers travelers) async {
    return await travelerCollection.doc(travelers.id).set(travelers.toJson());
  }

  Stream<DocumentSnapshot> getTraveler(Travelers travelers) {
    return travelerCollection.doc(travelers.id).snapshots();
  }

  Future<void> addRatingHotel(HotelRating rate, Travelers travelers, Hotel hotel) async {
    return await hotelCollection
        .doc(hotel.hotelId)
        .collection("HotelRating")
        .doc(travelers.id)
        .set(rate.toJson());
  }
  Future<void> addRatingHotelAr(HotelRating rate, Travelers travelers, Hotel hotel) async {
    return await hotelArCollection
        .doc(hotel.hotelId)
        .collection("HotelRatingAr")
        .doc(travelers.id)
        .set(rate.toJson());
  }

  Future<void> updateRatingHotel(HotelRating rate, Travelers travelers, Hotel hotel) async {
    return await hotelCollection
        .doc(hotel.hotelId)
        .collection("HotelRating")
        .doc(travelers.id)
        .update(rate.toJson());
  }

  Future<void> updateRatingHotelAr(HotelRating rate, Travelers travelers, Hotel hotel) async {
    return await hotelArCollection
        .doc(hotel.hotelId)
        .collection("HotelRatingAr")
        .doc(travelers.id)
        .update(rate.toJson());
  }

  Future<void> deleteRatingHotel(HotelRating rate, Travelers travelers, Hotel hotel) async {
    return await hotelCollection
        .doc(hotel.hotelId)
        .collection("HotelRating")
        .doc(travelers.id)
        .delete();
  }

  Future<void> deleteRatingHotelAr(HotelRating rate, Travelers travelers, Hotel hotel) async {
    return await hotelArCollection
        .doc(hotel.hotelId)
        .collection("HotelRatingAr")
        .doc(travelers.id)
        .delete();
  }

  Future<void> addRatingTour(TourRating rate, Travelers travelers, Tour tour) async {
    return await tourCollection
        .doc(tour.tourId)
        .collection("TourRating")
        .doc(travelers.id)
        .set(rate.toJson());
  }

  Future<void> addRatingTourAr(TourRating rate, Travelers travelers, Tour tour) async {
    return await tourArCollection
        .doc(tour.tourId)
        .collection("TourRatingAr")
        .doc(travelers.id)
        .set(rate.toJson());
  }

  Future<void> updateRatingTour(TourRating rate, Travelers travelers, Tour tour) async {
    return await tourCollection
        .doc(tour.tourId)
        .collection("TourRating")
        .doc(travelers.id)
        .update(rate.toJson());
  }

  Future<void> updateRatingTourAr(TourRating rate, Travelers travelers, Tour tour) async {
    return await tourArCollection
        .doc(tour.tourId)
        .collection("TourRatingAr")
        .doc(travelers.id)
        .update(rate.toJson());
  }

  Future<void> deleteRatingTour(TourRating rate, Travelers travelers, Tour tour) async {
    return await tourCollection
        .doc(tour.tourId)
        .collection("TourRating")
        .doc(travelers.id)
        .delete();
  }

  Future<void> deleteRatingTourAr(TourRating rate, Travelers travelers, Tour tour) async {
    return await tourArCollection
        .doc(tour.tourId)
        .collection("TourRatingAr")
        .doc(travelers.id)
        .delete();
  }

  Future<void> addRatingCar(CarRating rate, Travelers travelers, Cars cars) async {
    return await carCollection
        .doc(cars.id)
        .collection("CarRating")
        .doc(travelers.id)
        .set(rate.toJson());
  }

  Future<void> updateRatingCar(CarRating rate, Travelers travelers, Cars cars) async {
    return await carCollection
        .doc(cars.id)
        .collection("CarRating")
        .doc(travelers.id)
        .update(rate.toJson());
  }
  Future<void> updateRatingCarAr(CarRating rate, Travelers travelers, Cars cars) async {
    return await carArCollection
        .doc(cars.id)
        .collection("CarRatingAr")
        .doc(travelers.id)
        .update(rate.toJson());
  }

  Future<void> deleteRatingCar(CarRating rate, Travelers travelers, Cars cars) async {
    return await carCollection
        .doc(cars.id)
        .collection("CarRating")
        .doc(travelers.id)
        .delete();
  }
  Future<void> deleteRatingCarAr(CarRating rate, Travelers travelers, Cars cars) async {
    return await carArCollection
        .doc(cars.id)
        .collection("CarRatingAr")
        .doc(travelers.id)
        .delete();
  }

  Stream<List<HotelRating>> getAllHotelComment(Hotel hotel) {
    return hotelCollection
        .doc(hotel.hotelId)
        .collection("HotelRating")
        .orderBy("timeStamp",descending: true)
        .snapshots()
        .map(HotelRating().fromQuery);
  }

  Stream<List<HotelRating>> getAllHotelCommentAr(Hotel hotel) {
    return hotelArCollection
        .doc(hotel.hotelId)
        .collection("HotelRatingAr")
        .orderBy("timeStamp",descending: true)
        .snapshots()
        .map(HotelRating().fromQuery);
  }

  Stream<List<TourRating>> getAllTourComment(Tour tour) {
    return tourCollection
        .doc(tour.tourId)
        .collection("TourRating")
        .orderBy("timeStamp",descending: true)
        .snapshots()
        .map(TourRating().fromQuery);
  }

  Stream<List<TourRating>> getAllTourCommentAr(Tour tour) {
    return tourArCollection
        .doc(tour.tourId)
        .collection("TourRatingAr")
        .orderBy("timeStamp",descending: true)
        .snapshots()
        .map(TourRating().fromQuery);
  }


  Stream<List<CarRating>> getAllCarComment(Cars cars) {
    return carCollection
        .doc(cars.id)
        .collection("CarRating")
        .orderBy("timeStamp",descending: true)
        .snapshots()
        .map(CarRating().fromQuery);
  }

  Stream<List<CarRating>> getAllCarCommentAr(Cars cars) {
    return carArCollection
        .doc(cars.id)
        .collection("CarRatingAr")
        .orderBy("timeStamp",descending: true)
        .snapshots()
        .map(CarRating().fromQuery);
  }

  Future<void> addBookingHotel(
      BookingHotel booking, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingHotel")
        .doc(booking.bookingId)
        .set(booking.toJson());
  }

  Future<void> updateBookingHotel(BookingHotel booking, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingHotel")
        .doc(booking.bookingId)
        .update({
      "paid":true
    });
  }

  Future<void> deleteBookingHotel(BookingHotel booking, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingHotel")
        .doc(booking.bookingId)
        .delete();
  }

  Future<void> addBookingCar(BookingCar booking, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingCar")
        .doc(booking.bookingId)
        .set(booking.toJson());
  }

  Future<void> updateBookingCar(BookingCar booking, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingCar")
        .doc(booking.bookingId)
        .update({
      "paid":true
    });
  }

  Future<void> deleteBookingCar(BookingCar booking, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingCar")
        .doc(booking.bookingId)
        .delete();
  }

  Future<void> addBookingTour(BookingTour booking, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingTour")
        .doc(booking.bookingId)
        .set(booking.toJson());
  }

  Future<void> updateBookingTour(BookingTour booking, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingTour")
        .doc(booking.bookingId)
        .update({
      "paid":true
    });
  }

  Future<void> deleteBookingTour(BookingTour booking, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingTour")
        .doc(booking.bookingId)
        .delete();
  }

  Future<void> addBookingHotelAr(BookingHotel booking, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingHotelAr")
        .doc(booking.bookingId)
        .set(booking.toJson());
  }

  Future<void> updateBookingHotelAr(BookingHotel booking, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingHotelAr")
        .doc(booking.bookingId)
        .update({
      "paid":true
    });
  }

  Future<void> deleteBookingHotelAr(BookingHotel booking, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingHotelAr")
        .doc(booking.bookingId)
        .delete();
  }

  Future<void> addBookingCarAr(BookingCar booking, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingCarAr")
        .doc(booking.bookingId)
        .set(booking.toJson());
  }



  Future<void> updateBookingCarAr(BookingCar booking, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingCarAr")
        .doc(booking.bookingId)
        .update({
      "paid":true
    });
  }

  Future<void> deleteBookingCarAr(BookingCar booking, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingCarAr")
        .doc(booking.bookingId)
        .delete();
  }

  Future<void> addBookingTourAr(BookingTour booking, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingTourAr")
        .doc(booking.bookingId)
        .set(booking.toJson());
  }
  Future<void> updateBookingTourAr(BookingTour booking, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingTourAr")
        .doc(booking.bookingId)
        .update({
      "paid":true
    });
  }

  Future<void> deleteBookingTourAr(BookingTour booking, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingTourAr")
        .doc(booking.bookingId)
        .delete();
  }

  Future<void> addFavoritesHotel({String hotelId, String travellerId}) async {
    return await hotelCollection.doc(hotelId).update({'user_fav': FieldValue.arrayUnion(['$travellerId'])});
  }

  Future<void> addFavoritesTour({String tourId, String travellerId}) async {
    return await tourCollection.doc(tourId).update({'user_fav': FieldValue.arrayUnion(['$travellerId'])});
  }

  Future<void> addFavoritesCar({String carId, String travellerId}) async {
    return await carCollection.doc(carId).update({'user_fav': FieldValue.arrayUnion(['$travellerId'])});
  }

  Future<void> addFavoritesHotelAr({String hotelId, String travellerId}) async {
    return await hotelArCollection.doc(hotelId).update({'user_fav': FieldValue.arrayUnion(['$travellerId'])});
  }

  Future<void> addFavoritesTourAr({String tourId, String travellerId}) async {
    return await tourArCollection.doc(tourId).update({'user_fav': FieldValue.arrayUnion(['$travellerId'])});
  }

  Future<void> addFavoritesCarAr({String carId, String travellerId}) async {
    return await carArCollection.doc(carId).update({'user_fav': FieldValue.arrayUnion(['$travellerId'])});
  }

  Future<void> removeFavoritesHotel({String hotelId, String travellerId}) async {
    return await hotelCollection.doc(hotelId).update({'user_fav': FieldValue.arrayRemove(['$travellerId'])});
  }

  Future<void> removeFavoritesTour({String tourId, String travellerId}) async {
    return await tourCollection.doc(tourId).update({'user_fav': FieldValue.arrayRemove(['$travellerId'])});
  }

  Future<void> removeFavoritesCar({String carId, String travellerId}) async {
    return await carCollection.doc(carId).update({'user_fav': FieldValue.arrayRemove(['$travellerId'])});
  }

  Future<void> removeFavoritesHotelAr({String hotelId, String travellerId}) async {
    return await hotelArCollection.doc(hotelId).update({'user_fav': FieldValue.arrayRemove(['$travellerId'])});
  }

  Future<void> removeFavoritesTourAr({String tourId, String travellerId}) async {
    return await tourArCollection.doc(tourId).update({'user_fav': FieldValue.arrayRemove(['$travellerId'])});
  }

  Future<void> removeFavoritesCarAr({String carId, String travellerId}) async {
    return await carArCollection.doc(carId).update({'user_fav': FieldValue.arrayRemove(['$travellerId'])});
  }

  Future<void> addPaymentHotel(PaymentHotel payment, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingHotel")
        .doc(payment.paymentId)
        .collection("PaymentHotel")
        .doc()
        .set(payment.toJson());
  }

  Future<void> addPaymentHotelAr(PaymentHotel payment, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingHotelAr")
        .doc(payment.paymentId)
        .collection("PaymentHotelAr")
        .doc()
        .set(payment.toJson());
  }


  Future<void> addPaymentTour(PaymentTour payment, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingTour")
        .doc(payment.paymentId)
        .collection("PaymentTour")
        .doc()
        .set(payment.toJson());
  }


  Future<void> addPaymentCar(PaymentCar payment, Travelers travelers) async {
    return await travelerCollection
        .doc(travelers.id)
        .collection("BookingCar")
        .doc(payment.paymentId)
        .collection("PaymentCar")
        .doc()
        .set(payment.toJson());
  }


  Stream<List<BookingHotel>>  getBookingHotel(Travelers travelers,) {
    return travelerCollection.doc(travelers.id).collection("BookingHotel").where("paid",isEqualTo: true)
        .snapshots()
        .map(BookingHotel().fromQuery);
  }

  Stream<List<BookingTour>>  getBookingTour(Travelers travelers,) {
    return travelerCollection.doc(travelers.id).collection("BookingTour").where("paid",isEqualTo: true)
        .snapshots()
        .map(BookingTour().fromQuery);
  }

  Stream<List<BookingCar>>  getBookingCar(Travelers travelers,) {
    return travelerCollection.doc(travelers.id).collection("BookingCar").where("paid",isEqualTo: true)
        .snapshots()
        .map(BookingCar().fromQuery);
  }




  Stream<List<Hotel>> getFavoriteHotel(Travelers travelers) {
    return hotelCollection.where('user_fav', arrayContains: '${travelers.id}').snapshots().map(Hotel().fromQuery);
  }

  Stream<List<Tour>> getFavoriteTour(Travelers travelers) {
    return tourCollection.where('user_fav', arrayContains: '${travelers.id}').snapshots().map(Tour().fromQuery);
  }

  Stream<List<Cars>> getFavoriteCar(Travelers travelers) {
    return carCollection.where('user_fav', arrayContains: '${travelers.id}').snapshots().map(Cars().fromQuery);
  }

  Stream<List<Hotel>> getFavoriteHotelAr(Travelers travelers) {
    return hotelArCollection.where('user_fav', arrayContains: '${travelers.id}').snapshots().map(Hotel().fromQuery);
  }

  Stream<List<Tour>> getFavoriteTourAr(Travelers travelers) {
    return tourArCollection.where('user_fav', arrayContains: '${travelers.id}').snapshots().map(Tour().fromQuery);
  }

  Stream<List<Cars>> getFavoriteCarAr(Travelers travelers) {
    return carArCollection.where('user_fav', arrayContains: '${travelers.id}').snapshots().map(Cars().fromQuery);
  }

  // stream for hotels
  Stream<List<Hotel>> get getAllHotels {
    return hotelCollection
        .orderBy("hotelName")
        .snapshots()
        .map(Hotel().fromQuery);
  }

  Stream<List<Hotel>> get getHotels {
    return hotelCollection.limit(4).snapshots().map(Hotel().fromQuery);
  }

  // stream for hotels
  Stream<List<Hotel>> get getAllHotelsAr {
    return hotelArCollection
        .orderBy("hotelName")
        .snapshots()
        .map(Hotel().fromQuery);
  }

  Stream<List<Hotel>> get getHotelsAr {
    return hotelArCollection.limit(4).snapshots().map(Hotel().fromQuery);
  }

  // Future<void> addNewHotel(Hotel hotel)async{
  //   await hotelCollection.doc().set(hotel.toJson());
  // }

  // stream for cars
  Stream<List<Cars>> get getAllCars {
    return carCollection.orderBy("CarName").snapshots().map(Cars().fromQuery);
  }

  Stream<List<Cars>> get getCars {
    return carCollection.limit(4).snapshots().map(Cars().fromQuery);
  }

  // stream for cars
  Stream<List<Cars>> get getAllCarsAr {
    return carArCollection.orderBy("CarName").snapshots().map(Cars().fromQuery);
  }

  Stream<List<Cars>> get getCarsAr {
    return carArCollection.limit(4).snapshots().map(Cars().fromQuery);
  }

  // Future<void> addNewCar(Cars car)async{
  //   await carCollection.doc().set(car.toJson());
  // }

  // stream for tours
  Stream<List<Tour>> get getAllTours {
    return tourCollection
        .orderBy("PlaceName")
        .snapshots()
        .map(Tour().fromQuery);
  }

  // stream for tours
  Stream<List<Tour>> get getTours {
    return tourCollection.limit(4).snapshots().map(Tour().fromQuery);
  }

  Stream<List<Tour>> get getAllToursAr {
    return tourArCollection
        .orderBy("PlaceName")
        .snapshots()
        .map(Tour().fromQuery);
  }

  // stream for tours
  Stream<List<Tour>> get getToursAr {
    return tourArCollection.limit(4).snapshots().map(Tour().fromQuery);
  }

// Future<void> addNewTour(Tour tour)async{
//   await tourCollection.doc().set(tour.toJson());
// }

}

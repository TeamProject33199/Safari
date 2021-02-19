import 'package:cloud_firestore/cloud_firestore.dart';

class Hotel {

  String hotelId,
      hotelName,
      hotelCity,
      hotelCountry,
      hotelOverview,
      categoryName;
  List<String> room_Type;
  double hotelRate;
  double priceOfDay;
  List<String> images;
  List<String> favHotels;


  Hotel(
      {this.hotelId,
      this.hotelName,
      this.hotelCity,
      this.hotelCountry,
      this.hotelOverview,
      this.categoryName,
      this.hotelRate,
      this.priceOfDay,
      this.room_Type,
      this.images,
      this.favHotels
      });

  List<Hotel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Hotel(
        hotelId: doc.get('hotel_Id') ?? '',
        hotelCity: doc.get('hotelCity') ?? '',
        hotelCountry: doc.get('hotelCountry') ?? '',
        hotelName: doc.get('hotelName') ?? '',
        hotelRate: doc.get('hotelRate') !=null ?doc.get(
            'hotelRate') is double ? doc.get('hotelRate') : doc.get(
            'hotelRate') is String ? double.parse(
            doc.get('hotelRate')):doc.get('hotelRate').toDouble() : '',
        hotelOverview: doc.get('hotelOverview') ?? '',
        priceOfDay: doc.get('priceOfDay') != null ? doc.get(
            'priceOfDay') is double ? doc.get('priceOfDay') : doc.get(
            'priceOfDay') is String ? double.parse(
            doc.get('priceOfDay')):doc.get('priceOfDay').toDouble() : '',
        categoryName: doc.get('categoryName') ?? '',
        images: List.from(doc.get('images')) ?? [],
        room_Type: List.from(doc.get('room_Type')) ?? [],
        favHotels:List.from(doc.get('user_fav')) ?? [] ,

      );
    }).toList();
  }



  Map<String, dynamic> toJson() {
    return {
      'hotel_Id': hotelId,
      'hotelCity': hotelCity,
      'hotelCountry': hotelCountry,
      'hotelName': hotelName,
      'hotelRate': hotelRate,
      'hotelOverview': hotelOverview,
      'priceOfDay': priceOfDay,
      'categoryName': categoryName,
      'images': images,
      'room_Type': room_Type,
      'user_fav':favHotels,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Tour{
  String placeName,tourOverview,tourCountry,tourCity,categoryName,tourId;
  int duration;
  double tourRate,tourPrice;
  List<String> tourPhotos;
  List<String> favTours;
  double latitude, longitude;

  Tour({
    this.tourId,
      this.placeName,
      this.tourOverview,
      this.tourCountry,
      this.tourCity,
      this.categoryName,
      this.duration,
      this.tourRate,
      this.tourPrice,
      this.tourPhotos,
      this.favTours,
    this.longitude,
    this.latitude
  });

  List<Tour> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Tour(
        tourId: doc.get('Tour_Id') ?? '',
        placeName: doc.get('PlaceName') ?? '',
        tourCity: doc.get('TourCity') ?? '',
        tourCountry: doc.get('TourCountry') ?? '',
        duration: doc.get('TourDuration') !=null ?doc.get(
            'TourDuration') is int ? doc.get('TourDuration') : doc.get(
            'TourDuration') is String ? int.parse(
            doc.get('TourDuration')):doc.get('TourDuration').toInt() : '',
        tourRate: doc.get('TourRate') !=null ?doc.get(
            'TourRate') is double ? doc.get('TourRate') : doc.get(
            'TourRate') is String ? double.parse(
            doc.get('TourRate')):doc.get('TourRate').toDouble() : '',
        tourOverview: doc.get('TourOverview') ?? '',
        tourPrice: doc.get('TourPrice') !=null ?doc.get(
            'TourPrice') is double ? doc.get('TourPrice') : doc.get(
            'TourPrice') is String ? double.parse(
            doc.get('TourPrice')):doc.get('TourPrice').toDouble() : '',
        categoryName: doc.get('CategoryName') ?? '',
        tourPhotos: List.from(doc.get('TourPhotos')) ?? [],
        favTours:List.from(doc.get('user_fav')) ?? [] ,
        latitude: doc.get('latitude') != null
            ? doc.get('latitude') is double
            ? doc.get('latitude')
            : doc.get('latitude') is String
            ? double.parse(doc.get('latitude'))
            : doc.get('latitude').toDouble()
            : '',
        longitude: doc.get('longitude') != null
            ? doc.get('longitude') is double
            ? doc.get('longitude')
            : doc.get('longitude') is String
            ? double.parse(doc.get('longitude'))
            : doc.get('longitude').toDouble()
            : '',
      );
    }).toList();
  }


  Map<String, dynamic> toJson() {
    return {
      "Tour_Id":tourId,
      'TourCity': tourCity,
      'TourCountry': tourCountry,
      'PlaceName': placeName,
      "TourDuration":duration,
      'TourRate': tourRate,
      'TourOverview': tourOverview,
      'TourPrice': tourPrice,
      'CategoryName': categoryName,
      'TourPhotos': tourPhotos,
      'user_fav':favTours,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
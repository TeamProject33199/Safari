import 'package:cloud_firestore/cloud_firestore.dart';

class Cars {
  String id, carName, carOverview, carCountry, carCity, categoryName, carType;
  double carRate, priceOfDay;
  List<String> carPhotos;
  List<String> favCars;
  double latitude, longitude;

  Cars(
      {this.id,
        this.carName,
        this.carOverview,
        this.carCountry,
        this.carCity,
        this.categoryName,
        this.carType,
        this.carRate,
        this.favCars,
        this.priceOfDay,
        this.carPhotos,
        this.longitude,
        this.latitude
      });

  List<Cars> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Cars(
        id: doc.get("Car_Id") ?? '',
        carName: doc.get('CarName') ?? '',
        carCity: doc.get('CarCity') ?? '',
        carCountry: doc.get('CarCountry') ?? '',
        carRate: doc.get('CarRate') != null
            ? doc.get('CarRate') is double
            ? doc.get('CarRate')
            : doc.get('CarRate') is String
            ? double.parse(doc.get('CarRate'))
            : doc.get('CarRate').toDouble()
            : '',
        carOverview: doc.get('CarOverview') ?? '',
        priceOfDay: doc.get('PriceOfDay') != null
            ? doc.get('PriceOfDay') is double
            ? doc.get('PriceOfDay')
            : doc.get('PriceOfDay') is String
            ? double.parse(doc.get('PriceOfDay'))
            : doc.get('PriceOfDay').toDouble()
            : '',
        favCars:List.from(doc.get('user_fav')) ?? [] ,
        categoryName: doc.get('CategoryName') ?? '',
        carPhotos: List.from(doc.get('CarPhotos')) ?? [],
        carType: doc.get('CarType') ?? '',
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
      "Car_Id": id,
      'CarCity': carCity,
      'CarCountry': carCountry,
      'CarName': carName,
      'CarRate': carRate,
      'user_fav':favCars,
      'CarOverview': carOverview,
      'PriceOfDay': priceOfDay,
      'CategoryName': categoryName,
      'CarPhotos': carPhotos,
      'CarType': carType,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

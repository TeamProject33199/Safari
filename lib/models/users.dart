import 'package:cloud_firestore/cloud_firestore.dart';

class Travelers{

  String id,username,password,fullName,address,phone,gender,image;
  DateTime createdAt;
  Travelers({this.id,this.username, this.password, this.fullName,
      this.address, this.phone, this.gender, this.image,this.createdAt});


  List<Travelers> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Travelers(
        id: doc.get('traveler_id') ?? '',
        username: doc.get('username') ?? '',
        fullName: doc.get('fullName') ?? '',
        password: doc.get('password') ?? '',
        address: doc.get('address') ?? '',
        phone:doc.get('phone') ?? '',
        gender:doc.get('gender') ?? '',
        image:doc.get('image') ?? '',
        createdAt: doc.get("createdAt") ?? '',

      );
    }).toList();
  }


  Map<String, dynamic> toJson() {
    return {
      'traveler_id': id,
      'username': username,
      'fullName': fullName,
      'password': password,
      'address': address,
      'phone': phone,
      'gender': gender,
      'image': image,
      'createdAt':createdAt
    };
  }
}
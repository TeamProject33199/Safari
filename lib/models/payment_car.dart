import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentCar{
  String paymentId;
  DateTime paymentDate;
  int paymentPrice;

  PaymentCar({ this.paymentId, this.paymentDate, this.paymentPrice});

  List<PaymentCar> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PaymentCar(

        paymentId: doc.get('paymentId') ?? '',
        paymentDate: doc.get('paymentDate') ?? '',
        paymentPrice: doc.get('paymentPrice') !=null ?doc.get(
            'paymentPrice') is int ? doc.get('paymentPrice') : doc.get(
            'paymentPrice') is String ? int.parse(
            doc.get('paymentPrice')):doc.get('paymentPrice').toInt() : '',

      );
    }).toList();
  }



  Map<String, dynamic> toJson() {
    return {

      'paymentId': paymentId,
      'paymentDate': paymentDate,
      'paymentPrice': paymentPrice,
    };
  }
}
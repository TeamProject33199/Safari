import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentTour{
  String paymentId;
  DateTime paymentDate;
  int paymentPrice;

  PaymentTour({ this.paymentId, this.paymentDate, this.paymentPrice});

  List<PaymentTour> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PaymentTour(

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
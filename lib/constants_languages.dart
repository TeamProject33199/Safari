import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const  String English="en";
const  String Arabic="ar";

Future<Locale> setLocale(String languageCode)async{
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
  await sharedPreferences.setString("lang", languageCode);
  return _locale(languageCode);

}

Locale _locale(String languageCode) {
  Locale _temp;
  switch (languageCode) {
    case English:
      _temp = Locale(languageCode, "US");
      break;
    case Arabic:
      _temp = Locale(languageCode, "EG");
      break;
    default:
      _temp = Locale(English, "US");
      break;
  }
  return _temp;
}
Future<Locale> getLocale()async{
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
  String languageCode=sharedPreferences.getString("lang")??English;
  return _locale(languageCode);

}


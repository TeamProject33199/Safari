import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalization{
  Locale locale;
  AppLocalization(this.locale);

  Map<String,String> _loadedLocalizationValues;

  static AppLocalization of(BuildContext context){
    return Localizations.of(context, AppLocalization);
  }

  Future loadLanguage()async{
    String _langFile=await rootBundle.loadString("assets/languages/${locale.languageCode}.json");
    Map<String,dynamic> _loadedValues=jsonDecode(_langFile);
    _loadedLocalizationValues=_loadedValues.map((key, value) => MapEntry(key, value.toString()));
  }

  String getTranslated(String key){
    return  _loadedLocalizationValues[key];
  }

  static const LocalizationsDelegate<AppLocalization> delegate=_AppLocaleDelegate();

}

//=============================================================================================

class _AppLocaleDelegate extends LocalizationsDelegate<AppLocalization>{

  const _AppLocaleDelegate();

  @override
  bool isSupported(Locale locale) {
    return ["en","ar",].contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async{
    AppLocalization appLocale=AppLocalization(locale);
    await appLocale.loadLanguage();
    return appLocale;
  }

  @override
  bool shouldReload(_AppLocaleDelegate old) =>false;


}
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project/models/Provider_Offset.dart';
import 'package:project/view/on_boarding_screen.dart';
import 'package:project/view/splash_screen.dart';
import 'package:provider/provider.dart';
import 'Controllers/authentication/provider_auth.dart';
import 'locale_language/constants_languages.dart';
import 'locale_language/localization_delegate.dart';
import 'models/prograss_model_hud.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
      runApp(
        MultiProvider(
          providers:[
            ChangeNotifierProvider<AuthProvider>(
              create: (context) => AuthProvider(),
            ),
            ChangeNotifierProvider<ProviderOffset>(
              create: (context) => ProviderOffset(),
            ),
            ChangeNotifierProvider<prograssHud>(
              create: (context) => prograssHud(),
            ),

          ],
          child: MyApp(),
        ),
      );


}

class MyApp extends StatefulWidget {

  static void setLocale(BuildContext context,Locale locale){
    _MyAppState state=context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  Locale _locale;
  void setLocale(Locale locale){
    setState(() {
      _locale=locale;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getLocale().then((locale) {
      setState(() {
        this._locale=locale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          OnBoardingScreen.id: (context) => OnBoardingScreen(),
        },
      locale: _locale,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalization.delegate
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ar', 'EG'),
      ],
      localeResolutionCallback: (currentLocale,supportedLocales){
        if(currentLocale != null){
          for(Locale locale in supportedLocales){
            if(currentLocale.languageCode==locale.languageCode ){
              return currentLocale;
            }
          }
        }
        return supportedLocales.first;
      },
    );
  }
}

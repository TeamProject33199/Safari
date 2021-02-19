import 'package:flutter/foundation.dart';

class ProviderOffset extends ChangeNotifier {

  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;

  double xOffset2 = 0;
  double yOffset2 = 0;
  double scaleFactor2 = 1;



  drawerOpen(){

    xOffset = 230;
    yOffset = 120;
    scaleFactor = 0.7;
    isDrawerOpen = true;

    xOffset2 = 210;
    yOffset2 = 155;
    scaleFactor2 = 0.6;

    notifyListeners();
  }

  drawerClose(){

    xOffset = 0;
    yOffset = 0;
    scaleFactor = 1;
    isDrawerOpen = false;

    xOffset2 = 0;
    yOffset2 = 0;
    scaleFactor2 = 1;

    notifyListeners();
  }
  drawerOpenAR(){

    xOffset = -125;
    yOffset = 120;
    scaleFactor = 0.7;
    isDrawerOpen = true;

    xOffset2 = -70;
    yOffset2 = 155;
    scaleFactor2 = 0.6;

    notifyListeners();
  }
  drawerCloseAR(){

    xOffset = 0;
    yOffset = 0;
    scaleFactor = 1;
    isDrawerOpen = false;

    xOffset2 = 0;
    yOffset2 = 0;
    scaleFactor2 = 1;

    notifyListeners();
  }

}
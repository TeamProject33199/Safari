import 'package:flutter/material.dart';
import 'package:project/constants_colors.dart';
import 'package:project/models/Provider_Offset.dart';
import 'package:provider/provider.dart';

import 'drawer_screen.dart';
import 'home_screen.dart';

class AnimatedDrawer extends StatefulWidget {


  @override
  _AnimatedDrawerState createState() => _AnimatedDrawerState();
}

class _AnimatedDrawerState extends State<AnimatedDrawer> {
  @override
  Widget build(BuildContext context) {
    var providerType = Provider.of<ProviderOffset>(context);

    return Scaffold(
      body: Stack(
        children: [
          DrawerScreen(),
          AnimatedContainer(
            transform: Matrix4.translationValues(providerType.xOffset2, providerType.yOffset2, 0)
              ..scale(providerType.scaleFactor2),
            duration: Duration(milliseconds: 500),
            decoration: BoxDecoration(
                color: whiteColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(providerType.isDrawerOpen ? 20 : 0.0)),
          ),
          HomeScreen(),
        ],
      ),
    );
  }
}

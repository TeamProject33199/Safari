import 'package:flutter/material.dart';
import 'package:project/constants_colors.dart';
import 'package:project/locale_language/localization_delegate.dart';

class AboutUsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).getTranslated("about_us_title"),
          style: TextStyle(
              color: blackColor, fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Divider(
                    color: blackColor,
                    thickness: 1.2,
                  ),
                  width: 100,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  AppLocalization.of(context).getTranslated("text_our_team"),
                  style: TextStyle(color: primaryColor, fontSize: 20,fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  child: Divider(color: blackColor, thickness: 1),
                  width: 100,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: transparent,
                  elevation: 30,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image(
                      width: 150,
                      height: 200,
                      image: AssetImage("assets/images/hassan.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Text(
                      "\ ${AppLocalization.of(context).getTranslated("text_hassan1")} ",
                      style: TextStyle(fontSize: 18, color: primaryColor,fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\ ${AppLocalization.of(context).getTranslated("text_hassan2")}",
                      style: TextStyle(fontSize: 18, color: primaryColor,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Flutter Developer",
                      style: TextStyle(fontSize: 16, color: grey500Color),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: transparent,
                  elevation: 30,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image(
                      width: 150,
                      height: 200,
                      image: AssetImage("assets/images/ahmed.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Text(
                      "\ ${AppLocalization.of(context).getTranslated("text_lithy")}",
                      style: TextStyle(fontSize: 18, color: primaryColor,fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\ ${AppLocalization.of(context).getTranslated("text_lithy2")}",
                      style: TextStyle(fontSize: 18, color: primaryColor,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Flutter Developer",
                      style: TextStyle(fontSize: 16, color: grey500Color),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: transparent,
                  elevation: 30,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image(
                      width: 150,
                      height: 200,
                      image: AssetImage("assets/images/hossam.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Text(
                      "\ ${AppLocalization.of(context).getTranslated("text_hossam")} ",
                      style: TextStyle(fontSize: 18, color: primaryColor,fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\ ${AppLocalization.of(context).getTranslated("text_hossam2")}",
                      style: TextStyle(fontSize: 18, color: primaryColor,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Flutter Developer",
                      style: TextStyle(fontSize: 16, color: grey500Color),
                    ),

                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

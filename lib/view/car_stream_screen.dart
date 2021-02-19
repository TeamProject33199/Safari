
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:project/Controllers/firestore/DataBase.dart';
import 'package:project/constants_colors.dart';
import 'package:project/models/car.dart';
import 'package:project/view/details_screens/car_details.dart';
import '../locale_language/localization_delegate.dart';



class CarStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: AppLocalization.of(context).locale.languageCode=="ar"?DataBase().getCarsAr:DataBase().getCars,
        builder:(context,AsyncSnapshot<List<Cars>>snapshot) {
        if(snapshot.hasData){
          return Container(
            height: MediaQuery.of(context).size.height*0.85,
            child: StaggeredGridView.countBuilder(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                itemCount:
                snapshot.data != null && snapshot.data.length > 0 ? snapshot.data.length : 0,
                itemBuilder: (context, index) {
                  final Cars currentCar = snapshot.data[index];
                  return InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(currentCar.carPhotos[0]),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10),),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height*0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10),),
                              color: blackColor.withOpacity(0.4),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: AppLocalization.of(context).locale.languageCode ==
                                      'ar'
                                      ? const EdgeInsets.only(right: 8, top: 4)
                                      : const EdgeInsets.only(left: 8, top: 4),
                                  child: Text(currentCar.carName,style: TextStyle(color: whiteColor,fontSize: 13),),
                                ),
                                Padding(
                                  padding: AppLocalization.of(context).locale.languageCode ==
                                      'ar'
                                      ? const EdgeInsets.only(right: 5, top: 2)
                                      : const EdgeInsets.only(left: 5, top: 2),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on_sharp,color:redAccentColor,size: 16,),
                                      Text(currentCar.carCity,style: TextStyle(color: whiteColor,fontSize: 11),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CarsDetailsScreen(car: currentCar,)));
                    },
                  );
                },
                staggeredTileBuilder: (index){
                  return  StaggeredTile.count(1, index.isEven ? 1.8 : 1.2);
                }
            ),
          );
        }else if(snapshot.hasError){
          return Text(snapshot.error.toString());
        }else
          return Center(child: CircularProgressIndicator());

        },
    );

  }
}

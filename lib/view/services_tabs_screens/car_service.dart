import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;
import 'package:project/constants_colors.dart';
import 'package:project/locale_language/localization_delegate.dart';
import 'package:project/models/car.dart';
import 'package:project/models/car_filter_model.dart';
import 'package:project/view/services_tabs_screens/car_search_stream.dart';
import 'package:provider/provider.dart';

class CarsService extends StatefulWidget {
  @override
  _CarsServiceState createState() => _CarsServiceState();
}

class _CarsServiceState extends State<CarsService> {
  String dropdownValue;

  String dropdownValue2;

  double minPrice = 0;
  double maxPrice = 10000;
  double _lowerValue = 50;
  double _upperValue = 5000;

  List<Cars> filteredList;

  List<Cars> carList;
  bool isEmpty = true;
  bool isFilter = false;

  CarSearchModel result;
  String searchInput;

  @override
  void initState() {
    super.initState();
    carList = new List();
  }



  @override
  Widget build(BuildContext context) {
    carList = Provider.of<List<Cars>>(context);

    dropdownValue = AppLocalization.of(context).locale.languageCode == "ar"
        ? "القاهرة"
        : "Cairo";
    dropdownValue2 = AppLocalization.of(context).locale.languageCode == "ar"
        ? "فولفو"
        : "Volvo";

    if (isFilter && carList != null && (searchInput == null || searchInput.isEmpty)) {
      filteredList = carList;
      searchByFilters(result);
    } else if (searchInput != null && searchInput.isNotEmpty && carList != null && !isFilter)
    {
      filteredList = carList;
      searchMethod(searchInput);
    }


    return Container(
      color: grey50Color,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
        child: Column(
          children: [
            head(),
            SizedBox(
              height: 10,
            ),
            checkFilter(),
          ],
        ),
      ),
    );
  }

  Widget checkFilter() {
    if (isFilter || (searchInput != null && searchInput.isNotEmpty)) {
      return filteredList != null && filteredList.length == 0
          ? Container(child: Center(child: Text(
          AppLocalization.of(context)
              .getTranslated("no_data"))))
          : CarSearch(
        carList: filteredList,
      );
    } else {
      return carList != null && carList.length == 0
          ? Container(child: Center(child: Text(
          AppLocalization.of(context)
              .getTranslated("no_data"))))
          : CarSearch(
        carList: carList,
      );
    }
  }

  Widget head() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 55,
                child: Stack(
                  alignment:
                  AppLocalization.of(context).locale.languageCode == "ar"
                      ? Alignment.centerLeft
                      : Alignment.bottomRight,
                  children: [
                    FocusScope(
                      node: FocusScopeNode(),
                      child: TextFormField(
                        style: TextStyle(
                          color: blackColor,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: whiteColor,
                          hintText: AppLocalization.of(context)
                              .getTranslated("text_search"),
                          prefixIcon: Icon(
                            Icons.search,
                            color: grey700Color,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: whiteColor,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.5,
                              color: primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onChanged: (input) {
                          searchInput = input;
                          searchMethod(input);
                        },
                      ),
                    ),
                    Padding(
                      padding:
                      AppLocalization.of(context).locale.languageCode ==
                          "ar"
                          ? const EdgeInsets.only(left: 10)
                          : const EdgeInsets.only(right: 10, bottom: 8),
                      child: InkWell(
                        onTap: () {
                          _showFilter(context);
                        },
                        child: CircleAvatar(
                          radius: 19,
                          backgroundColor: grey50Color,
                          child: Icon(
                            Icons.tune,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showFilter(context) async {
    CarSearchModel model = CarSearchModel(
        cityName: dropdownValue,
        carType: dropdownValue2,
        lowerPrice: _lowerValue,
        upperPrice: _upperValue);
    var response = await showBarModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.69,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 30, right: 30, left: 30),
                    child: Column(
                      children: <Widget>[
                        Text(
                          AppLocalization.of(context)
                              .getTranslated("text_filters"),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: pink600Color,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: AppLocalization.of(context)
                                      .locale
                                      .languageCode ==
                                      "ar"
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Text(
                                    AppLocalization.of(context)
                                        .getTranslated("text_city_services"),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) =>
                                      Align(
                                        alignment: AppLocalization.of(context)
                                            .locale
                                            .languageCode ==
                                            "ar"
                                            ? Alignment.topRight
                                            : Alignment.topLeft,
                                        child: Container(
                                          width: MediaQuery.of(context).size.width *
                                              0.5,
                                          child: DropdownButton<Object>(
                                            isExpanded: true,
                                            value: dropdownValue,
                                            style: TextStyle(color: grey600Color),
                                            items: <Object>[
                                              AppLocalization.of(context)
                                                  .getTranslated("text_cairo"),
                                              AppLocalization.of(context)
                                                  .getTranslated("text_giza"),
                                              AppLocalization.of(context)
                                                  .getTranslated(
                                                  "text_sharm_elsheikh"),
                                              AppLocalization.of(context)
                                                  .getTranslated("text_luxor"),
                                              AppLocalization.of(context)
                                                  .getTranslated("text_aswan"),
                                              AppLocalization.of(context)
                                                  .getTranslated("text_hurghada"),
                                              AppLocalization.of(context)
                                                  .getTranslated("text_alexandria"),
                                            ].map<DropdownMenuItem<Object>>(
                                                    (Object value) {
                                                  return DropdownMenuItem<Object>(
                                                    value: value,
                                                    child: Row(children: [
                                                      Icon(
                                                        FontAwesomeIcons.mapMarkerAlt,
                                                        color: deepPurpleColor,
                                                        size: 22,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(value.toString()),
                                                    ]),
                                                  );
                                                }).toList(),
                                            onChanged: (Object newValue) {
                                              setState(() {
                                                dropdownValue = newValue.toString();
                                              });
                                              model.cityName = newValue.toString();
                                            },
                                          ),
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    AppLocalization.of(context)
                                        .getTranslated("text_car_type"),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) =>
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          width: MediaQuery.of(context).size.width *
                                              0.5,
                                          child: DropdownButton<Object>(
                                            isExpanded: true,
                                            value: dropdownValue2,
                                            style: TextStyle(color: grey600Color),
                                            items: <Object>[
                                              AppLocalization.of(context)
                                                  .getTranslated("text_car_1"),
                                              AppLocalization.of(context)
                                                  .getTranslated("text_car_2"),
                                              AppLocalization.of(context)
                                                  .getTranslated("text_car_3"),
                                              AppLocalization.of(context)
                                                  .getTranslated("text_car_4"),
                                              AppLocalization.of(context)
                                                  .getTranslated("text_car_5"),
                                              AppLocalization.of(context)
                                                  .getTranslated("text_car_6"),
                                              AppLocalization.of(context)
                                                  .getTranslated("text_car_7"),
                                              AppLocalization.of(context)
                                                  .getTranslated("text_car_8"),
                                              AppLocalization.of(context)
                                                  .getTranslated("text_car_9"),
                                              AppLocalization.of(context)
                                                  .getTranslated("text_car_10"),
                                              AppLocalization.of(context)
                                                  .getTranslated("text_car_11"),
                                              AppLocalization.of(context)
                                                  .getTranslated("text_car_12"),
                                              AppLocalization.of(context)
                                                  .getTranslated("text_car_13"),
                                            ].map<DropdownMenuItem<Object>>(
                                                    (Object value) {
                                                  return DropdownMenuItem<Object>(
                                                    value: value,
                                                    child: Row(children: [
                                                      Icon(
                                                        FontAwesomeIcons.car,
                                                        color: deepPurpleColor,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(value.toString()),
                                                    ]),
                                                  );
                                                }).toList(),
                                            onChanged: (Object newValue) {
                                              setState(() {
                                                dropdownValue2 =
                                                    newValue.toString();
                                              });
                                              model.carType = newValue.toString();
                                            },
                                          ),
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Align(
                            alignment: AppLocalization.of(context)
                                .locale
                                .languageCode ==
                                "ar"
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Text(
                              AppLocalization.of(context)
                                  .getTranslated("text_price_range"),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalization.of(context).locale.languageCode ==
                                  "ar"
                                  ? AppLocalization.of(context)
                                  .getTranslated("text_maximum")
                                  : AppLocalization.of(context)
                                  .getTranslated("text_minimum"),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: grey900Color,
                              ),
                            ),
                            Text(
                              AppLocalization.of(context).locale.languageCode ==
                                  "ar"
                                  ? AppLocalization.of(context)
                                  .getTranslated("text_minimum")
                                  : AppLocalization.of(context)
                                  .getTranslated("text_maximum"),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: grey900Color,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 2.5,
                      activeTrackColor: deepPurpleColor,
                      thumbColor: deepPurpleColor,
                      valueIndicatorColor: deepPurpleColor,
                      inactiveTrackColor: deepPurpleColor.withOpacity(0.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: frs.RangeSlider(
                        min: minPrice,
                        max: maxPrice,
                        lowerValue: _lowerValue,
                        upperValue: _upperValue,
                        divisions: 500,
                        showValueIndicator: true,
                        valueIndicatorMaxDecimals: 1,
                        onChanged:
                            (double newLowerValue, double newUpperValue) {
                          setState(() {
                            _lowerValue = newLowerValue;
                            _upperValue = newUpperValue;
                          });
                          model.lowerPrice = newLowerValue;
                          model.upperPrice = newUpperValue;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
                    child: Container(
                      width: 150,
                      height: 45,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        color: primaryColor,
                        child: Text(
                          AppLocalization.of(context)
                              .getTranslated("button_save_filters"),
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 14,
                          ),
                        ),
                        elevation: 8,
                        onPressed: () {
                          Navigator.of(context).pop(model);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });

    if (response != null) {
      setState(() {
        result = response;
        isFilter = true;
      });
      searchByFilters(response);
    }
  }


  void searchByFilters(CarSearchModel model) {
    filteredList = new List();

    carList.forEach((element) {
      //print("${element.carType}");
      if (element.carCity.contains(model.cityName) &&
          element.carType.contains(model.carType) &&
          element.priceOfDay >= model.lowerPrice &&
          element.priceOfDay <= model.upperPrice) filteredList.add(element);
    });

    setState(() {});
  }

  void searchMethod(String input) {
    if (input.length == 0) {
      filteredList = null;
    }
    if (input.length > 0) {
      isFilter = false;

      filteredList = new List();
      filteredList.addAll(carList
          .where(
            (element) => element.carName.toLowerCase().contains(input),
      )
          .toList());
    }
    setState(() {});
  }
}

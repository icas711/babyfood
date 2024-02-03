import 'dart:io';

import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/feature/presentation/pages/home/widget/home_list_widget.dart';
import 'package:babyfood/feature/presentation/pages/home/widget/slider_carousel_home.dart';
import 'package:babyfood/feature/presentation/pages/home/widget/title_with_underline.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rate_my_app/rate_my_app.dart';

class Body extends StatefulWidget {

  @override
  State<Body> createState() => _BodyState();
}



class _BodyState extends State<Body> {
  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 5,
    minLaunches: 10,
    remindDays: 3,
    remindLaunches: 5,
    appStoreIdentifier: '6476832307',
    googlePlayIdentifier: 'com.babylabpro.babyfood',
  );
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    rateMyApp.init().then((_) {
      if (rateMyApp.shouldOpenDialog) {
        //if (true) {
        rateMyApp.showRateDialog(
          context,
          title: "Оцените приложение",
          // The dialog title.
          message: "Если вам понравилось приложение, пожалуйста, найдите немного времени и оцените!\nЭто действительно поможет нам и займет у вас не более одной минуты.",
          rateButton: "Оценить",
          // The dialog "rate" button text.
          noButton: "Нет",
          // The dialog "no" button text.
          laterButton: "Позже",
          // The dialog "later" button text.
          listener: (button) {
            // The button click listener (useful if you want to cancel the click event).
            switch (button) {
              case RateMyAppDialogButton.rate:
                debugPrint('Clicked on "Rate".');
                break;
              case RateMyAppDialogButton.later:
                debugPrint('Clicked on "Later".');
                break;
              case RateMyAppDialogButton.no:
                debugPrint('Clicked on "No".');
                break;
            }

            return true; // Return false if you want to cancel the click event.
          },
          ignoreNativeDialog: Platform.isAndroid,
          // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
          dialogStyle: const DialogStyle(
            messageStyle: TextStyle(fontFamily: 'Roboto'),
            titleStyle: TextStyle(fontFamily: 'Roboto'),
          ),
          // Custom dialog styles.
          onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
              .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
          //contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
          // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // It will provie us total height  and width of our screen
    Size size = MediaQuery.of(context).size;
    // it enable scrolling on small device
 /*   rateMyApp.conditions.forEach((condition) {
      if (condition is DebuggableCondition) {
        print(condition!.valuesAsString!); // We iterate through our list of conditions and we print all debuggable ones.
      }
    });*/
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //HeaderWithSearchBox(size: size, isWithSearch: false, title: 'Baby Food',),
          const SizedBox(
            height: kDefaultPadding,
          ),
          const TitleWithMoreBtn(title: "Гайды",),

          GuideList(),
          const SizedBox(
            height: kDefaultPadding,
          ),
          const Divider(),
          TitleWithMoreBtn(
            title: "Поиск в библиотеке продуктов",
            press: () {
              context.goNamed('foods',);
            },
          ),
          const Divider(),
          const SizedBox(
            height: kDefaultPadding,
          ),
          HomeSliderCarousel(),
          const SizedBox(
            height: kDefaultPadding,
          ),
          const Divider(),
          TitleWithMoreBtn(title: "Поиск рецептов блюд", press: () {context.goNamed('recipe',);}),
          const Divider(),
          const SizedBox(height: kDefaultPadding),
        ],
      ),
    );
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}




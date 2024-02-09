import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/core/utils/textstyle.dart';
import 'package:flutter/material.dart';
class TitleWithMoreBtn extends StatelessWidget {
  const TitleWithMoreBtn({
    super.key,
    required this.title,
    this.press,
  });
  final String title;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: ThemeText.sliverText,
              //overflow: TextOverflow.ellipsis,
              //maxLines: 2,
            ),
          ),

          if(press!=null)...[
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(kPrimaryColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(
                        color: kPrimaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  press!();
                },
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                )),]
        ],
      ),
    );
  }
}


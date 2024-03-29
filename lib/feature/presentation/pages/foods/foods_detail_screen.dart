import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/core/utils/network_provider.dart';
import 'package:babyfood/core/utils/textstyle.dart';
import 'package:babyfood/feature/domain/entities/convenience_food_entity.dart';
import 'package:babyfood/feature/presentation/pages/foods/widget/recipe_list_widget.dart';
import 'package:babyfood/feature/presentation/widgets/bolding_text.dart';
import 'package:babyfood/feature/presentation/widgets/food_cache_image_widget.dart';
import 'package:babyfood/feature/presentation/widgets/question_button_nutritial_rating.dart';
import 'package:babyfood/feature/presentation/widgets/selectable_button.dart';
import 'package:babyfood/feature/presentation/widgets/star_rating.dart';
import 'package:babyfood/feature/presentation/widgets/text_on_screen.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

class ProductDetailsScreen extends StatefulWidget {

  final ConvenienceFoodEntity person;

  const ProductDetailsScreen({super.key, required this.person});

  @override
  State<ProductDetailsScreen> createState() => _PersonDetailPageState();
}

class _PersonDetailPageState extends State<ProductDetailsScreen> {
  final networks = NetworkProvider.instance.bannerNetworks;

  late String adUnitId = networks.first.adUnitId;
  AdRequest adRequest = const AdRequest();
  bool isLoading = false;
  bool isBannerAlreadyCreated = false;
  bool isSticky = true;
  late BannerAd banner;

  Map<String, bool> selectedButtons = {
    'HowToOffer': true,
    'Character': false,
    'HowToPrepare': false,
    'DurabilityAndStorage': false,
    'DidYouKnow': false,
    'Recipes': false,
  };
  Map<String, String> buttonsNames = {
    'HowToOffer': 'Подача',
    'Character': 'Характеристики',
    'HowToPrepare': 'Как приготовить',
    'DurabilityAndStorage': 'Сроки хранения',
    'DidYouKnow': 'А вы знали?',
    'Recipes': 'Рецепты',
  };

  String checkNum(int x){
    return x<10?'0$x':x.toString();
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async => _loadBanner());
  }

  @override
  Widget build(BuildContext context) {
    final isScreenWide = MediaQuery.sizeOf(context).width >= Routes.mediumScreen;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person.name),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: isBannerAlreadyCreated ? AdWidget(bannerAd: banner) : null,
          ),
          Expanded(
            child: SingleChildScrollView(
              //padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Wrap(
                //direction: isScreenWide ? Axis.horizontal : Axis.vertical,

                children: [
                  LayoutBuilder(builder:
                      (context, constraints) {
                    return SizedBox(
                      width: isScreenWide
                          ? constraints.maxWidth /
                              2 //MediaQuery.sizeOf(context).width / 2.4
                          : constraints.maxWidth,
                      child: Column(
                        children: [
                          /*Container(
                            child: Image.network(person.image, fit: BoxFit.fill),
                          ),*/
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox(
                              width: double.infinity,
                              child: AspectRatio(
                                aspectRatio: 4 / 3,
                                child: PersonCacheImage(
                                  //height: 160,
                                  imageUrl: widget.person.image,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              widget.person.name,
                              style: const TextStyle(
                                fontSize: 28,
                                color: Colors.black87,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.blueGrey.shade100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PartBoldText(
                                  part1: 'Начинать вводить в рацион: с ',
                                  part2:
                                      '${widget.person.ageofIntroduce} месяцев',
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                      //direction: isScreenWide ? Axis.horizontal : Axis.vertical,
                                      children: [
                                        PartBoldText(
                                            part1: 'Нутритивная польза:',
                                            part2: ''),
                                        SizedBox(
                                          height: 20,
                                          width: 120,
                                          child: StarRating(
                                            rating: double.parse(
                                                widget.person.nutritionRating),
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(
                                            width: 30,
                                            child: NutritialRatingOwerview()),
                                      ]),
                                ),
                                PartBoldText(
                                  part1: 'Общий аллерген: ',
                                  part2: widget.person.commonAllergen == 1
                                      ? 'Да'
                                      : 'Нет',
                                ),
                                if (widget.person.poopFriendly == 1)
                                  PartBoldText(
                                    part1: 'Легкий стул: ',
                                    part2: widget.person.poopFriendly == 1
                                        ? 'Да'
                                        : 'Нет',
                                  ),
                                if (widget.person.highChockinHazard == 1)
                                  PartBoldText(
                                    part1: 'Опасность удушья: ',
                                    part2: widget.person.highChockinHazard == 1
                                        ? 'Да ⚠️'
                                        : 'Нет',
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: kDefaultPadding,
                          ),
                          /*Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: LayoutBuilder(builder:
                                  (BuildContext context, BoxConstraints constraints) {
                                double buttonWidth = constraints.maxWidth / 2.2;
                                return Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  alignment: WrapAlignment.spaceBetween,
                                  children: foodButtons(buttonWidth),
                                );
                              }),
                            ),
                          ),*/
                          // if (isBannerAlreadyCreated) AdWidget(bannerAd: banner),
                        ],
                      ),
                    );
                  }),
                  LayoutBuilder(builder:
                      (context, constraints) {
                    return SizedBox(
                      width: isScreenWide
                          ? constraints.maxWidth /
                              2 //MediaQuery.sizeOf(context).width / 2.4
                          : constraints.maxWidth,
                      child: Column(children: [
                        const SizedBox(
                          height: 16,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Подача',
                              style: ThemeText.welcome,
                            ),
                          ),
                        ),
                        HtmlTextOnScreen(
                            data: widget.person.howToOffer,
                            width: constraints.maxWidth,
                            isScreenWide: isScreenWide),
                        const Column(
                          children: [
                            Divider(),
                            Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Характеристики',
                                  style: ThemeText.welcome,
                                ),
                              ),
                            ),
                          ],
                        ),
                        HtmlTextOnScreen(
                            data: widget.person.characteristics,
                            width: constraints.maxWidth,
                            isScreenWide: isScreenWide),
                        if (widget.person.howToPrepare.length > 3)
                          const Column(
                            children: [
                              Divider(),
                              Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Как приготовить',
                                    style: ThemeText.welcome,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        HtmlTextOnScreen(
                            data: widget.person.howToPrepare,
                            width: constraints.maxWidth,
                            isScreenWide: isScreenWide),
                        if (widget.person.durabilityAndStorage.length > 2)
                          const Column(
                            children: [
                              Divider(),
                              Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Сроки хранения',
                                    style: ThemeText.welcome,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        HtmlTextOnScreen(
                            data: widget.person.durabilityAndStorage,
                            width: constraints.maxWidth,
                            isScreenWide: isScreenWide),
                        if (widget.person.didYouKnow.length > 2)
                          const Column(
                            children: [
                              Divider(),
                              Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'А вы знали?',
                                    style: ThemeText.welcome,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        HtmlTextOnScreen(
                            data: widget.person.didYouKnow,
                            width: constraints.maxWidth,
                            isScreenWide: isScreenWide),
                        if (widget.person.recipes!.isNotEmpty) ...[
                          Column(
                            children: [
                              const Divider(),
                              const Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Рецепты',
                                    style: ThemeText.welcome,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              RecipeList(
                                recipe: widget.person.recipes!,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ]
                      ]),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> foodButtons(double buttonWidth) {
    List<Widget> buttonsList = [];
    for (final element in selectedButtons.entries) {
      buttonsList.add(SelectableButton(
        width: buttonWidth,
        selected: selectedButtons[element.key]!,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (states) {
              if (states.contains(MaterialState.selected)) {
                return kSelectedColor;
              }
              return kPrimaryColor; // defer to the defaults
            },
          ),
        ),
        child: Text(buttonsNames[element.key]!,
            style: const TextStyle(color: Colors.white)),
        onPressed: () {
          setState(() {
            selectedButtons.forEach((key, value) {
              selectedButtons[key] = false;
            });
            selectedButtons[element.key] = true;
          });
        },
      ));
    }
    return buttonsList;
  }

  Future<void> _loadBanner() async {
    final windowSize = MediaQuery.of(context).size;
    setState(() => isLoading = true);
    if (isBannerAlreadyCreated) {
      await banner.loadAd(adRequest: adRequest);
    } else {
      final adSize = isSticky
          ? BannerAdSize.sticky(width: windowSize.width.toInt())
          : BannerAdSize.inline(
              width: windowSize.width.toInt(),
              maxHeight: windowSize.height ~/ 3,
            );
      final calculatedBannerSize = await adSize.getCalculatedBannerAdSize();
      debugPrint('calculatedBannerSize: $calculatedBannerSize');
      banner = _createBanner(adSize);

      setState(() {
        isBannerAlreadyCreated = true;
      });
    }
  }

  BannerAd _createBanner(BannerAdSize adSize) {
    return BannerAd(
      adUnitId: adUnitId,
      adSize: adSize,
      adRequest: adRequest,
      onAdLoaded: () {
        setState(() {
          isLoading = false;
        });
        debugPrint('callback: banner ad loaded');
      },
      onAdFailedToLoad: (error) {
        setState(() => isLoading = false);
        debugPrint('callback: banner ad failed to load, '
            'code: ${error.code}, description: ${error.description}');
      },
      onAdClicked: () => debugPrint('callback: banner ad clicked'),
      onLeftApplication: () => debugPrint('callback: left app'),
      onReturnedToApplication: () => debugPrint('callback: returned to app'),
      onImpression: (data) =>
          debugPrint('callback: impression: ${data.getRawData()}'),
    );
  }
}

import 'package:babyfood/common/app_colors.dart';
import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/feature/domain/entities/recipe_entity.dart';
import 'package:babyfood/feature/presentation/pages/foods/full_screen_image.dart';
import 'package:babyfood/feature/presentation/widgets/bolding_text.dart';
import 'package:babyfood/feature/presentation/widgets/html_cache_image.dart';
import 'package:babyfood/core/utils/network_provider.dart';
import 'package:babyfood/feature/presentation/widgets/food_cache_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

class RecipeDetailsScreen extends StatefulWidget {
  /// Constructs a [DetailsScreen].

  /// The label to display in the center of the screen.
  final RecipeEntity recipe;

  const RecipeDetailsScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailsScreen> {
  final networks = NetworkProvider.instance.bannerNetworks2;
  //R-M-5620774-3
  late var adUnitId = networks.first.adUnitId;
  var adRequest = const AdRequest();
  var isLoading = false;
  var isBannerAlreadyCreated = false;
  bool isSticky = false;
  late BannerAd banner;

   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadBanner());

  }
  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.sizeOf(context).width >= Routes.mediumScreen;
    return Scaffold(
      appBar: AppBar(
        title: Text('Рецепт "${widget.recipe.name}"'),
      ),
      body: SingleChildScrollView(
        //padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Wrap(
          //direction: isScreenWide ? Axis.horizontal : Axis.vertical,

          children: [
            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
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
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: PersonCacheImage(
                            //height: 160,
                            imageUrl: widget.recipe.image,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        widget.recipe.name,
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
                      color: Colors.grey[200],
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: PartBoldText(
                              part1: 'Возраст: ',
                              part2: '${widget.recipe.ageofIntroduce}+ месяцев',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: PartBoldText(
                              part1: 'Получится: ',
                              part2: '${widget.recipe.yield}',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: PartBoldText(
                              part1: 'Время приготовления: ',
                              part2: '${widget.recipe.cookingTime}',
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isBannerAlreadyCreated) AdWidget(bannerAd: banner),
                  ],
                ),
              );
            }),
            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                width: isScreenWide
                    ? constraints.maxWidth /
                        2 //MediaQuery.sizeOf(context).width / 2.4
                    : constraints.maxWidth,
                child: Column(children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Html(
                    data: """
                  ${widget.recipe.recipe}""",
                    onLinkTap: (url, _, __) {
                      context.goNamed(
                        'product-detail',
                        pathParameters: {
                          'foodId': url.toString(),
                        },
                      );
                      debugPrint("Opening $url...");
                    },
                    extensions: [
                      ImageExtension(builder: (extensionContext) {
                        final element = extensionContext.element!.parent!
                            .parent!.children.length; // as ImageElement;
                        final element1 = extensionContext.attributes['src'];
                        double childImageWidth = isScreenWide
                            ? constraints.maxWidth / (element * 2.4)
                            : constraints.maxWidth / (element * 1.2);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FullScreenImageViewer(element1!)),
                            );
                          },
                          child: HtmlCacheImage(
                            imageUrl: element1!,
                            width: childImageWidth,
                            height: childImageWidth,
                          ),
                        );
                      }),
                      const TableHtmlExtension(),
                    ],
                    style: {
                      "a": Style(textDecoration: TextDecoration.none),
                      "body": Style(fontSize: FontSize(Routes.sizeFonts)),
                      "tr": Style(),
                      "th": Style(
                        padding: HtmlPaddings.all(6.0),
                        backgroundColor: Colors.grey,
                      ),
                      "td": Style(
                        padding: HtmlPaddings.all(6.0),
                        alignment: Alignment.topLeft,
                      ),
                    },
                  ),
                ]),
              );
            }),
          ],
        ),
      ),
    );
  }

  List<Widget> buildText(String text, String value) {
    return [
      Text(
        text,
        style: const TextStyle(
          color: AppColors.greyColor,
        ),
      ),
      const SizedBox(
        height: 4,
      ),
      Text(
        value,
        style: const TextStyle(
          color: Colors.black87,
        ),
      ),
      const SizedBox(
        height: 12,
      ),
    ];
  }

  Future<void> _loadBanner() async {
    final windowSize = MediaQuery.of(context).size;
    setState(() => isLoading = true);
    if (isBannerAlreadyCreated) {
      banner.loadAd(adRequest: adRequest);
    } else {
      final adSize = isSticky
          ? BannerAdSize.sticky(width: windowSize.width.toInt())
          : BannerAdSize.inline(
        width: windowSize.width.toInt(),
        maxHeight: windowSize.height ~/ 3,
      );
      var calculatedBannerSize = await adSize.getCalculatedBannerAdSize();
      debugPrint('calculatedBannerSize: ${calculatedBannerSize.toString()}');
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


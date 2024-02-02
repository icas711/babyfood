import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/feature/domain/entities/guides_entity.dart';
import 'package:babyfood/feature/presentation/widgets/food_cache_image_widget.dart';
import 'package:babyfood/feature/presentation/widgets/text_on_screen.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import '../../widgets/network_provider.dart';

class HomeDetailsScreen extends StatefulWidget {
  /// Constructs a [DetailsScreen].

  /// The label to display in the center of the screen.
  final GuideEntity guide;

  const HomeDetailsScreen({Key? key, required this.guide})
      : super(key: key);

  @override
  State<HomeDetailsScreen> createState() => _PersonDetailPageState();
}

class _PersonDetailPageState extends State<HomeDetailsScreen> {
  final networks = NetworkProvider.instance.interstitialNetworks;
  late var adUnitId = networks.first.adUnitId;
  InterstitialAd? _ad;
  late final Future<InterstitialAdLoader> _adLoader;
  var adRequest = const AdRequest();
  late var _adRequestConfiguration = AdRequestConfiguration(adUnitId: adUnitId);
  var isLoading = false;



  @override
  void initState() {
    super.initState();
    //_adLoader = _createInterstitialAdLoader();
    _adLoader = _createInterstitialAdLoader();
    _loadInterstitialAd();
    Future.delayed(const Duration(seconds: 60), () {
// Here you can write your code
      _showAd();
    });

  }

  Future<InterstitialAdLoader> _createInterstitialAdLoader() {

    return InterstitialAdLoader.create(
      onAdLoaded: (InterstitialAd interstitialAd) {
        // The ad was loaded successfully. Now you can show loaded ad
        _ad = interstitialAd;
      },
      onAdFailedToLoad: (error) {
        // Ad failed to load with AdRequestError.
        // Attempting to load a new ad from the onAdFailedToLoad() method is strongly discouraged.
      },
    );
  }

  Future<void> _loadInterstitialAd() async {
    final adLoader = await _adLoader;
    setState(() => isLoading = true);
    await adLoader.loadAd(adRequestConfiguration: _adRequestConfiguration);
    debugPrint('async: load interstitial ad');
  }

  _showAd() async {
    _ad?.setAdEventListener(
        eventListener: InterstitialAdEventListener(
          onAdShown: () {
            // Called when ad is shown.
          },
          onAdFailedToShow: (error) {
            // Called when an InterstitialAd failed to show.
            // Destroy the ad so you don't show the ad a second time.
            _ad?.destroy();
            _ad = null;

            // Now you can preload the next interstitial ad.
            _loadInterstitialAd();
          },
          onAdClicked: () {
            // Called when a click is recorded for an ad.
          },
          onAdDismissed: () {
            // Called when ad is dismissed.
            // Destroy the ad so you don't show the ad a second time.
            _ad?.destroy();
            _ad = null;

            // Now you can preload the next interstitial ad.
            _loadInterstitialAd();
          },
          onAdImpression: (impressionData) {
            debugPrint('callback: impression: ${impressionData.getRawData()}');
            // Called when an impression is recorded for an ad.
          },
        ));
    await _ad?.show();
    await _ad?.waitForDismiss();
  }
  @override
  Widget build(BuildContext context) {

    bool isScreenWide = MediaQuery.sizeOf(context).width >= Routes.mediumScreen;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Гайды'),
      ),
      body: SingleChildScrollView(
        //padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Wrap(
          //direction: isScreenWide ? Axis.horizontal : Axis.vertical,

          children: [
            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),

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
                            aspectRatio: 4 / 7,
                            child: PersonCacheImage(
                              //height: 160,
                              imageUrl: widget.guide.image,
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
                          widget.guide.name,
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


                    ],
                  ),
                ),
              );
            }),
            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                width:  constraints.maxWidth,
                child: Column(children: [
                  const SizedBox(
                    height: 16,
                  ),

                  HtmlTextOnScreenGuides(data: widget.guide.text, width: constraints.maxWidth, isScreenWide: isScreenWide),

                ]),
              );
            }),
          ],
        ),
      ),
    );
  }


}

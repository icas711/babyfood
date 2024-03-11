import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/feature/presentation/bloc/guide_list_cubit/guide_list_cubit.dart';
import 'package:babyfood/feature/presentation/bloc/food_list_cubit/convenience_food_list_cubit.dart';
import 'package:babyfood/feature/presentation/bloc/recipe_list_cubit/recipe_list_cubit.dart';
import 'package:babyfood/feature/presentation/pages/settings/widgets/gdpr_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late SharedPreferences prefs;
  late DateTime dateCahedList;
  late String formattedDate = '';

  void _getprefs() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      int? timestamp = prefs.getInt('DATE_CACHED_FOOD_LIST');
      dateCahedList = DateTime.fromMillisecondsSinceEpoch(timestamp!);
      formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(dateCahedList);
    });
  }

  void _setprefs() async {
    context.read<ConvenienceFoodListCubit>().clearProducts();
    context.read<RecipeListCubit>().clearProducts();
    context.read<GuideListCubit>().clearGuides();
    await prefs.remove('babyfood');
    await prefs.remove('babyrecipe');
    await prefs.remove('babyguides');
    //await DefaultCacheManager().emptyCache();
    DefaultCacheManager manager = DefaultCacheManager();
    manager.emptyCache();
    imageCache!.clear();
    imageCache!.clearLiveImages();
    //DefaultCacheManager().store.emptyMemoryCache();
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt('DATE_CACHED_FOOD_LIST', timestamp);
    setState(() {
      dateCahedList = DateTime.now();
      formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(dateCahedList);
    });
    context.read<ConvenienceFoodListCubit>().loadPerson();
    context.read<RecipeListCubit>().loadRecipe();
    context.read<GuideListCubit>().loadGuide();
  }

  _clearCache() {
    _setprefs();
    //goRouter.go('/a');
  }

  @override
  void initState() {
    super.initState();
    _getprefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Настройки')),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                direction:
                    MediaQuery.of(context).size.width > Routes.mediumScreen
                        ? Axis.horizontal
                        : Axis.vertical,
                children: [
                  const Text('Дата обновления данных: '),
                  if (formattedDate.length > 1)
                    Text(
                      formattedDate,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: TextButton(
                        onPressed: () {
                          _clearCache();
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Обновление'),
                              content: const Text(
                                  'Библиотека полностью обновилась. Возможно появились новые рецепты, гайды и продукты.\n'
                                  'Но т.к. приложение проводит проверку новых данных при включении, то это не обязательная процедура.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Закрыть'),
                                  child: const Text('Закрыть'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text(
                          'Обновить',
                          style: TextStyle(
                              color: Colors.white),
                        )),
                  ),
                ],
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: const Icon(Icons.handshake_outlined),
                  title: MobileAds.userConsent
                      ? const Text('Согласие пользователя принято')
                      : const Text('Согласие пользователя отклонено'),
                  trailing: TextButton(
                    child: Text('Изменить', style: TextStyle(
                        color: Colors.white),),
                    onPressed: () async {
                      final bool result = await showDialog(
                        context: context,
                        builder: (context) => const GdprDialog(),
                      );
                      MobileAds.setUserConsent(result);
                      setState(() {});
                    },
                  ),
                ),
                /*ListTile(
                  leading: const Icon(Icons.place_outlined),
                  title: MobileAds.locationConsent
                      ? const Text('Согласие на определение местоположения получено')
                      : const Text('Согласие на определение местоположения отклонено'),
                  trailing: ElevatedButton(
                    child: const Text('Изменить'),
                    onPressed: () async {
                      final bool result = await showDialog(
                        context: context,
                        builder: (context) => const LocationDialog(),
                      );
                      MobileAds.setLocationConsent(result);
                      setState(() {});
                    },
                  ),
                ),*/
              ],
            )
          ],
        ),
      ),
    );
  }
}

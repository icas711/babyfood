import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/feature/domain/entities/convenience_food_entity.dart';
import 'package:babyfood/feature/domain/entities/guides_entity.dart';
import 'package:babyfood/feature/domain/entities/recipe_entity.dart';
import 'package:babyfood/feature/presentation/bloc/guide_list_cubit/guide_list_cubit.dart';
import 'package:babyfood/feature/presentation/bloc/guide_list_cubit/guide_list_state.dart';
import 'package:babyfood/feature/presentation/bloc/food_list_cubit/convenience_food_list_cubit.dart';
import 'package:babyfood/feature/presentation/bloc/food_list_cubit/convenience_food_list_state.dart';
import 'package:babyfood/feature/presentation/bloc/recipe_list_cubit/recipe_list_cubit.dart';
import 'package:babyfood/feature/presentation/bloc/recipe_list_cubit/recipe_list_state.dart';
import 'package:babyfood/feature/presentation/pages/account_screen.dart';
import 'package:babyfood/feature/presentation/pages/foods/foods_detail_screen.dart';
import 'package:babyfood/feature/presentation/pages/foods/foods_screen.dart';
import 'package:babyfood/feature/presentation/pages/home/home_details_screen.dart';
import 'package:babyfood/feature/presentation/pages/home/home_screen.dart';
import 'package:babyfood/feature/presentation/pages/login_screen.dart';
import 'package:babyfood/feature/presentation/pages/recipes/recipe_detail_screen.dart';
import 'package:babyfood/feature/presentation/pages/recipes/recipes_screen.dart';
import 'package:babyfood/feature/presentation/pages/settings/setting_screen.dart';
import 'package:babyfood/feature/presentation/pages/settings/widgets/login_widget.dart';
import 'package:babyfood/feature/presentation/pages/signup_screen.dart';
import 'package:babyfood/main.dart';
import 'package:babyfood/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final _shellNavigatorHomeKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorAKey = GlobalKey<NavigatorState>(debugLabel: 'shellA');
final _shellNavigatorBKey = GlobalKey<NavigatorState>(debugLabel: 'shellB');
final _shellNavigatorCKey = GlobalKey<NavigatorState>(debugLabel: 'shellC');

final goRouter = GoRouter(
  //initialLocation: '/home',
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
  initialLocation: '/',

  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              pageBuilder: (context, state) => NoTransitionPage(
                child: HomeScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'home-detail-:guideId',
                  name: 'home-detail',
                  builder: (context, state) {
                    final personId =
                        int.tryParse(state.pathParameters['guideId']!);
                    final _tyuw =
                        BlocProvider.of<GuideListCubit>(context).state;
                    final foodlist = (_tyuw as GuideLoaded).guidesList;
                    GuideEntity food = foodlist[0];
                    for (int i = 0; i < foodlist.length; i++) {
                      if (foodlist[i].id == personId) {
                        food = foodlist[i];
                      }
                    }
                    return HomeDetailsScreen(
                      guide: food,
                    );
                  },
                ),
                GoRoute(
                  path: 'login',
                  name: 'login',
                  pageBuilder: (context, state) => NoTransitionPage(
                    child: LoginScreen(),
                  ),
                ),GoRoute(
                  path: 'signup',
                  name: 'signup',
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: SignUpScreen(),
                  ),
                ),
                GoRoute(
                  path: 'account',
                  name: 'account',
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: AccountScreen(),
                  ),
                ),
              ],
            ),

          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorAKey,
          routes: [
            GoRoute(
              path: '/foods',
              name: 'foods',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: FoodsScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'product-detail-:foodId',
                  name: 'product-detail',
                  builder: (context, state) {
                    final personId =
                        int.tryParse(state.pathParameters['foodId']!);

                    final _tyuw =
                        BlocProvider.of<ConvenienceFoodListCubit>(context)
                            .state;
                    final foodlist = (_tyuw as FoodLoaded).foodsList;
                    ConvenienceFoodEntity food = foodlist[0];
                    for (int i = 0; i < foodlist.length; i++) {
                      if (foodlist[i].id == personId) {
                        food = foodlist[i];
                      }
                    }
                    return ProductDetailsScreen(
                      person: food,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorBKey,
          routes: [
            GoRoute(
              path: '/b',
              name: 'recipe',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: RecipeScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'recipe-detail-:recipeId',
                  name: 'recipe-detail',
                  builder: (context, state) {
                    final recipeId =
                        int.tryParse(state.pathParameters['recipeId']!);
                    final _tyuw =
                        BlocProvider.of<RecipeListCubit>(context).state;
                    final recipelist = (_tyuw as RecipeLoaded).recipesList;
                    RecipeEntity recipe = recipelist[0];
                    for (int i = 0; i < recipelist.length; i++) {
                      if (recipelist[i].id == recipeId) {
                        recipe = recipelist[i];
                      }
                    }
                    return RecipeDetailsScreen(
                      recipe: recipe,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorCKey,
          routes: [
            // Shopping Cart
            GoRoute(
              path: '/c',
              name: 'setting',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SettingScreen(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        animationDuration: const Duration(milliseconds: 0),
        //overlayColor: MaterialStateProperty.all(Colors.indigo),
        //elevation: 50,
        //surfaceTintColor: kPrimaryColor,
        //labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        indicatorColor: Colors.transparent,
        // Colors.blueGrey.shade100,
        //kBackgroundColor,
        //kPrimaryColor.withOpacity(0.23),
        //shadowColor: Colors.black87,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        selectedIndex: selectedIndex,
        //indicatorShape: Border,
        indicatorShape: const Border(
          top: BorderSide(
              color: kPrimaryColor, width: 3, style: BorderStyle.solid),
        ),
        destinations: const [
          NavigationDestination(
            label: 'Главная',
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
          ),
          NavigationDestination(
            label: 'Продукты',
            icon: //Image.asset('assets/images/mango.png',width: 30,),
                Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
          ),
          NavigationDestination(
            label: 'Рецепты',
            icon: Icon(Icons.receipt_outlined),
            selectedIcon: Icon(Icons.receipt),
          ),
          NavigationDestination(
            label: 'Настройки',
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
          ),
        ],
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}

class ScaffoldWithNavigationRail extends StatelessWidget {
  const ScaffoldWithNavigationRail({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            indicatorColor: kPrimaryColor.withOpacity(0.23),
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                  label: Text(
                    'Главная',
                    style: TextStyle(fontWeight: kFontWeight),
                  ),
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home)),
              NavigationRailDestination(
                  label: Text(
                    'Продукты',
                    style: TextStyle(fontWeight: kFontWeight),
                  ),
                  icon: Icon(Icons.search_outlined),
                  selectedIcon: Icon(Icons.search)),
              NavigationRailDestination(
                  label: Text(
                    'Рецепты',
                    style: TextStyle(fontWeight: kFontWeight),
                  ),
                  icon: Icon(Icons.receipt_outlined),
                  selectedIcon: Icon(Icons.receipt)),
              NavigationRailDestination(
                  label: Text(
                    'Настройки',
                    style: TextStyle(fontWeight: kFontWeight),
                  ),
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings)),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}

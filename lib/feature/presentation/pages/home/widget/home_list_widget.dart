import 'dart:async';

import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/feature/domain/entities/guides_entity.dart';
import 'package:babyfood/feature/presentation/bloc/guide_list_cubit/guide_list_cubit.dart';
import 'package:babyfood/feature/presentation/bloc/guide_list_cubit/guide_list_state.dart';
import 'package:babyfood/feature/presentation/pages/home/widget/guide_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuideList extends StatelessWidget {
  final scrollController = ScrollController();
  final int page = -1;

  GuideList({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return BlocBuilder<GuideListCubit, GuideState>(builder: (context, state) {
      List<GuideEntity> guides = [];
      bool isLoading = false;
      if (state is GuideLoading && state.isFirstFetch) {
        return _loadingIndicator();
      } else if (state is GuideLoading) {
        guides = state.oldGuidesList;
        isLoading = true;
      } else if (state is GuideLoaded) {
        guides = state.guidesList;
      } else if (state is GuideError) {
        return Text(
          state.message,
          style: const TextStyle(color: Colors.black87, fontSize: 25),
        );
      }
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          //margin: EdgeInsets.symmetric(vertical: 10.0),
          height: 300,
          child: GridView.builder(
            physics:  ScrollPhysics(),//NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: guides.length,
            itemBuilder: (context, index) {
              if (index < guides.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 8.0),
                  child: GuideCard(guide: guides[index]),
                );
              } else {
                Timer(const Duration(milliseconds: 30), () {
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent);
                });
                return _loadingIndicator();
              }
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //maxCrossAxisExtent: 300,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 7/4,
              crossAxisCount:1,
            ),
          ),
        );
      });
    });
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

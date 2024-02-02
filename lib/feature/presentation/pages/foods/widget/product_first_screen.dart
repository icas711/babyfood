import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/feature/presentation/widgets/custom_search_delegate.dart';
import 'package:babyfood/feature/presentation/widgets/persons_list_widget.dart';
import 'package:flutter/material.dart';


class FoodsPage extends StatelessWidget {
  const FoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Продукты', style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        shadowColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
        ],


      ),
      body: PersonsList(),
    );
  }
}
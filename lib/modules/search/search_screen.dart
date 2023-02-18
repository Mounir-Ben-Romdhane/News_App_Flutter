import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/news_app/cubit/cubit.dart';
import '../../layout/news_app/cubit/states.dart';
import '../../shared/components/components.dart';

class SearchScreen extends StatelessWidget
{
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<NewsCubit , NewsStates>(
      listener: (context , state) {},
      builder: (context , state)
      {
        List<dynamic> list = NewsCubit.get(context).search;

        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: defaultFormField(
                  controller: searchController,
                  type: TextInputType.text,
                  text: 'Search',
                  prefix: Icons.search,
                  onChange: (value)
                  {
                      NewsCubit.get(context).getSearch(value);
                  },
                  valide: (String? value)
                  {
                    if(value!.isEmpty)
                    {
                      return null;
                    }else{
                      'Search must not be empty!';
                    }
                    return null;
                  },
                ),
              ),
              Expanded(child: articleBuilder(list ,context , isSearch: true ),),
            ],
          ),
        );
      },
    );
  }
}

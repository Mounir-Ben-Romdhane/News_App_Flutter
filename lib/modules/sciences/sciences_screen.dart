import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/news_app/cubit/cubit.dart';
import '../../layout/news_app/cubit/states.dart';
import '../../shared/components/components.dart';

class SciencesScreen extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state ) {} ,
      builder: (context, state )
      {

        var list = NewsCubit.get(context).sciences;

        return ConditionalBuilder(
          condition: list.length > 0,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildArticleItem(list[index],context),
            separatorBuilder: (context , index) => myDivider(),
            itemCount: 10,
          ),
          fallback:  (context) => Center(child: CircularProgressIndicator()) ,
        );
      },
    );
  }
}

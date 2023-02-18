import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:news_app/layout/news_app/cubit/states.dart';

import '../../../modules/business/business_screen.dart';
import '../../../modules/sciences/sciences_screen.dart';
import '../../../modules/settings_screen/settings_screen.dart';
import '../../../modules/sports/sports_screen.dart';
import '../../../shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates>
{
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0 ;

  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
        icon: Icon(
          Icons.business_sharp,
        ),
        label: 'Business',
    ),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.sports,
        ),
        label: 'Sports',
    ),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.science,
        ),
        label: 'Sciences',
    ),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.settings,
        ),
        label: 'Settings',
    ),
  ];

  List<Widget> screens = [
    BusinessScreen(),
    SportsScreen(),
    SciencesScreen(),
    SettingsScreen(),
  ];

  void changeBottomNavBar(int index)
  {
    currentIndex = index;
    if(index == 1)
      getSports();
    else if(index == 2)
      getSciences();
    emit(NewsBottomNavState());
  }

  List<dynamic> business = [];

  void getBusiness()
  {
    emit(NewsGetBusinessLoadingState());

    if(business.length == 0 )
    {
      DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country':'eg',
            'category':'business',
            'apiKey':'d5c4fd5daf1b4911aabc85a5ca64407f',
          }
      ).then((value) {
        //print(value.data.toString());
        business = value.data['articles'];

        emit(NewsGetBusinessSeccusState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetBusinessErrorState(error.toString()));
      });
    }else
      {
        emit(NewsGetBusinessSeccusState());
      }
  }

  List<dynamic> sports = [];

  void getSports()
  {
    emit(NewsGetSportsLoadingState());

    if(sports.length == 0 )
    {
      DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country':'eg',
            'category':'sports',
            'apiKey':'d5c4fd5daf1b4911aabc85a5ca64407f',
          }
      ).then((value) {
        //print(value.data.toString());
        sports = value.data['articles'];

        emit(NewsGetSportsSeccusState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetSportsErrorState(error.toString()));
      });
    }else
    {
      emit(NewsGetSportsSeccusState());
    }
  }

  List<dynamic> sciences = [];

  void getSciences()
  {
    emit(NewsGetSciencesLoadingState());

    if(sciences.length == 0 )
    {
      DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country':'eg',
            'category':'science',
            'apiKey':'d5c4fd5daf1b4911aabc85a5ca64407f',
          }
      ).then((value) {
        //print(value.data.toString());
        sciences = value.data['articles'];

        emit(NewsGetSciencesSeccusState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetSciencesErrorState(error.toString()));
      });
    }else
      {
        emit(NewsGetSciencesSeccusState());
      }
  }

  List<dynamic> search = [];

  void getSearch(String value)
  {

    emit(NewsGetSearchLoadingState());

    search = [];

    DioHelper.getData(
        url: 'v2/everything',
        query: {
          'q':'$value',
          'apiKey':'d5c4fd5daf1b4911aabc85a5ca64407f',
        }
    ).then((value) {
      //print(value.data.toString());
      search = value.data['articles'];

      emit(NewsGetSearchSeccusState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetSearchErrorState(error.toString()));
    });

  }

}
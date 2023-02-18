import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:news_app/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

import '../network/local/cache_helper.dart';



class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitailState());

  static AppCubit get(context) => BlocProvider.of(context);

  late Database database;
  int currentIndex = 0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];



  void changeIndex(int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase()
  {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database , version) async
      {
        print('database created');
        await database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT , date TEXT , time TEXT , status TEXT) ')
            .then((value)
        {
          print('Table created');
        }).catchError((error){
          print('error when creating table ${error.toString()}');
        })
        ;
      },
      onOpen: (database)
      {
        getDataFromDatabase(database);
        print("database opened");
      },
    ).then((value)
    {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase(
      @required String title,
      @required String date,
      @required String time,
      ) async
  {
    await database.transaction( (txn)
    => txn.rawInsert(
      'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
    ).then((value)
    {
      print('$value inserted successfully');
      emit(AppInsertDatabaseState());

      getDataFromDatabase(database);
    }
    ).catchError((error)
    {
      print('error when inserting to table ${error.toString()}');
    }
    )
    );
  }

 void getDataFromDatabase(database) async
  {
    emit(AppGetDatabaseLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value)
    {
      newTasks = [];
      doneTasks = [];
      archivedTasks = [];

      value.forEach((element)
      {
        if(element['status'] == 'new')
          newTasks.add(element);
        else if(element['status'] == 'done')
          doneTasks.add(element);
        else archivedTasks.add(element);
      });

      emit(AppGetDatabaseState());
    });
  }

  void updateDatabase({
    required String status,
    required int id,
  }) async
  {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id ]
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteDatabase({
    required int id,
  }) async
  {
    database.rawUpdate('DELETE FROM tasks WHERE id = ?',
        [id]
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  })
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    
    emit(AppChangeBottomSheetState());
  }

  bool isDark = false;

  void changeAppMode({bool? fromShared})
  {
    if(fromShared != null)
    {
      isDark = fromShared;
      emit(AppChangeModeState());
    }
    else
    {
      isDark = !isDark;
      CacheHelper.putData(key: 'isDark', value: isDark).then((value)
      {
        emit(AppChangeModeState());
      });
    }
  }

}
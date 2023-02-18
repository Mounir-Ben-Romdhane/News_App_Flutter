

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:news_app/shared/cubit/cubit.dart';

import '../../modules/web_view/web_view_screen.dart';

Widget defaultButton({
  double weight = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double raduis = 10.0,
  required Function() function,
  required String text,
}) =>
    Container(
      width: weight,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(raduis),
        color: background,
      ),
      child: MaterialButton(
      onPressed: function,
      child: Text(
      isUpperCase ? text.toUpperCase() : text,
      style: TextStyle(
      color: Colors.white,
      ),
      ),
      ),
      );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String)? onSubmit,
  Function(String)? onChange,
  Function()? onTap,
  bool isPassword = false,
  required String text,
  required IconData prefix,
  required String? Function(String?)? valide,
  IconData? suffix,
  Function()? suffixPressed,
  bool isClickable = true,
}) => TextFormField(
  controller: controller,
  keyboardType: type,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  enabled: isClickable,
  obscureText: isPassword,
  validator: valide,
  onTap: onTap,
  decoration: InputDecoration(
    labelText: text,
    prefixIcon: Icon(
      prefix,
    ),
    suffixIcon: suffix != null ? IconButton(
      onPressed: suffixPressed,
      icon: Icon(
        suffix,
      ),
    ) : null,
    border: OutlineInputBorder(),
  ),
);



Widget buildTaskItem(Map model,context) => Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(

      children: [

        CircleAvatar(

          radius: 40.0,

          child: Text(

            '${model['time']}',

          ),

        ),

        SizedBox(

          width: 20.0,

        ),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(

                '${model['title']}',

                style: TextStyle(

                  fontSize: 20.0,

                  fontWeight: FontWeight.bold,

                ),

              ),

              SizedBox(

                height: 4.0,

              ),

              Text(

                '${model['date']}',

                style: TextStyle(

                  color: Colors.grey,

                ),

              ),

            ],

          ),

        ),

        SizedBox(

          width: 20.0,

        ),

        IconButton(

          color: Colors.green,

          icon: Icon(

              Icons.check_circle

          ), onPressed: ()

        {

          AppCubit.get(context).updateDatabase(

            status: 'done',

            id: model['id'],

          );

        },

        ),

        IconButton(

          color: Colors.grey,

          icon: Icon(

              Icons.archive

          ), onPressed: ()

        {

          AppCubit.get(context).updateDatabase(

            status: 'archive',

            id: model['id'],

          );

        },

        ),

      ],

    ),

  ),
  onDismissed: (direction) {
    AppCubit.get(context).deleteDatabase(id: model['id'],);
  },
);

Widget myDivider() => Container(
  width: double.infinity,
  height: 3.0,
  color: Colors.grey[300],
);

Widget buildArticleItem(article , context) => InkWell(
  onTap: ()
  {
    navigateTo(context, WebViewScreen(
      article['url']
    ),
    );
  },
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        Container(

          width: 120.0,

          height: 120.0,

          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(10.0,),

            image: DecorationImage(

              image: NetworkImage('${article['urlToImage']}'),

              fit: BoxFit.cover,

            ),

          ),

        ),

        SizedBox(

          width: 20.0,

        ),

        Expanded(

          child: Container(

            height: 120.0,

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.start,

              children: [

                Expanded(

                  child: Text(

                    '${article['title']}',

                    style: Theme.of(context).textTheme.bodyText1,

                    maxLines: 3,

                    overflow: TextOverflow.ellipsis,

                  ),

                ),

                Text(

                  '${article['publishedAt']}',

                  style: TextStyle(

                    fontSize: 13.0,

                    color: Colors.grey,

                  ),

                ),

              ],

            ),

          ),

        ),

      ],

    ),

  ),
);

Widget articleBuilder(list , context , {isSearch = false}) => ConditionalBuilder(
  condition: list.length > 0,
  builder: (context) => ListView.separated(
    physics: BouncingScrollPhysics(),
    itemBuilder: (context, index) => buildArticleItem(list[index] ,context),
    separatorBuilder: (context , index) => myDivider(),
    itemCount: 10,
  ),
  fallback:  (context) => isSearch ? Container() : Center(child: CircularProgressIndicator()) ,
);

void navigateTo(context, Widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => Widget,
  ),
);
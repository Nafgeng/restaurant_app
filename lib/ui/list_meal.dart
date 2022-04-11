import 'package:flutter/material.dart';
import 'package:restaurant_app/model/reponse_filter.dart';
import 'package:restaurant_app/page/detail_page.dart';
import 'item_meal.dart';

Widget listMeals(ResponseFilter? responseFilter) {
  if (responseFilter == null) {
    return Container();
  }
  return ListView.builder(
      itemCount: responseFilter.meals!.length,
      itemBuilder: (context, index) {
       var itemMeal = responseFilter.meals?[index];
       
       return InkWell(
         splashColor: Colors.lightBlue,
         child:
         itemMeals(itemMeal?.idMeal, itemMeal?.strMeal, itemMeal?.strMealThumb),
           onTap: () {
           Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(idMeal: itemMeal?.idMeal ?? "",)));
       },
       );
    }
  );
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restaurant_app/database/db_helper.dart';
import 'package:restaurant_app/model/meal_item.dart';
import 'package:restaurant_app/model/response_detail.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final String idMeal;

  DetailPage({required this.idMeal});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late ResponseDetail responseDetail;
  bool isLoading = true;
  bool isFavourite = false;
  var db = DBHelper();

  Future<ResponseDetail?> fetchDetail() async {
    try {
      var res = await http.get(Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.idMeal}'));

      isFavourite = await db.isFavourite(widget.idMeal);

      print('favorite : $isFavourite');
      if (res.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(res.body);
        ResponseDetail data = ResponseDetail.fromJson(json);
        if (mounted) {
          setState(() {
            responseDetail = data;
            isLoading = false;
          });
        }
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print('Failed $e');
      return null;
    }
  }

  setFavorite() async {
    var db = DBHelper();
    Meal favorite = Meal(
      idMeal: responseDetail.meals[0]['idMeal'],
      strMeal: responseDetail.meals[0]['strMeal'],
      strMealThumb: responseDetail.meals[0]['strMealThumb'],
      strInstructions: responseDetail.meals[0]['strInstructions'],
      strCategory: responseDetail.meals[0]['strCategory'],
    );

    if (!isFavourite) {
      await db.insert(favorite);
      print("data favorite ditambahkan");
    } else {
      await db.delete(favorite);
      print("data favorite dihapus");
    }

    setState(() {
      isFavourite = !isFavourite;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Resep'),
        actions: [
          IconButton(
            icon:
            isFavourite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
            onPressed: () {
              setFavorite();
            },
          )
        ],
      ),
      body: Center(
        child: FutureBuilder<ResponseDetail?>(
          future: fetchDetail(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator(
                backgroundColor: Colors.orange,
                strokeWidth: 5,
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    child: Center(
                      child: Hero(
                        child: Material(
                          child: Image.network(
                              responseDetail.meals[0]['strMealThumb']),
                        ),
                        tag: '${responseDetail.meals[0]['idMeal']}',
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Text('${responseDetail.meals[0]['strMeal']}'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Text('Instructions'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child:
                      Text('${responseDetail.meals[0]['strInstructions']}'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
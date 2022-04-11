import 'package:flutter/material.dart';
import 'package:restaurant_app/database/db_helper.dart';
import 'package:restaurant_app/model/reponse_filter.dart';
import 'package:restaurant_app/ui/list_meal.dart';

class FavouritePage extends StatefulWidget {
  final int indexNav;
  const FavouritePage({Key? key, required this.indexNav}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  int currentIndex = 0;
  String category = "Seafood";
  ResponseFilter? responseFilter;
  bool isLoading = true;
  var db = DBHelper();

  void fetchDataMeals() async {
    var data = await db.gets(category);
    setState(() {
      responseFilter = ResponseFilter(meals: data);
      isLoading = false;
    });
  }

  @override
  void initState(){
    // TODO : implement initState
    super.initState();
    fetchDataMeals();
    currentIndex = widget.indexNav;
  }

  @override
  Widget build(BuildContext context) {
    var listNav = [listMeals(responseFilter), listMeals(responseFilter)];
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite Recipe'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: isLoading == false
        ?listNav[currentIndex]
        : CircularProgressIndicator(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber,
        currentIndex: currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Seafood"),
          BottomNavigationBarItem(icon: Icon(Icons.cake), label: "Dessert"),
        ],
        onTap: (index){
          setState(() {
            currentIndex = index;
            index == 0 ? category = "Seafood" : category = "Dessert";
          });
          fetchDataMeals();
        },
      ),
    );
  }
}

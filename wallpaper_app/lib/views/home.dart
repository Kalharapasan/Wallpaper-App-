import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaper_app/data/data.dart';
import 'package:wallpaper_app/model/categories_model.dart';
import 'package:wallpaper_app/widgets/widgets.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  
  @override
  _HomeState createState() => _HomeState();
  
}

class _HomeState extends State<Home> {

  List<CategoriesModel> categories = [];

  getTrendingWallpapers () async{
    var response = await http.get(Uri.parse("https://api.pexels.com/v1/curated?per_page=1"),
    headers:{
      "Authorization":apiKey
    });
    //print(response.body.toString());

    Map<String,dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element){
      print(element);
    });

  }

  @override
  void initState() {
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            
            Container(
              decoration: BoxDecoration(
                color: Color(0xfff5f8fd),
                borderRadius: BorderRadius.circular(30)
              ),
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search wallpaper",
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  Icon(Icons.search)
                ],
              )
            ),

            SizedBox(height: 16,),
            Container(
              height: 80,
              child:ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24),
              itemCount: categories.length,
              shrinkWrap: true,
              scrollDirection:Axis.horizontal,
              itemBuilder: (context,index){
                return CategoriesTitle(
                  title: categories[index].categoriesName,
                  imgUrl: categories[index].imgUrl,
                );
              },
            ),

            )
            
          ],
        ),
      ),
    );
  }
}

class CategoriesTitle extends StatelessWidget {
  final String imgUrl ,title;
  CategoriesTitle ({required this.title,required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4),

      child: Stack(children:<Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(imgUrl,width: 100,height: 50,fit: BoxFit.cover,),
        ),
        Container(
          width: 100,
          height: 50,
          color: Colors.black26,
          alignment: Alignment.center,
          child: Text(title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 15
            ),
          ),
        )
      ],),
    );
  }
}

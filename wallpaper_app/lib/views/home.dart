import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/data/data.dart';
import 'package:wallpaper_app/model/categories_model.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';
import 'package:wallpaper_app/views/categorie.dart';
import 'package:wallpaper_app/views/search.dart';
import 'package:wallpaper_app/widgets/widgets.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoriesModel> categories = [];
  List<WallpaperModel> wallpapers = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  Future<void> getTrendingWallpapers() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/curated?per_page=30"),
        headers: {"Authorization": apiKey},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        wallpapers.clear();
        
        jsonData["photos"].forEach((element) {
          WallpaperModel wallpaperModel = WallpaperModel.fromMap(element);
          if (wallpaperModel.src?.portrait != null) {
            wallpapers.add(wallpaperModel);
          }
        });

        setState(() {
          isLoading = false;
        });
      } else {
        print("Failed to load wallpapers: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching wallpapers: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTrendingWallpapers();
    categories = getCategories();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xfff5f8fd),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: "Search wallpaper",
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchView(
                                  searchQuery: value,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (searchController.text.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchView(
                                searchQuery: searchController.text,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Icon(Icons.search),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Categories Section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Categories List
              Container(
                height: 80,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CategoriesTitle(
                      title: categories[index].categoriesName,
                      imgUrl: categories[index].imgUrl,
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Trending Wallpapers Section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Trending Wallpapers",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        getTrendingWallpapers();
                      },
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Wallpapers Grid
              isLoading
                  ? Container(
                      height: 400,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : wallpapers.isEmpty
                      ? Container(
                          height: 400,
                          child: const Center(
                            child: Text(
                              "No wallpapers found",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      : wallpapersList(
                          wallpapers: wallpapers,
                          context: context,
                        ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesTitle extends StatelessWidget {
  final String imgUrl, title;
  const CategoriesTitle({super.key, required this.title, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategorieView(
              categoryName: title,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgUrl,
                width: 100,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

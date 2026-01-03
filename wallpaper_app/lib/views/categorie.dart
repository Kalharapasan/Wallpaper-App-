import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/data/data.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';
import 'package:wallpaper_app/widgets/widgets.dart';
import 'package:http/http.dart' as http;

class CategorieView extends StatefulWidget {
  final String categoryName;
  
  const CategorieView({super.key, required this.categoryName});

  @override
  _CategorieViewState createState() => _CategorieViewState();
}

class _CategorieViewState extends State<CategorieView> {
  List<WallpaperModel> wallpapers = [];
  bool isLoading = true;

  Future<void> getCategoryWallpapers() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=${widget.categoryName}&per_page=30"),
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
    getCategoryWallpapers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.categoryName,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ],
        ),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Container(width: 48), 
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16),
              if (!isLoading && wallpapers.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${wallpapers.length} wallpapers",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          getCategoryWallpapers();
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
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "No wallpapers found",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Try another category",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
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
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/data/data.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';
import 'package:wallpaper_app/widgets/widgets.dart';
import 'package:http/http.dart' as http;

class SearchView extends StatefulWidget {
  final String searchQuery;
  
  const SearchView({super.key, required this.searchQuery});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<WallpaperModel> wallpapers = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  Future<void> getSearchWallpapers(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$query&per_page=30"),
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
    searchController.text = widget.searchQuery;
    getSearchWallpapers(widget.searchQuery);
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              "Search",
              style: TextStyle(
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
      
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xfff5f8fd),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                            getSearchWallpapers(value);
                          }
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (searchController.text.isNotEmpty) {
                          getSearchWallpapers(searchController.text);
                        }
                      },
                      child: const Icon(Icons.search),
                    ),
                  ],
                ),
              ),

              if (!isLoading && wallpapers.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${wallpapers.length} results found",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
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
                                  Icons.search_off,
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
                                  "Try searching for something else",
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

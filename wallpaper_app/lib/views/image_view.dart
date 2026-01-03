import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:gal/gal.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;
  final String photographer;

  const ImageView({super.key, required this.imgUrl, required this.photographer});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool _isDownloading = false;
  bool _isSettingWallpaper = false;

  Future<void> _downloadImage() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      if (Platform.isAndroid) {
        var photosStatus = await Permission.photos.status;
        if (!photosStatus.isGranted) {
          photosStatus = await Permission.photos.request();
        }
      }
      var response = await http.get(Uri.parse(widget.imgUrl));
      
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final fileName = 'wallpaper_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);
        await Gal.putImage(file.path);

        setState(() {
          _isDownloading = false;
        });

        _showSnackBar("Wallpaper saved to gallery!", Colors.green);
      } else {
        setState(() {
          _isDownloading = false;
        });
        _showSnackBar("Failed to download image", Colors.red);
      }
    } catch (e) {
      setState(() {
        _isDownloading = false;
      });
      print("Download error: $e");
      _showSnackBar("Error downloading wallpaper: $e", Colors.red);
    }
  }
  Future<void> _setWallpaper(int location) async {
    setState(() {
      _isSettingWallpaper = true;
    });

    try {
      var file = await DefaultCacheManager().getSingleFile(widget.imgUrl);
      bool result = await WallpaperManager.setWallpaperFromFile(
        file.path,
        location,
      );

      setState(() {
        _isSettingWallpaper = false;
      });

      if (result == 1) {
        String locationText = location == WallpaperManager.HOME_SCREEN
            ? "Home Screen"
            : location == WallpaperManager.LOCK_SCREEN
                ? "Lock Screen"
                : "Both Screens";
        _showSnackBar("Wallpaper set on $locationText!", Colors.green);
      } else {
        _showSnackBar("Failed to set wallpaper", Colors.red);
      }
    } catch (e) {
      setState(() {
        _isSettingWallpaper = false;
      });
      print("Set wallpaper error: $e");
      _showSnackBar("Error setting wallpaper: $e", Colors.red);
    }
  }
  void _showWallpaperOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Set Wallpaper",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.blue),
                title: const Text("Home Screen"),
                onTap: () {
                  Navigator.pop(context);
                  _setWallpaper(WallpaperManager.HOME_SCREEN);
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.blue),
                title: const Text("Lock Screen"),
                onTap: () {
                  Navigator.pop(context);
                  _setWallpaper(WallpaperManager.LOCK_SCREEN);
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone_android, color: Colors.blue),
                title: const Text("Both"),
                onTap: () {
                  Navigator.pop(context);
                  _setWallpaper(WallpaperManager.BOTH_SCREEN);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Hero(
            tag: widget.imgUrl,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.imgUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Text(
                      "By ${widget.photographer}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 48), 
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isDownloading ? null : _downloadImage,
                      icon: _isDownloading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.download),
                      label: Text(_isDownloading ? "Downloading..." : "Download"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isSettingWallpaper ? null : _showWallpaperOptions,
                      icon: _isSettingWallpaper
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.wallpaper),
                      label: Text(_isSettingWallpaper ? "Setting..." : "Set Wallpaper"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

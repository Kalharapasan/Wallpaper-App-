# WallpaperHub - Flutter Wallpaper App

A beautiful and feature-rich wallpaper application built with Flutter that uses the Pexels API to fetch high-quality wallpapers.

## 📱 Features

### ✅ Completed Features
- **Browse Trending Wallpapers**: View the latest and most popular wallpapers
- **Search Functionality**: Search for wallpapers by keywords
- **Category Browsing**: Browse wallpapers by predefined categories (Nature, City, Cars, etc.)
- **Full-Screen Preview**: View wallpapers in full-screen mode with Hero animations
- **Download Wallpapers**: Save wallpapers directly to your device gallery
- **Set as Wallpaper**: Set images as home screen, lock screen, or both
- **Beautiful UI**: Clean and modern Material Design interface
- **Loading States**: Proper loading indicators and error handling
- **Image Caching**: Efficient image caching for better performance

## 🏗️ Project Structure

```
wallpaper_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── data/
│   │   └── data.dart            # API key and category data
│   ├── model/
│   │   ├── categories_model.dart # Category model
│   │   └── wallpaper_model.dart  # Wallpaper model
│   ├── views/
│   │   ├── home.dart            # Home screen
│   │   ├── search.dart          # Search screen
│   │   ├── categorie.dart       # Category screen
│   │   └── image_view.dart      # Full-screen image viewer
│   └── widgets/
│       └── widgets.dart         # Reusable widgets
├── android/
│   └── app/
│       └── src/
│           └── main/
│               └── AndroidManifest.xml
└── pubspec.yaml
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Android Studio / VS Code
- Android device or emulator (API level 21+)

### Installation Steps

1. **Clone or create the project**
   ```bash
   flutter create wallpaper_app
   cd wallpaper_app
   ```

2. **Replace the default files with the provided files**
   - Copy all the provided .dart files to their respective locations
   - Replace `pubspec.yaml` with the provided version
   - Replace `android/app/src/main/AndroidManifest.xml`

3. **Get Pexels API Key**
   - Go to [Pexels API](https://www.pexels.com/api/)
   - Sign up for a free account
   - Copy your API key
   - Open `lib/data/data.dart` and replace the `apiKey` value with your key

4. **Install dependencies**
   ```bash
   flutter pub get
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

```yaml
dependencies:
  http: ^1.1.0                          # API calls
  cached_network_image: ^3.3.0         # Image caching
  flutter_cache_manager: ^3.3.1        # Cache management
  image_gallery_saver: ^2.0.3          # Save images to gallery
  flutter_wallpaper_manager: ^0.0.3    # Set wallpaper
  permission_handler: ^11.0.1           # Handle permissions
  path_provider: ^2.1.1                 # File system paths
```

## 🔑 Required Permissions

The app requires the following Android permissions (already added in AndroidManifest.xml):

- `INTERNET` - For fetching wallpapers from Pexels API
- `WRITE_EXTERNAL_STORAGE` - For saving images (Android 12 and below)
- `READ_EXTERNAL_STORAGE` - For reading images (Android 12 and below)
- `READ_MEDIA_IMAGES` - For accessing images (Android 13+)
- `SET_WALLPAPER` - For setting wallpapers

## 📱 How to Use

1. **Browse Wallpapers**
   - Open the app to see trending wallpapers
   - Scroll through the grid of wallpapers
   - Tap on any wallpaper to view it in full screen

2. **Search Wallpapers**
   - Use the search bar at the top
   - Enter keywords (e.g., "nature", "cars", "mountains")
   - Tap search or press enter

3. **Browse by Category**
   - Scroll through the horizontal category list
   - Tap on any category to view wallpapers in that category

4. **Download Wallpapers**
   - Tap on a wallpaper to open full-screen view
   - Tap the "Download" button at the bottom
   - Grant storage permission if prompted
   - Wallpaper will be saved to your gallery

5. **Set as Wallpaper**
   - Open a wallpaper in full-screen view
   - Tap the "Set Wallpaper" button
   - Choose where to set it:
     - Home Screen
     - Lock Screen
     - Both

## 🎨 Customization

### Adding More Categories
Edit `lib/data/data.dart` and add more categories to the `getCategories()` function:

```dart
categories.add(CategoriesModel(
  imgUrl: "https://images.pexels.com/photos/YOUR_IMAGE_ID/...",
  categoriesName: "Your Category Name",
));
```

### Changing Theme Colors
Edit `lib/main.dart` in the `MaterialApp` theme section:

```dart
theme: ThemeData(
  primaryColor: Colors.yourColor,
  // ... other theme properties
),
```

### Adjusting Wallpaper Count
In any of the API calls, change the `per_page` parameter:

```dart
"https://api.pexels.com/v1/curated?per_page=30"  // Change 30 to your desired number
```

## 🐛 Common Issues & Solutions

### Issue: "Failed to load wallpapers"
**Solution**: Check your API key in `lib/data/data.dart` and ensure you have internet connection.

### Issue: "Permission denied" when downloading
**Solution**: Grant storage permissions in app settings.

### Issue: "Failed to set wallpaper"
**Solution**: Ensure SET_WALLPAPER permission is granted. Some devices may have restrictions.

### Issue: Images not loading
**Solution**: Check internet connection and verify the Pexels API is accessible.

## 📄 File Locations

Place the files in the following structure:

```
lib/
├── main.dart
├── data/
│   └── data.dart
├── model/
│   ├── categories_model.dart
│   └── wallpaper_model.dart
├── views/
│   ├── home.dart
│   ├── search.dart
│   ├── categorie.dart
│   └── image_view.dart
└── widgets/
    └── widgets.dart

android/app/src/main/
└── AndroidManifest.xml
```

## 🔄 API Rate Limits

Pexels API free tier provides:
- 200 requests per hour
- 20,000 requests per month

If you exceed these limits, you'll need to wait or upgrade your plan.

## 🌟 Future Enhancements

Potential features to add:
- Favorites/Bookmarks
- Share wallpapers
- Collections
- Dark mode
- Multiple API sources
- User accounts
- Download history
- Wallpaper of the day

## 📝 [License](./LICENSE.md): Proprietary – Permission Required

This project is for educational purposes. Make sure to comply with Pexels API terms of service.

## 🙏 Credits

- **Pexels**: For providing the amazing wallpaper API
- **Flutter**: For the fantastic cross-platform framework
- All the photographers whose work is featured through Pexels

## 📞 Support

If you encounter any issues:
1. Check the troubleshooting section above
2. Ensure all dependencies are installed correctly
3. Verify your API key is correct
4. Check Android permissions are granted

## 🔧 Build APK

To build a release APK:

```bash
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

---

**Happy Coding! 🎉**

import 'package:wallpaper_app/model/categories_model.dart';

List<CategoriesModel> getCategories() {
  List<CategoriesModel> categories = [];

  // Street Art
  categories.add(CategoriesModel(
    imgUrl: "https://images.pexels.com/photos/2119706/pexels-photo-2119706.jpeg",
    categoriesName: "Street Art",
  ));

  // Wild Life
  categories.add(CategoriesModel(
    imgUrl: "https://images.pexels.com/photos/625727/pexels-photo-625727.jpeg",
    categoriesName: "Wild Life",
  ));

  // Nature
  categories.add(CategoriesModel(
    imgUrl: "https://images.pexels.com/photos/1386604/pexels-photo-1386604.jpeg",
    categoriesName: "Nature",
  ));

  // City
  categories.add(CategoriesModel(
    imgUrl: "https://images.pexels.com/photos/378570/pexels-photo-378570.jpeg",
    categoriesName: "City",
  ));

  // Motivation
  categories.add(CategoriesModel(
    imgUrl: "https://images.pexels.com/photos/3806690/pexels-photo-3806690.jpeg",
    categoriesName: "Motivation",
  ));

  // Bikes
  categories.add(CategoriesModel(
    imgUrl: "https://images.pexels.com/photos/2549941/pexels-photo-2549941.jpeg",
    categoriesName: "Bikes",
  ));

  // Cars
  categories.add(CategoriesModel(
    imgUrl: "https://images.pexels.com/photos/305070/pexels-photo-305070.jpeg",
    categoriesName: "Cars",
  ));

  // Girls
  categories.add(CategoriesModel(
    imgUrl: "https://images.pexels.com/photos/514914/pexels-photo-514914.jpeg",
    categoriesName: "Girls",
  ));

  return categories;
}
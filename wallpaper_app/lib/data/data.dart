import 'package:wallpaper_app/model/categories_model.dart';

String apiKey = "Z6MHat9hGqWdnf2Vv9l8ShSagjhuNcBwkqc4zj08Ac5aGPoHTcSCjPeX";

List<CategoriesModel> getCategories() {
  List<CategoriesModel> categories = [];

  categories.add(CategoriesModel(
    imgUrl: "https://images.pexels.com/photos/2119706/pexels-photo-2119706.jpeg",
    categoriesName: "Street Art",
  ));

  categories.add(CategoriesModel(
    imgUrl: "https://images.pexels.com/photos/625727/pexels-photo-625727.jpeg",
    categoriesName: "Wild Life",
  ));

  categories.add(CategoriesModel(
    imgUrl: "https://images.pexels.com/photos/1386604/pexels-photo-1386604.jpeg",
    categoriesName: "Nature",
  ));

  categories.add(CategoriesModel(
    imgUrl: "https://images.pexels.com/photos/378570/pexels-photo-378570.jpeg",
    categoriesName: "City",
  ));

  categories.add(CategoriesModel(
    imgUrl: "https://images.pexels.com/photos/3806690/pexels-photo-3806690.jpeg",
    categoriesName: "Motivation",
  ));

  categories.add(CategoriesModel(
    imgUrl: "https://images.pexels.com/photos/2549941/pexels-photo-2549941.jpeg",
    categoriesName: "Bikes",
  ));

  categories.add(CategoriesModel(
    imgUrl: "https://images.pexels.com/photos/305070/pexels-photo-305070.jpeg",
    categoriesName: "Cars",
  ));

  categories.add(CategoriesModel(
    imgUrl: "https://images.pexels.com/photos/1181391/pexels-photo-1181391.jpeg",
    categoriesName: "Technology",
  ));

  categories.add(CategoriesModel(
    imgUrl: "https://images.pexels.com/photos/356079/pexels-photo-356079.jpeg",
    categoriesName: "Space",
  ));

  categories.add(CategoriesModel(
    imgUrl: "https://images.pexels.com/photos/1566837/pexels-photo-1566837.jpeg",
    categoriesName: "Ocean",
  ));

  return categories;
}